function [camPointCloud] = getSegfromMask(sceneData, scenePath, objName, bbox)

% grid size for downsampling point clouds
gridStep = 0.002;

allCamColors = [];
objSegmPts = [];

tmpObjMask = zeros(480,640);
tmpObjMask(bbox(1,2):bbox(1,4),bbox(1,1):bbox(1,3)) = 1;
tmpDepth = sceneData.depthFrames{1};
color = sceneData.colorFrames{1};
tmpExtCam2World = sceneData.extCam2World{1};
tmpExtCam2Bin = sceneData.extWorld2Bin * tmpExtCam2World;

% Apply segmentation mask to depth image and project to camera space
tmpDepth = tmpDepth.*double(tmpObjMask);
[pixX,pixY] = meshgrid(1:640,1:480);
camX = (pixX-sceneData.colorK(1,3)).*tmpDepth/sceneData.colorK(1,1);
camY = (pixY-sceneData.colorK(2,3)).*tmpDepth/sceneData.colorK(2,2);
camZ = tmpDepth;
validDepth = find((camZ > 0.1) & (camZ < 1));
camPts = [camX(validDepth),camY(validDepth),camZ(validDepth)]';
camPts = tmpExtCam2Bin(1:3,1:3) * camPts + repmat(tmpExtCam2Bin(1:3,4),1,size(camPts,2));

% Get vertex colors
colorR = color(:,:,1);
colorG = color(:,:,2);
colorB = color(:,:,3);
colorPts = [colorR(validDepth),colorG(validDepth),colorB(validDepth)]';
allCamColors = [allCamColors,colorPts];
objSegmPts = [objSegmPts,camPts];
objSegmPts = single(objSegmPts);

camPointCloud = pointCloud(objSegmPts');
camPointCloud = pcdownsample(camPointCloud,'gridAverage',gridStep);
camPointCloud = pcdenoise(camPointCloud,'NumNeighbors',4);
pclname = sprintf('rcnn-clean-%s',objName);
pclname = fullfile(scenePath, pclname);
pcwrite(camPointCloud,pclname,'PLYFormat','ascii');

end
