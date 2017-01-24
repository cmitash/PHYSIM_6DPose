function resp = poseServiceSegm(~, reqMsg, respMsg)

timerval = tic;

global objModels
global objNames

frames = [];

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
tmpDataPath = strcat(repo_path,'/tmp');

inPHYSIM = strcat(repo_path,'/tmp/init_pose.txt');
outPHYSIM = strcat(repo_path,'/tmp/final_pose.txt');
allInitPose = strcat(repo_path,'/tmp/allInitPose.txt');

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

% Load scene data
fprintf('\n[Processing] Loading scene RGB-D dataa\n');
sceneData = loadScene(tmpDataPath);
numFrames = length(sceneData.colorFrames);

% Fill holes in depth frames for scene
for frameIdx = 1:length(sceneData.depthFrames)
    sceneData.depthFrames{frameIdx} = fillHoles(sceneData.depthFrames{frameIdx});
    frames = [frames,frameIdx];
end

% Iterative segmentation and pose-estimation
num_iters = 1;

% Call RCNN detector to do 2D object segmentation for each RGB-D frame
active_list = zeros(1,size(sceneData.objects,2));
for obIdx = 1:size(sceneData.objects,2)
    active_list(1,obIdx) = apc_objects_strs(sceneData.objects{1,obIdx});
end
disp(active_list);
[client,reqMsg] = rossvcclient('/update_active_list_and_frame');
[client2,reqMsg2] = rossvcclient('/update_bbox');

frameStr = sprintf('%06d',0);
reqMsg.ActiveList = active_list;
reqMsg.ActiveFrame = frameStr;
call(client,reqMsg);
reqMsg2.Request = 1;
response = call(client2,reqMsg2);

bbox = [response.TlX,response.TlY,response.BrX,response.BrY];

for iter = 1:num_iters
    mkdir(fullfile(scenePath,'bbox_detections'));
    copyfile(fullfile(tmpDataPath,'bbox_detections','*'),fullfile(scenePath,'bbox_detections'));

    allfp = fopen(allInitPose, 'wt');

    % Iterate over each Object in Scene
    for obIdx = 1:size(sceneData.objects,2)
        objName = sceneData.objects{obIdx};
        objModel = objModels{find(ismember(objNames,objName))};
        objModelPts = getModelPoints(sceneData, objModels, objModel);
        currbox = bbox(obIdx,:);

        % get original score
        % camPointCloud = getSegfromMask(sceneData, scenePath, objName, [1,1,640,480]);

        camPointCloud = getSegfromMask(sceneData, scenePath, objName, currbox);
        objSegmPts = camPointCloud.Location;

        fprintf('\n[Processing] Getting Init Pose for %s\n', objName);
        bestpredObjPoseBin = getInitPoseFGR(scenePath, sceneData, objNames, objModels, obIdx, camPointCloud, objModelPts,...
                                         objModel, inPHYSIM, outPHYSIM);
        tmpObjModelPts = bestpredObjPoseBin(1:3,1:3) * objModelPts + repmat(bestpredObjPoseBin(1:3,4),1,size(objModelPts,2));
        tmpObjModelCloud = pointCloud(tmpObjModelPts');
        [ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
        orig_score = size(find(sqrt(dis) < 0.005),2);
        fprintf('[Processing] Init Pose Done, score : %d\n', orig_score);
        
        bestscore = orig_score;
        bestbox = currbox;

        % left +ve
        tmpbox = currbox;
        tmpbox(1,1) = tmpbox(1,1) + 10;
        camPointCloud = getSegfromMask(sceneData, scenePath, objName, tmpbox);
        objSegmPts = camPointCloud.Location;

        fprintf('\n[Processing] Getting Init Pose for %s\n', objName);
        predObjPoseBin = getInitPoseFGR(scenePath, sceneData, objNames, objModels, obIdx, camPointCloud, objModelPts,...
                                         objModel, inPHYSIM, outPHYSIM);
        tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
        tmpObjModelCloud = pointCloud(tmpObjModelPts');
        [ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
        score = size(find(sqrt(dis) < 0.005),2);
        fprintf('[Processing] Init Pose Done, score : %d\n', score);
        if score > bestscore
            bestpredObjPoseBin = predObjPoseBin;
            bestscore = score;
            bestbox = tmpbox;
        end

        % right +ve
        tmpbox = currbox;
        tmpbox(1,3) = tmpbox(1,3) + 10;
        camPointCloud = getSegfromMask(sceneData, scenePath, objName, tmpbox);
        objSegmPts = camPointCloud.Location;

        fprintf('\n[Processing] Getting Init Pose for %s\n', objName);
        predObjPoseBin = getInitPoseFGR(scenePath, sceneData, objNames, objModels, obIdx, camPointCloud, objModelPts,...
                                         objModel, inPHYSIM, outPHYSIM);
        tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
        tmpObjModelCloud = pointCloud(tmpObjModelPts');
        [ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
        score = size(find(sqrt(dis) < 0.005),2);
        fprintf('[Processing] Init Pose Done, score : %d\n', score);
        if score > bestscore
            bestpredObjPoseBin = predObjPoseBin;
            bestscore = score;
            bestbox = tmpbox;
        end

        bestresult = sceneData.colorFrames{1};;
        shapeInserter = vision.ShapeInserter('Shape','Rectangles','BorderColor','Custom',...
        'CustomBorderColor', uint8([255 0 0]));
        rect = int32([bestbox(1,1) bestbox(1,2) bestbox(1,3)-bestbox(1,1) bestbox(1,4)-bestbox(1,2)]);
        bestresult = step(shapeInserter,bestresult,rect);
        imwrite(bestresult, fullfile(scenePath, sprintf('bestbox-%s.png',objName)));

        % Visualize the Output Poses
        predObjPoseWorld = sceneData.extBin2World * predObjPoseBin;
        tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
        tmpObjModelCloud = pointCloud(tmpObjModelPts');
        pclname = sprintf('rcnn-match-%s-%d',objName,iter);
        pclname = fullfile(scenePath, pclname);
        pcwrite(tmpObjModelCloud,pclname,'PLYFormat','binary');

        % Write Poses to a file
        fprintf(allfp, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
                objName, ...
                predObjPoseWorld(1,1), predObjPoseWorld(1,2), predObjPoseWorld(1,3), predObjPoseWorld(1,4), ...
                predObjPoseWorld(2,1), predObjPoseWorld(2,2), predObjPoseWorld(2,3), predObjPoseWorld(2,4), ...
                predObjPoseWorld(3,1), predObjPoseWorld(3,2), predObjPoseWorld(3,3), predObjPoseWorld(3,4), ...
                sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
            );
    end
    fclose(allfp);
end

copyfile(allInitPose,inPHYSIM);
[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12, val13, val14, val15] = textread(inPHYSIM, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n');

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
    predObjPoseWorld(4,4) = 1;

    poseTrans = rosmessage('geometry_msgs/Point');
    poseTrans.X = predObjPoseWorld(1,4);
    poseTrans.Y = predObjPoseWorld(2,4);
    poseTrans.Z = predObjPoseWorld(3,4);
    poseRot = rosmessage('geometry_msgs/Quaternion');
    poseQuat = rotm2quat(predObjPoseWorld(1:3,1:3));
    poseRot.X = poseQuat(2);
    poseRot.Y = poseQuat(3);
    poseRot.Z = poseQuat(4);
    poseRot.W = poseQuat(1);
    poseMsg = rosmessage('geometry_msgs/Pose');

    poseMsg.Position = poseTrans;
    poseMsg.Orientation = poseRot;

    CurobjectPose = rosmessage('pose_estimation/ObjectPose');
    CurobjectPose.Pose = poseMsg;

    CurobjectPose.Label = char(objName{obIdx,1});

    respMsg.Objects = [respMsg.Objects; CurobjectPose];
end

toc(timerval);

resp = true;
showdetails(respMsg);
end
