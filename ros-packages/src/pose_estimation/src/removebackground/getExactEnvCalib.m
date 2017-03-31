function [extBin2Bg, backgroundPointCloud] = getExactEnvCalib(sceneData, scenePath)

global emptyShelfModels

% Load scene point cloud
scenePointCloud = getScenePointCloud(sceneData);
pcwrite(scenePointCloud,fullfile(scenePath,'scene'),'PLYFormat','binary');

if strcmp(sceneData.env,'shelf')
	% Load and align empty bin/tote point cloud to observation to get the transform
	binIds = 'ABCDEFGHIJKL';
	backgroundPointCloud = emptyShelfModels{strfind(binIds,sceneData.binId)};
	[tform,backgroundPointCloud] = pcregrigidGPU(backgroundPointCloud,scenePointCloud,'InlierRatio',0.8,'MaxIterations',200,'Tolerance',[0.0001,0.0009],'Verbose',false,'Extrapolate',true);
	extBin2Bg = inv(tform.T');
else
	% For table-top. Parameters need to be adjusted manually
	maxDistance = 0.01;
	referenceVector = [0,0,1];
	maxAngularDistance = 5;
	[model1,inlierIndices,outlierIndices] = pcfitplane(scenePointCloud,maxDistance,referenceVector,maxAngularDistance);
	backgroundPointCloud = select(scenePointCloud,inlierIndices);
	pcwrite(backgroundPointCloud,fullfile(scenePath,'background'),'PLYFormat','binary');
	extBin2Bg = 0;
end

end