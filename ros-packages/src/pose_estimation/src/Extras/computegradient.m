function [scores] = computegradient(predObjPoseWorld, extBin2World, objModelPts, scenePath, obIdx)

origpredObjPoseWorld = predObjPoseWorld;
transOffset = 0.01;
rotOffset = 5;

pclname = sprintf('rcnn-clean-%d.ply',obIdx);
pclname = fullfile(scenePath, pclname);
objSegCloud = pcread(pclname);

objSegmPts = objSegCloud.Location;

% Get Current score
predObjPoseBin = inv(extBin2World)*predObjPoseWorld;
tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
orig_score = size(find(sqrt(dis) < 0.005),2);

% gradient along +ve x
predObjPoseWorld = origpredObjPoseWorld;
predObjPoseWorld(1,4) = origpredObjPoseWorld(1,4) + transOffset;
predObjPoseBin = inv(extBin2World)*predObjPoseWorld;
tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
score_px = size(find(sqrt(dis) < 0.005),2);

% gradient along -ve x
predObjPoseWorld = origpredObjPoseWorld;
predObjPoseWorld(1,4) = origpredObjPoseWorld(1,4) - transOffset;
predObjPoseBin = inv(extBin2World)*predObjPoseWorld;
tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
score_nx = size(find(sqrt(dis) < 0.005),2);

% gradient along +ve y
predObjPoseWorld = origpredObjPoseWorld;
predObjPoseWorld(2,4) = origpredObjPoseWorld(2,4) + transOffset;
predObjPoseBin = inv(extBin2World)*predObjPoseWorld;
tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
score_py = size(find(sqrt(dis) < 0.005),2);

% gradient along -ve y
predObjPoseWorld = origpredObjPoseWorld;
predObjPoseWorld(2,4) = origpredObjPoseWorld(2,4) - transOffset;
predObjPoseBin = inv(extBin2World)*predObjPoseWorld;
tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
score_ny = size(find(sqrt(dis) < 0.005),2);

% gradient along +ve z
predObjPoseWorld = origpredObjPoseWorld;
predObjPoseWorld(3,4) = origpredObjPoseWorld(3,4) + transOffset;
predObjPoseBin = inv(extBin2World)*predObjPoseWorld;
tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
score_pz = size(find(sqrt(dis) < 0.005),2);

% gradient along -ve z
predObjPoseWorld = origpredObjPoseWorld;
predObjPoseWorld(3,4) = origpredObjPoseWorld(3,4) - transOffset;
predObjPoseBin = inv(extBin2World)*predObjPoseWorld;
tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
score_nz = size(find(sqrt(dis) < 0.005),2);

rotm = origpredObjPoseWorld(1:3,1:3);
origeulZYX = rotm2eul(rotm);
eul = origeulZYX;

% gradient along +ve r
predObjPoseWorld = origpredObjPoseWorld;
eul = origeulZYX;
eul(1,1) = origeulZYX(1,1) + rotOffset;
predObjPoseWorld(1:3,1:3) = eul2rotm(eul);
predObjPoseBin = inv(extBin2World)*predObjPoseWorld;
tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
tmpObjModelCloud = pointCloud(tmpObjModelPts');
[ind,dis] = multiQueryKNNSearchImpl(tmpObjModelCloud,objSegmPts,1);
score_pr = size(find(sqrt(dis) < 0.005),2);

% gradient along -ve r


% gradient along +ve p
% gradient along -ve p
% gradient along +ve ya
% gradient along -ve ya

fprintf('scores are  curr : %d, px : %d, nx : %d, py : %d, ny : %d, pz : %d, nz : %d\n',...
					orig_score, score_px, score_nx, score_py, score_ny, score_pz, score_nz);
scores = 1;
end