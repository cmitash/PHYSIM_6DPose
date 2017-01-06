function objModelPts = getModelPoints(sceneData, objModels, objModel)

% grid size for downsampling point clouds
gridStep = 0.002;

objModelPts = objModel.Location;
objModelCloud = pointCloud(objModelPts);
objModelCloud = pcdownsample(objModelCloud,'gridAverage',gridStep);
objModelPts = objModelCloud.Location';

end