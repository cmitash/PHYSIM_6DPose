function bestpredObjPoseBin = getInitPoseFGR(scenePath, sceneData, objNames, objModels, obIdx, camPointCloud, objModelPts, objModel, inPHYSIM, outPHYSIM)

icpWorstRejRatio = 0.9;
repo_path = getenv('PHYSIM_6DPose_PATH');

pathFGR = fullfile(repo_path, 'ros-packages/src/FastGlobalRegistration/build/FastGlobalRegistration/FastGlobalRegistration');
pathExtractFeature = fullfile(repo_path, 'ros-packages/src/FastGlobalRegistration/ExtractFPFHFeatures/build/ExtractFPFH');
outputpath  = fullfile(repo_path, 'ros-packages/src/FastGlobalRegistration/output.txt');

objName = sceneData.objects{obIdx};
pclname = sprintf('rcnn-clean-%s',objName);
pclname = fullfile(scenePath, pclname);

modelpath = fullfile(repo_path, sprintf('ros-packages/src/FastGlobalRegistration/objmodels/princeton_models/%s.bin',objName));
cmd_extract = [pathExtractFeature ' ' pclname];
cmd_pose = [pathFGR ' ' pclname '.bin ' modelpath ' ' outputpath];

% Save library paths
MatlabPath = getenv('LD_LIBRARY_PATH');
% Make Matlab use system libraries
setenv('LD_LIBRARY_PATH',getenv('PATH'));
status1 = system(cmd_extract);
status2 = system(cmd_pose);
% Reassign old library paths
setenv('LD_LIBRARY_PATH',MatlabPath);

[val1, val2, val3, val4] = textread(outputpath, '%f %f %f %f\n');
predObjPoseBin = [val1,val2,val3,val4]

tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
currObjSegmPts = camPointCloud.Location';
currObjPointCloud = pointCloud(currObjSegmPts');

[tform,~,~] = pcregrigidGPU(currObjPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,...
                            'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt1 = inv(tform.T');
tmpObjModelPts = tmpObjModelCloud.Location';
tmpObjModelPts = icpRt1(1:3,1:3) * tmpObjModelPts + repmat(icpRt1(1:3,4),1,size(tmpObjModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[tform,~,~] = pcregrigidGPU(currObjPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio/2,'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt2 = inv(tform.T');
icpRt = icpRt2*icpRt1;
bestpredObjPoseBin = icpRt * predObjPoseBin;
fprintf('done with ICP');
end