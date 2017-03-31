function [objSegmPts, allCamColors] = removeEnvPoints(sceneData, backgroundPointCloud, objSegmPts, allCamColors, extBin2Bg, performKNN)

global binBounds;
global tableBounds;

if strcmp(sceneData.env,'shelf')
	if performKNN == 1
		% remove points close to Shelf
		[indicesNN,distsNN] = multiQueryKNNSearchImpl(backgroundPointCloud,objSegmPts',1);
		objSegmPts(:,find(sqrt(distsNN) < 0.005)) = [];
		allCamColors(:,find(sqrt(distsNN) < 0.005)) = [];

		objSegmPtsBg = extBin2Bg(1:3,1:3) * objSegmPts + repmat(extBin2Bg(1:3,4) + [0;0;0.01],1,size(objSegmPts,2));
		bgRot = vrrotvec2mat([0 1 0 -atan(0.025/0.20)]);
		objSegmPtsBgRot = bgRot(1:3,1:3) * objSegmPtsBg;
		objSegmPts(:,find(objSegmPtsBg(3,:) < -0.025 | objSegmPtsBgRot(3,:) < 0)) = [];
		allCamColors(:,find(objSegmPtsBg(3,:) < -0.025 | objSegmPtsBgRot(3,:) < 0)) = [];
	end

	% Remove points outside the bin/tote
	ptsOutsideBounds = find((objSegmPts(1,:) < binBounds(1,1)) | (objSegmPts(1,:) > binBounds(1,2)) | ...
	                        (objSegmPts(2,:) < binBounds(2,1)) | (objSegmPts(2,:) > binBounds(2,2)) | ...
	                        (objSegmPts(3,:) < binBounds(3,1)) | (objSegmPts(3,:) > binBounds(3,2)));
	objSegmPts(:,ptsOutsideBounds) = [];
	allCamColors(:,ptsOutsideBounds) = [];
else
	if performKNN == 1
	 	% remove points close to Shelf
	 	[indicesNN,distsNN] = multiQueryKNNSearchImpl(backgroundPointCloud,objSegmPts',1);
	 	objSegmPts(:,find(sqrt(distsNN) < 0.008)) = [];
	 	allCamColors(:,find(sqrt(distsNN) < 0.008)) = [];
 	end

	% Remove points outside the TABLE
	ptsOutsideBounds = find(objSegmPts(3,:) < tableBounds);
	objSegmPts(:,ptsOutsideBounds) = [];
	allCamColors(:,ptsOutsideBounds) = [];
end