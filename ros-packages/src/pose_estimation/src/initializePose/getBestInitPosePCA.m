function bestpredObjPoseBin = getBestInitPosePCA(scenePath, sceneData, objNames, objModels, obIdx, currObjSegmPts, objModelPts, objModel, inPHYSIM, outPHYSIM)

icpWorstRejRatio = 0.9;

fprintf('[Processing] Performing PCA\n');
objName = sceneData.objects{obIdx};

[coeffPCA,scorePCA,latentPCA] = pca(currObjSegmPts');
bestscore = 0;

% Pose - 1
Rot = [coeffPCA(:,1),coeffPCA(:,2),cross(coeffPCA(:,1),coeffPCA(:,2))];
surfPCAPoseBin = [[Rot median(currObjSegmPts,2)]; 0 0 0 1];
tmpObjModelPts = surfPCAPoseBin(1:3,1:3) * objModelPts + repmat(surfPCAPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

pclname = sprintf('rcnn-pca-a-%d',obIdx);
pclname = fullfile(scenePath, pclname);
pcwrite(tmpObjModelCloud,pclname,'PLYFormat','binary');

[tform,movingReg,icpRmse] = pcregrigidGPU(camPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,...
                            'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt = inv(tform.T');
predObjPoseBin = icpRt * surfPCAPoseBin;

% PhyTrimICP
ip = fopen(inPHYSIM,'wt');

predObjPoseWorld = sceneData.extBin2World * predObjPoseBin;
fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
        objName, ...
        predObjPoseWorld(1,1), predObjPoseWorld(1,2), predObjPoseWorld(1,3), predObjPoseWorld(1,4), ...
        predObjPoseWorld(2,1), predObjPoseWorld(2,2), predObjPoseWorld(2,3), predObjPoseWorld(2,4), ...
        predObjPoseWorld(3,1), predObjPoseWorld(3,2), predObjPoseWorld(3,3), predObjPoseWorld(3,4), ...
        sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
    );
runPhyTrimICP(inPHYSIM, outPHYSIM, objNames, objModels, sceneData, scenePath);
[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12] = textread(outPHYSIM, '%s %f %f %f %f %f %f %f %f %f %f %f %f\n');
predObjPoseWorld = zeros(4,4);
predObjPoseWorld(1,1) = val1(1,1);
predObjPoseWorld(1,2) = val2(1,1);
predObjPoseWorld(1,3) = val3(1,1);
predObjPoseWorld(1,4) = val4(1,1);
predObjPoseWorld(2,1) = val5(1,1);
predObjPoseWorld(2,2) = val6(1,1);
predObjPoseWorld(2,3) = val7(1,1);
predObjPoseWorld(2,4) = val8(1,1);
predObjPoseWorld(3,1) = val9(1,1);
predObjPoseWorld(3,2) = val10(1,1);
predObjPoseWorld(3,3) = val11(1,1);
predObjPoseWorld(3,4) = val12(1,1);
predObjPoseWorld(4,4) = 1;
predObjPoseBin = inv(sceneData.extBin2World)*predObjPoseWorld;
fclose(ip);

tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

[~,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,currObjSegmPts',1);
score1 = size(find(sqrt(dis) < 0.005),2);
[~,dis] = multiQueryKNNSearchImpl(camPointCloud,tmpObjModelPts',1);
score2 = size(find(sqrt(dis) < 0.005),2);
score = score1 + score2;
fprintf('score A : %d\n', score);
if score > bestscore
    bestpredObjPoseBin = predObjPoseBin;
    bestscore = score;
end

% Pose - 2
Rot = [cross(coeffPCA(:,1),coeffPCA(:,2)),coeffPCA(:,1),coeffPCA(:,2)];
surfPCAPoseBin = [[Rot median(currObjSegmPts,2)]; 0 0 0 1];
tmpObjModelPts = surfPCAPoseBin(1:3,1:3) * objModelPts + repmat(surfPCAPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

pclname = sprintf('rcnn-pca-b-%d',obIdx);
pclname = fullfile(scenePath, pclname);
pcwrite(tmpObjModelCloud,pclname,'PLYFormat','binary');

[tform,movingReg,icpRmse] = pcregrigidGPU(camPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,...
                            'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt = inv(tform.T');
predObjPoseBin = icpRt * surfPCAPoseBin;

% PhyTrimICP
ip = fopen(inPHYSIM,'wt');
objName = sceneData.objects{obIdx};
predObjPoseWorld = sceneData.extBin2World * predObjPoseBin;
fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
        objName, ...
        predObjPoseWorld(1,1), predObjPoseWorld(1,2), predObjPoseWorld(1,3), predObjPoseWorld(1,4), ...
        predObjPoseWorld(2,1), predObjPoseWorld(2,2), predObjPoseWorld(2,3), predObjPoseWorld(2,4), ...
        predObjPoseWorld(3,1), predObjPoseWorld(3,2), predObjPoseWorld(3,3), predObjPoseWorld(3,4), ...
        sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
    );
runPhyTrimICP(inPHYSIM, outPHYSIM, objNames, objModels, sceneData, scenePath);
[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12] = textread(outPHYSIM, '%s %f %f %f %f %f %f %f %f %f %f %f %f\n');
predObjPoseWorld = zeros(4,4);
predObjPoseWorld(1,1) = val1(1,1);
predObjPoseWorld(1,2) = val2(1,1);
predObjPoseWorld(1,3) = val3(1,1);
predObjPoseWorld(1,4) = val4(1,1);
predObjPoseWorld(2,1) = val5(1,1);
predObjPoseWorld(2,2) = val6(1,1);
predObjPoseWorld(2,3) = val7(1,1);
predObjPoseWorld(2,4) = val8(1,1);
predObjPoseWorld(3,1) = val9(1,1);
predObjPoseWorld(3,2) = val10(1,1);
predObjPoseWorld(3,3) = val11(1,1);
predObjPoseWorld(3,4) = val12(1,1);
predObjPoseWorld(4,4) = 1;
predObjPoseBin = inv(sceneData.extBin2World)*predObjPoseWorld;
fclose(ip);

tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

[~,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,currObjSegmPts',1);
score1 = size(find(sqrt(dis) < 0.005),2);
[~,dis] = multiQueryKNNSearchImpl(camPointCloud,tmpObjModelPts',1);
score2 = size(find(sqrt(dis) < 0.005),2);
score = score1 + score2;
fprintf('score B : %d\n', score);

if score > bestscore
    bestpredObjPoseBin = predObjPoseBin;
    bestscore = score;
end

% Pose - 3
Rot = [coeffPCA(:,1),cross(coeffPCA(:,2),coeffPCA(:,1)),coeffPCA(:,2)];
surfPCAPoseBin = [[Rot median(currObjSegmPts,2)]; 0 0 0 1];
tmpObjModelPts = surfPCAPoseBin(1:3,1:3) * objModelPts + repmat(surfPCAPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

pclname = sprintf('rcnn-pca-c-%d',obIdx);
pclname = fullfile(scenePath, pclname);
pcwrite(tmpObjModelCloud,pclname,'PLYFormat','binary');

[tform,movingReg,icpRmse] = pcregrigidGPU(camPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,...
                            'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt = inv(tform.T');
predObjPoseBin = icpRt * surfPCAPoseBin;

% PhyTrimICP
ip = fopen(inPHYSIM,'wt');
objName = sceneData.objects{obIdx};
predObjPoseWorld = sceneData.extBin2World * predObjPoseBin;
fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
        objName, ...
        predObjPoseWorld(1,1), predObjPoseWorld(1,2), predObjPoseWorld(1,3), predObjPoseWorld(1,4), ...
        predObjPoseWorld(2,1), predObjPoseWorld(2,2), predObjPoseWorld(2,3), predObjPoseWorld(2,4), ...
        predObjPoseWorld(3,1), predObjPoseWorld(3,2), predObjPoseWorld(3,3), predObjPoseWorld(3,4), ...
        sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
    );
runPhyTrimICP(inPHYSIM, outPHYSIM, objNames, objModels, sceneData, scenePath);
[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12] = textread(outPHYSIM, '%s %f %f %f %f %f %f %f %f %f %f %f %f\n');
predObjPoseWorld = zeros(4,4);
predObjPoseWorld(1,1) = val1(1,1);
predObjPoseWorld(1,2) = val2(1,1);
predObjPoseWorld(1,3) = val3(1,1);
predObjPoseWorld(1,4) = val4(1,1);
predObjPoseWorld(2,1) = val5(1,1);
predObjPoseWorld(2,2) = val6(1,1);
predObjPoseWorld(2,3) = val7(1,1);
predObjPoseWorld(2,4) = val8(1,1);
predObjPoseWorld(3,1) = val9(1,1);
predObjPoseWorld(3,2) = val10(1,1);
predObjPoseWorld(3,3) = val11(1,1);
predObjPoseWorld(3,4) = val12(1,1);
predObjPoseWorld(4,4) = 1;
predObjPoseBin = inv(sceneData.extBin2World)*predObjPoseWorld;
fclose(ip);

tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

[~,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,currObjSegmPts',1);
score1 = size(find(sqrt(dis) < 0.005),2);
[~,dis] = multiQueryKNNSearchImpl(camPointCloud,tmpObjModelPts',1);
score2 = size(find(sqrt(dis) < 0.005),2);
score = score1 + score2;
fprintf('score C : %d\n', score);

if score > bestscore
    bestpredObjPoseBin = predObjPoseBin;
    bestscore = score;
end

% Using PushBack
pushBackAxis = [1; 0; 0];
pushBackVal = max([objModel.XLimits(2),objModel.YLimits(2),objModel.ZLimits(2)]);
% Pose - 4
Rot = [coeffPCA(:,1),coeffPCA(:,2),cross(coeffPCA(:,1),coeffPCA(:,2))];
surfPCAPoseBin = [[Rot median(currObjSegmPts,2)]; 0 0 0 1];
surfPCAPoseBin(1:3,4) = surfPCAPoseBin(1:3,4) + pushBackAxis.*pushBackVal;
tmpObjModelPts = surfPCAPoseBin(1:3,1:3) * objModelPts + repmat(surfPCAPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

pclname = sprintf('rcnn-pca-d-%d',obIdx);
pclname = fullfile(scenePath, pclname);
pcwrite(tmpObjModelCloud,pclname,'PLYFormat','binary');

[tform,movingReg,icpRmse] = pcregrigidGPU(camPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,...
                            'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt = inv(tform.T');
predObjPoseBin = icpRt * surfPCAPoseBin;

% PhyTrimICP
ip = fopen(inPHYSIM,'wt');
objName = sceneData.objects{obIdx};
predObjPoseWorld = sceneData.extBin2World * predObjPoseBin;
fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
        objName, ...
        predObjPoseWorld(1,1), predObjPoseWorld(1,2), predObjPoseWorld(1,3), predObjPoseWorld(1,4), ...
        predObjPoseWorld(2,1), predObjPoseWorld(2,2), predObjPoseWorld(2,3), predObjPoseWorld(2,4), ...
        predObjPoseWorld(3,1), predObjPoseWorld(3,2), predObjPoseWorld(3,3), predObjPoseWorld(3,4), ...
        sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
    );
runPhyTrimICP(inPHYSIM, outPHYSIM, objNames, objModels, sceneData, scenePath);
[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12] = textread(outPHYSIM, '%s %f %f %f %f %f %f %f %f %f %f %f %f\n');
predObjPoseWorld = zeros(4,4);
predObjPoseWorld(1,1) = val1(1,1);
predObjPoseWorld(1,2) = val2(1,1);
predObjPoseWorld(1,3) = val3(1,1);
predObjPoseWorld(1,4) = val4(1,1);
predObjPoseWorld(2,1) = val5(1,1);
predObjPoseWorld(2,2) = val6(1,1);
predObjPoseWorld(2,3) = val7(1,1);
predObjPoseWorld(2,4) = val8(1,1);
predObjPoseWorld(3,1) = val9(1,1);
predObjPoseWorld(3,2) = val10(1,1);
predObjPoseWorld(3,3) = val11(1,1);
predObjPoseWorld(3,4) = val12(1,1);
predObjPoseWorld(4,4) = 1;
predObjPoseBin = inv(sceneData.extBin2World)*predObjPoseWorld;
fclose(ip);

tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

[~,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,currObjSegmPts',1);
score1 = size(find(sqrt(dis) < 0.005),2);
[~,dis] = multiQueryKNNSearchImpl(camPointCloud,tmpObjModelPts',1);
score2 = size(find(sqrt(dis) < 0.005),2);
score = score1 + score2;
fprintf('score D : %d\n', score);

if score > bestscore
    bestpredObjPoseBin = predObjPoseBin;
    bestscore = score;
end

% Pose - 5
Rot = [cross(coeffPCA(:,1),coeffPCA(:,2)),coeffPCA(:,1),coeffPCA(:,2)];
surfPCAPoseBin = [[Rot median(currObjSegmPts,2)]; 0 0 0 1];
surfPCAPoseBin(1:3,4) = surfPCAPoseBin(1:3,4) + pushBackAxis.*pushBackVal;
tmpObjModelPts = surfPCAPoseBin(1:3,1:3) * objModelPts + repmat(surfPCAPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

pclname = sprintf('rcnn-pca-e-%d',obIdx);
pclname = fullfile(scenePath, pclname);
pcwrite(tmpObjModelCloud,pclname,'PLYFormat','binary');

[tform,movingReg,icpRmse] = pcregrigidGPU(camPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,...
                            'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt = inv(tform.T');
predObjPoseBin = icpRt * surfPCAPoseBin;

% PhyTrimICP
ip = fopen(inPHYSIM,'wt');
objName = sceneData.objects{obIdx};
predObjPoseWorld = sceneData.extBin2World * predObjPoseBin;
fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
        objName, ...
        predObjPoseWorld(1,1), predObjPoseWorld(1,2), predObjPoseWorld(1,3), predObjPoseWorld(1,4), ...
        predObjPoseWorld(2,1), predObjPoseWorld(2,2), predObjPoseWorld(2,3), predObjPoseWorld(2,4), ...
        predObjPoseWorld(3,1), predObjPoseWorld(3,2), predObjPoseWorld(3,3), predObjPoseWorld(3,4), ...
        sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
    );
runPhyTrimICP(inPHYSIM, outPHYSIM, objNames, objModels, sceneData, scenePath);
[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12] = textread(outPHYSIM, '%s %f %f %f %f %f %f %f %f %f %f %f %f\n');
predObjPoseWorld = zeros(4,4);
predObjPoseWorld(1,1) = val1(1,1);
predObjPoseWorld(1,2) = val2(1,1);
predObjPoseWorld(1,3) = val3(1,1);
predObjPoseWorld(1,4) = val4(1,1);
predObjPoseWorld(2,1) = val5(1,1);
predObjPoseWorld(2,2) = val6(1,1);
predObjPoseWorld(2,3) = val7(1,1);
predObjPoseWorld(2,4) = val8(1,1);
predObjPoseWorld(3,1) = val9(1,1);
predObjPoseWorld(3,2) = val10(1,1);
predObjPoseWorld(3,3) = val11(1,1);
predObjPoseWorld(3,4) = val12(1,1);
predObjPoseWorld(4,4) = 1;
predObjPoseBin = inv(sceneData.extBin2World)*predObjPoseWorld;
fclose(ip);

tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

[~,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,currObjSegmPts',1);
score1 = size(find(sqrt(dis) < 0.005),2);
[~,dis] = multiQueryKNNSearchImpl(camPointCloud,tmpObjModelPts',1);
score2 = size(find(sqrt(dis) < 0.005),2);
score = score1 + score2;
fprintf('score E : %d\n', score);

if score > bestscore
    bestpredObjPoseBin = predObjPoseBin;
    bestscore = score;
end

% Pose - 6
Rot = [coeffPCA(:,1),cross(coeffPCA(:,2),coeffPCA(:,1)),coeffPCA(:,2)];
surfPCAPoseBin = [[Rot median(currObjSegmPts,2)]; 0 0 0 1];
surfPCAPoseBin(1:3,4) = surfPCAPoseBin(1:3,4) + pushBackAxis.*pushBackVal;
tmpObjModelPts = surfPCAPoseBin(1:3,1:3) * objModelPts + repmat(surfPCAPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

pclname = sprintf('rcnn-pca-f-%d',obIdx);
pclname = fullfile(scenePath, pclname);
pcwrite(tmpObjModelCloud,pclname,'PLYFormat','binary');

[tform,movingReg,icpRmse] = pcregrigidGPU(camPointCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio,...
                            'MaxIterations',200,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
icpRt = inv(tform.T');
predObjPoseBin = icpRt * surfPCAPoseBin;

% PhyTrimICP
ip = fopen(inPHYSIM,'wt');
objName = sceneData.objects{obIdx};
predObjPoseWorld = sceneData.extBin2World * predObjPoseBin;
fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
        objName, ...
        predObjPoseWorld(1,1), predObjPoseWorld(1,2), predObjPoseWorld(1,3), predObjPoseWorld(1,4), ...
        predObjPoseWorld(2,1), predObjPoseWorld(2,2), predObjPoseWorld(2,3), predObjPoseWorld(2,4), ...
        predObjPoseWorld(3,1), predObjPoseWorld(3,2), predObjPoseWorld(3,3), predObjPoseWorld(3,4), ...
        sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
    );
runPhyTrimICP(inPHYSIM, outPHYSIM, objNames, objModels, sceneData, scenePath);
[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12] = textread(outPHYSIM, '%s %f %f %f %f %f %f %f %f %f %f %f %f\n');
predObjPoseWorld = zeros(4,4);
predObjPoseWorld(1,1) = val1(1,1);
predObjPoseWorld(1,2) = val2(1,1);
predObjPoseWorld(1,3) = val3(1,1);
predObjPoseWorld(1,4) = val4(1,1);
predObjPoseWorld(2,1) = val5(1,1);
predObjPoseWorld(2,2) = val6(1,1);
predObjPoseWorld(2,3) = val7(1,1);
predObjPoseWorld(2,4) = val8(1,1);
predObjPoseWorld(3,1) = val9(1,1);
predObjPoseWorld(3,2) = val10(1,1);
predObjPoseWorld(3,3) = val11(1,1);
predObjPoseWorld(3,4) = val12(1,1);
predObjPoseWorld(4,4) = 1;
predObjPoseBin = inv(sceneData.extBin2World)*predObjPoseWorld;
fclose(ip);

tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');

[~,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,currObjSegmPts',1);
score1 = size(find(sqrt(dis) < 0.005),2);
[~,dis] = multiQueryKNNSearchImpl(camPointCloud,tmpObjModelPts',1);
score2 = size(find(sqrt(dis) < 0.005),2);
score = score1 + score2;
fprintf('score F : %d\n', score);

if score > bestscore
    bestpredObjPoseBin = predObjPoseBin;
    bestscore = score;
end

end