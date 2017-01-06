clc;

% Store results for pose estimation
rcnn_pose = {};
numpose = 1;

% data = {'0002','0003','0004','0007','0008',...
%         '0009','0013','0014','0015','0020',...
%         '0021','0040','0041','0043','0044',...
%         '0045','0047','0049','0050','0051',...
%         '0054','0055','0059','0060','0061',...
%         '0062','0063','0064','0067','0069',...
%         '0070','0072','0073','0076','0077',...
%         '0078','0079','0080','0081','0082'};
data = {'0002','0003','0004','0007','0008'};

% data = {'0000','0002','0003','0006','0007',...
%         '0009','0011','0012','0017',...
%         '0019','0021','0022','0024','0028',...
%         '0029','0030','0032','0034','0035',...
%         '0037','0042','0043','0044','0045',...
%         '0046','0047','0049','0051','0053',...
%         '0054','0055','0056','0057','0060',...
%         '0061','0064','0065','0067','0068',...
%         '0071','0075','0076','0077','0078',...
%         '0080','0081','0090','0091','0092'};

for scenenum=1:length(data)
    currentScene = strcat('warehouse/practice/shelf/scene-',data{1,scenenum});
    currentCalibration = 'warehouse/calibration';

    % currentScene = strcat('office/test/shelf/scene-',data{1,scenenum});
    % currentCalibration = 'office/calibration';
    
    scenePath = fullfile('/home/pracsys/github/apc-vision-toolbox/data/benchmark',currentScene); % Directory holding the RGB-D data of the sample scene
    calibPath = fullfile('/home/pracsys/github/apc-vision-toolbox/data/benchmark',currentCalibration); % Directory holding camera pose calibration data for the sample scene

    [client,reqMsg] = rossvcclient('/pose_estimation');

    fprintf('calling pose estimation for scene %d \n', scenenum);
    reqMsg.SceneFiles = scenePath;
    reqMsg.CalibrationFiles = calibPath;
    response = call(client,reqMsg);
    
    for objects=1:size(response.Objects,1)
        quat = [response.Objects(objects,1).Pose.Orientation.W,...
                response.Objects(objects,1).Pose.Orientation.X,...
                response.Objects(objects,1).Pose.Orientation.Y,...
                response.Objects(objects,1).Pose.Orientation.Z];
        predObjPoseWorld = zeros(4,4);
        predObjPoseWorld(1:3,1:3) = quat2rot(quat);
        predObjPoseWorld(1,4) = response.Objects(objects,1).Pose.Position.X;
        predObjPoseWorld(2,4) = response.Objects(objects,1).Pose.Position.Y;
        predObjPoseWorld(3,4) = response.Objects(objects,1).Pose.Position.Z;

        poseStruct = struct('sceneName',currentScene,'objectName',response.Objects(objects,1).Label,'objectPose',predObjPoseWorld);
        rcnn_pose{numpose} = poseStruct;
        numpose = numpose + 1;
    end
    rcnnpath = '/home/pracsys/github/apc-vision-toolbox/data/benchmark/rcnn-poses.mat';
    save(rcnnpath, 'rcnn_pose');
end
rcnnpath = '/home/pracsys/github/apc-vision-toolbox/data/benchmark/rcnn-poses.mat';
save(rcnnpath, 'rcnn_pose');
