function bestpredObjPoseBin = getInitPosePCA(scenePath, sceneData, objNames, objModels, obIdx, camPointCloud, objModelPts, objModel, inPHYSIM, outPHYSIM)

icpWorstRejRatio = 0.9;

currObjSegmPts = camPointCloud.Location';
objName = sceneData.objects{obIdx};

[coeffPCA,scorePCA,latentPCA] = pca(currObjSegmPts');

% Pose - 1
pushBackAxis = [1; 0; -1];
pushBackVal = max([objModel.XLimits(2),objModel.YLimits(2),objModel.ZLimits(2)]);

coeffPCA = [coeffPCA(:,1),coeffPCA(:,2),cross(coeffPCA(:,1),coeffPCA(:,2))];
surfPCAPoseBin = [[coeffPCA median(currObjSegmPts,2)]; 0 0 0 1];

surfPCAPoseBin(1:3,4) = surfPCAPoseBin(1:3,4) + pushBackAxis.*pushBackVal;
tmpObjModelPts = surfPCAPoseBin(1:3,1:3) * objModelPts + repmat(surfPCAPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
currObjPointCloud = pointCloud(currObjSegmPts');

[tform,movingReg,icpRmse] = pcregrigidGPU(currObjPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,...
                            'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt1 = inv(tform.T');
tmpObjModelPts = tmpObjModelCloud.Location';
tmpObjModelPts = icpRt1(1:3,1:3) * tmpObjModelPts + repmat(icpRt1(1:3,4),1,size(tmpObjModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[tform,movingReg,icpRmse] = pcregrigidGPU(currObjPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio/2,'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt2 = inv(tform.T');
icpRt = icpRt2*icpRt1;
bestpredObjPoseBin = icpRt * surfPCAPoseBin;

end