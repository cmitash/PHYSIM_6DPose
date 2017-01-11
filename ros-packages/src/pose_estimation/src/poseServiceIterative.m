function resp = poseServiceIterative(~, reqMsg, respMsg)

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

% Calibrate scene
% sceneData = loadCalib(calibPath,sceneData);

% Fill holes in depth frames for scene
for frameIdx = 1:length(sceneData.depthFrames)
    sceneData.depthFrames{frameIdx} = fillHoles(sceneData.depthFrames{frameIdx});
    frames = [frames,frameIdx];
end

% Call Segmentaion module
getRCNNSegmentation(sceneData, scenePath, tmpDataPath, apc_objects_strs, frames, numFrames);
% getFCNSegmentation(sceneData, scenePath, tmpDataPath, apc_objects_strs, frames, numFrames);
% getGTBBoxSegmentation(sceneData, scenePath, tmpDataPath, apc_objects_strs, frames, numFrames, objNames);

% Get Initial Pairwise registrarion
allfp = fopen(allInitPose, 'wt');
% Iterate over each Object in Scene
for obIdx = 1:size(sceneData.objects,2)
    objName = sceneData.objects{obIdx};

    % Read object segmented cloud, model data        
    pclname = sprintf('rcnn-clean-%s.ply',objName);
    pclname = fullfile(scenePath, pclname);
    objSegCloud = pcread(pclname);

    objModel = objModels{find(ismember(objNames,objName))};
    objModelPts = getModelPoints(sceneData, objModels, objModel);

    % Get Initialization Pose
    fprintf('\n[Processing] Getting Init Pose for %s\n', objName);
    % bestpredObjPoseBin = getInitPoseSuper4PCS(scenePath, sceneData, objNames, objModels, obIdx, objSegCloud, objModelPts,...
    %                                  objModel, inPHYSIM, outPHYSIM);
    bestpredObjPoseBin = getInitPosePCA(scenePath, sceneData, objNames, objModels, obIdx, objSegCloud, objModelPts,...
                                     objModel, inPHYSIM, outPHYSIM);
    fprintf('[Processing] Init Pose Done\n');
    
    % Visualize the Output Poses
    predObjPoseWorld = sceneData.extBin2World * bestpredObjPoseBin;
    tmpObjModelPts = bestpredObjPoseBin(1:3,1:3) * objModelPts + repmat(bestpredObjPoseBin(1:3,4),1,size(objModelPts,2));
    tmpObjModelCloud = pointCloud(tmpObjModelPts');
    pclname = sprintf('rcnn-match-%s',objName);
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

copyfile(allInitPose,inPHYSIM);
% runPhyTrimICP(inPHYSIM, outPHYSIM, objNames, objModels, sceneData, scenePath);

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
