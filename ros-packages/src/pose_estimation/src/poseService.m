function resp = poseService(~, reqMsg, respMsg)

timerval = tic;

global objModels
global objNames
global emptyShelfModels

% grid size for downsampling point clouds
gridStep = 0.002; 

% hack for Pose initialization with PCA
pushBackAxis = [1; 0; -1];

% parameter for ICP
icpWorstRejRatio = 0.9; % ratio of outlier points to ignore during ICP

frames = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15];
viewBounds = [-0.01, 0.40; -0.17, 0.17; -0.06, 0.20];

% Objects
apc_objects_strs = containers.Map(...
 {'crayola_24_ct', 'expo_dry_erase_board_eraser', 'folgers_classic_roast_coffee',...
  'scotch_duct_tape', 'dasani_water_bottle', 'jane_eyre_dvd',...
  'up_glucose_bottle', 'laugh_out_loud_joke_book', 'soft_white_lightbulb',...
  'kleenex_tissue_box', 'ticonderoga_12_pencils', 'dove_beauty_bar',...
  'dr_browns_bottle_brush', 'elmers_washable_no_run_school_glue', 'rawlings_baseball'...
},{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15});

% Path configurations
repo_path = getenv('PHYSIM_6DPose_PATH');
toolboxPath = repo_path; % Directory of toolbox utilities
tmpDataPath = strcat(repo_path,'/tmp'); % Temporary directory used by marvin_convnet, where all RGB-D images and detection masks are saved
modelsPath = './models/objects'; % Directory holding pre-scanned object models

init_pose = strcat(repo_path,'/tmp/init_pose.txt');
final_pose = strcat(repo_path,'/tmp/final_pose.txt');

% Add paths and create directories
addpath(genpath(fullfile(toolboxPath,'rgbd-utils')));

scenePath = reqMsg.SceneFiles; % Directory holding the RGB-D data of scene
calibPath = reqMsg.CalibrationFiles; % Directory holding camera pose calibration of scene

% Remove all files in temporary folder used by marvin_convnet
if exist(fullfile(tmpDataPath,'raw'),'file')
    rmdir(fullfile(tmpDataPath,'raw'),'s');
end
if exist(fullfile(tmpDataPath,'results'),'file')
    rmdir(fullfile(tmpDataPath,'results'),'s');
end
if exist(fullfile(tmpDataPath,'masks'),'file')
    rmdir(fullfile(tmpDataPath,'masks'),'s');
end
if exist(fullfile(tmpDataPath,'segm'),'file')
    rmdir(fullfile(tmpDataPath,'segm'),'s');
end
if exist(fullfile(tmpDataPath,'bbox_detections'),'file')
    rmdir(fullfile(tmpDataPath,'bbox_detections'),'s');
end
delete(fullfile(tmpDataPath,'*'));

% Copy current scene to temporary folder used by marvin_convnet
if exist(fullfile(scenePath,'bbox_detections'),'file')
    rmdir(fullfile(scenePath,'bbox_detections'),'s');
end

copyfile(fullfile(scenePath,'*'),tmpDataPath);

ip = fopen(init_pose, 'wt');

% Load sample scene data
fprintf('[Processing] Loading scene RGB-D data\n');
sceneData = loadScene(tmpDataPath);
numFrames = length(sceneData.colorFrames);

% Calibrate scene
sceneData = loadCalib(calibPath,sceneData);

% Fill holes in depth frames for scene
for frameIdx = 1:length(sceneData.depthFrames)
    sceneData.depthFrames{frameIdx} = fillHoles(sceneData.depthFrames{frameIdx});
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% GET 2-D SEGMENTATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Call RCNN detector to do 2D object segmentation for each RGB-D frame
active_list = zeros(1,size(sceneData.objects,2));
for obIdx = 1:size(sceneData.objects,2)
    active_list(1,obIdx) = apc_objects_strs(sceneData.objects{1,obIdx});
end
disp(active_list);
[client,reqMsg] = rossvcclient('/update_active_list_and_frame');
[client2,reqMsg2] = rossvcclient('/update_bbox');
for frameIdx = 0:(numFrames-1)
    fprintf('%d ',frameIdx);
    frameStr = sprintf('%06d',frameIdx);
    reqMsg.ActiveList = active_list;
    reqMsg.ActiveFrame = frameStr;
    call(client,reqMsg);
    reqMsg2.Request = 1;
    response = call(client2,reqMsg2);
end

mkdir(fullfile(scenePath,'bbox_detections'));
copyfile(fullfile(tmpDataPath,'bbox_detections','*'),fullfile(scenePath,'bbox_detections'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% GET POINT CLOUD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
toc(timerval)

% Load scene point cloud
fprintf('[Processing] Loading scene point clouds\n');
scenePointCloud = getScenePointCloud(sceneData);
pcwrite(scenePointCloud,fullfile(scenePath,'scene'),'PLYFormat','binary');

% Load and align empty bin/tote point cloud to observation to get the transform
binIds = 'ABCDEFGHIJKL';
backgroundPointCloud = emptyShelfModels{strfind(binIds,sceneData.binId)};
[tform,backgroundPointCloud] = pcregrigidGPU(backgroundPointCloud,scenePointCloud,'InlierRatio',0.8,'MaxIterations',200,'Tolerance',[0.0001,0.0009],'Verbose',false,'Extrapolate',true);
extBin2Bg = inv(tform.T');

toc(timerval)

% Iterate over each Object in Scene
for obIdx = 1:size(sceneData.objects,2)
    % Search through mask files in data directory
    maskFiles = dir(fullfile(tmpDataPath,'bbox_detections',sprintf('*.%s.mask.png',sceneData.objects{1,obIdx})));
    scoreFiles = dir(fullfile(tmpDataPath,'bbox_detections',sprintf('*.%s.score.txt',sceneData.objects{1,obIdx})));
    objMasks = {};
    allCamColors = [];
    objSegmPts = [];
    for frameIdx = frames
        objMasks{frameIdx} = imread(fullfile(tmpDataPath,'bbox_detections',maskFiles(frameIdx).name));
        file = fopen(fullfile(tmpDataPath,'bbox_detections',scoreFiles(frameIdx).name),'r');
        score = fscanf(file,'%f');
        fclose(file);
        if score > 0.3
            tmpObjMask = objMasks{frameIdx};
            tmpDepth = sceneData.depthFrames{frameIdx};
            color = sceneData.colorFrames{frameIdx};
            tmpExtCam2World = sceneData.extCam2World{frameIdx};
            tmpExtCam2Bin = sceneData.extWorld2Bin * tmpExtCam2World;
            
            % Apply segmentation mask to depth image and project to camera space
            tmpDepth = tmpDepth.*double(tmpObjMask);
            [pixX,pixY] = meshgrid(1:640,1:480);
            camX = (pixX-sceneData.colorK(1,3)).*tmpDepth/sceneData.colorK(1,1);
            camY = (pixY-sceneData.colorK(2,3)).*tmpDepth/sceneData.colorK(2,2);
            camZ = tmpDepth;
            validDepth = find((camZ > 0.1) & (camZ < 1));
            camPts = [camX(validDepth),camY(validDepth),camZ(validDepth)]';
            camPts = tmpExtCam2Bin(1:3,1:3) * camPts + repmat(tmpExtCam2Bin(1:3,4),1,size(camPts,2));

            % Get vertex colors
            colorR = color(:,:,1);
            colorG = color(:,:,2);
            colorB = color(:,:,3);
            colorPts = [colorR(validDepth),colorG(validDepth),colorB(validDepth)]';
            allCamColors = [allCamColors,colorPts];
            objSegmPts = [objSegmPts,camPts];
        end
    end
    camPointCloud = pointCloud(objSegmPts','Color',allCamColors');

    toc(timerval)

    % remove points close to Shelf
    fprintf('[Processing] Removing Shelf Points\n');
    [indicesNN,distsNN] = multiQueryKNNSearchImpl(backgroundPointCloud,objSegmPts',1);
    objSegmPts(:,find(sqrt(distsNN) < 0.005)) = [];
    allCamColors(:,find(sqrt(distsNN) < 0.005)) = [];

    objSegmPtsBg = extBin2Bg(1:3,1:3) * objSegmPts + repmat(extBin2Bg(1:3,4) + [0;0;0.01],1,size(objSegmPts,2));
    bgRot = vrrotvec2mat([0 1 0 -atan(0.025/0.20)]);
    objSegmPtsBgRot = bgRot(1:3,1:3) * objSegmPtsBg;
    objSegmPts(:,find(objSegmPtsBg(3,:) < -0.025 | objSegmPtsBgRot(3,:) < 0)) = [];
    allCamColors(:,find(objSegmPtsBg(3,:) < -0.025 | objSegmPtsBgRot(3,:) < 0)) = [];

    % Remove points outside the bin/tote
    ptsOutsideBounds = find((objSegmPts(1,:) < viewBounds(1,1)) | (objSegmPts(1,:) > viewBounds(1,2)) | ...
                            (objSegmPts(2,:) < viewBounds(2,1)) | (objSegmPts(2,:) > viewBounds(2,2)) | ...
                            (objSegmPts(3,:) < viewBounds(3,1)) | (objSegmPts(3,:) > viewBounds(3,2)));
    objSegmPts(:,ptsOutsideBounds) = [];
    allCamColors(:,ptsOutsideBounds) = [];

    [objSegmPts, allCamColors] = denoisePointCloud(objSegmPts, allCamColors);
    
    camPointCloud = pointCloud(objSegmPts','Color',allCamColors');
    camPointCloud = pcdownsample(camPointCloud,'gridAverage',gridStep);
    camPointCloud = pcdenoise(camPointCloud,'NumNeighbors',4);

    %Pose Estimation
    toc(timerval)
    fprintf('[Processing] Performing PCA\n');
    objName = sceneData.objects{obIdx};
    objModel = objModels{find(ismember(objNames,objName))};

    objModelPts = objModel.Location;
    objModelCloud = pointCloud(objModelPts);
    objModelCloud = pcdownsample(objModelCloud,'gridAverage',gridStep);
    objModelPts = objModelCloud.Location';

    % Recompute PCA pose over denoised and downsampled segmented point cloud
    currObjSegmPts = camPointCloud.Location';
    [coeffPCA,scorePCA,latentPCA] = pca(currObjSegmPts');
    if size(latentPCA,1) < 3
      latentPCA = [latentPCA;0];
    end
    coeffPCA = [coeffPCA(:,1),coeffPCA(:,2),cross(coeffPCA(:,1),coeffPCA(:,2))]; % Follow righthand rule
    surfPCAPoseBin = [[coeffPCA median(currObjSegmPts,2)]; 0 0 0 1];

    % Push objects back prior to ICP
    toc(timerval)
    fprintf('[Processing] Performing ICP\n');
    pushBackVal = max([objModel.XLimits(2),objModel.YLimits(2),objModel.ZLimits(2)]);
    surfPCAPoseBin(1:3,4) = surfPCAPoseBin(1:3,4) + pushBackAxis.*pushBackVal;

    tmpObjModelPts = surfPCAPoseBin(1:3,1:3) * objModelPts + repmat(surfPCAPoseBin(1:3,4),1,size(objModelPts,2));
    tmpObjModelCloud = pointCloud(tmpObjModelPts');
    objSegCloud = pointCloud(currObjSegmPts');

    % Perform ICP
    [tform,movingReg,icpRmse] = pcregrigidGPU(objSegCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);

    icpRt1 = inv(tform.T');
    tmpObjModelPts = tmpObjModelCloud.Location';
    tmpObjModelPts = icpRt1(1:3,1:3) * tmpObjModelPts + repmat(icpRt1(1:3,4),1,size(tmpObjModelPts,2));
    tmpObjModelCloud = pointCloud(tmpObjModelPts');
    [tform,movingReg,icpRmse] = pcregrigidGPU(objSegCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio/2,'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
    icpRt2 = inv(tform.T');
    icpRt = icpRt2*icpRt1;
    predObjPoseBin = icpRt * surfPCAPoseBin;
    predObjPoseWorld = sceneData.extBin2World * predObjPoseBin;
    
    % Write Poses to a file
    fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
            objName, ...
            predObjPoseWorld(1,1), predObjPoseWorld(1,2), predObjPoseWorld(1,3), predObjPoseWorld(1,4), ...
            predObjPoseWorld(2,1), predObjPoseWorld(2,2), predObjPoseWorld(2,3), predObjPoseWorld(2,4), ...
            predObjPoseWorld(3,1), predObjPoseWorld(3,2), predObjPoseWorld(3,3), predObjPoseWorld(3,4), ...
            sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
        );
end
fclose(ip);
toc(timerval)
fprintf('[Processing] Calling Physics Engine\n');

t = tcpip('localhost',10000);
fopen(t);
fprintf(t,'HellofromMatlab');
fclose(t);

t2 = tcpip('localhost', 40000, 'NetworkRole', 'server');
fopen(t2);
toc(timerval)
fprintf('[Processing] Sending results\n');
fclose(t2)

[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12] = textread(final_pose, '%s %f %f %f %f %f %f %f %f %f %f %f %f\n');

% Write poses to rosmessage
for obIdx = 1:size(sceneData.objects,2)
    predObjPoseWorld = zeros(4,4);

    predObjPoseWorld(1,1) = val1(obIdx,1);
    predObjPoseWorld(1,2) = val2(obIdx,1);
    predObjPoseWorld(1,3) = val3(obIdx,1);
    predObjPoseWorld(1,4) = val4(obIdx,1);
    predObjPoseWorld(2,1) = val5(obIdx,1);
    predObjPoseWorld(2,2) = val6(obIdx,1);
    predObjPoseWorld(2,3) = val7(obIdx,1);
    predObjPoseWorld(2,4) = val8(obIdx,1);
    predObjPoseWorld(3,1) = val9(obIdx,1);
    predObjPoseWorld(3,2) = val10(obIdx,1);
    predObjPoseWorld(3,3) = val11(obIdx,1);
    predObjPoseWorld(3,4) = val12(obIdx,1);

    try
        poseTrans = rosmessage('geometry_msgs/Point');
    catch
    end

    poseTrans.X = predObjPoseWorld(1,4);
    poseTrans.Y = predObjPoseWorld(2,4);
    poseTrans.Z = predObjPoseWorld(3,4);
    try
        poseRot = rosmessage('geometry_msgs/Quaternion');
    catch
    end

    try
        poseQuat = rotm2quat(predObjPoseWorld(1:3,1:3));
    catch
        poseQuat = rot2quat(predObjPoseWorld(1:3,1:3));
    end

    poseRot.X = poseQuat(2);
    poseRot.Y = poseQuat(3);
    poseRot.Z = poseQuat(4);
    poseRot.W = poseQuat(1);
    try
        poseMsg = rosmessage('geometry_msgs/Pose');
    catch
    end

    poseMsg.Position = poseTrans;
    poseMsg.Orientation = poseRot;

    CurobjectPose = rosmessage('pose_estimation/ObjectPose');
    CurobjectPose.Pose = poseMsg;

    CurobjectPose.Label = char(objName{obIdx,1});

    respMsg.Objects = [respMsg.Objects; CurobjectPose];
end

showdetails(respMsg);
resp = true;
end
