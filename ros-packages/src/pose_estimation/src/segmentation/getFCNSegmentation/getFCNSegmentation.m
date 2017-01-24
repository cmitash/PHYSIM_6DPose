function getFCNSegmentation(sceneData, scenePath, tmpDataPath, apc_objects_strs, frames, numFrames)

% if you want to use background calibration (default = false)
useBgCalib = 1;

% grid size for downsampling point clouds
gridStep = 0.002;

% Call FCN detector to do 2D object segmentation for each RGB-D frame
fprintf('    [Segmentation] Frame ');
binIds = 'ABCDEFGHIJKL';
binNum = strfind(binIds,sceneData.binId)-1;
[client3,reqMsg3] = rossvcclient('/marvin_convnet');
for frameIdx = 0:(numFrames-1)
    fprintf('%d ',frameIdx);
    reqMsg3.BinId = binNum;
    reqMsg3.ObjectNames = sceneData.objects;
    reqMsg3.FrameId = frameIdx;
    response = call(client3,reqMsg3);
end
fprintf('\n');

mkdir(fullfile(scenePath,'masks'));
copyfile(fullfile(tmpDataPath,'masks','*'),fullfile(scenePath,'masks'));

% Calibrate the table/shelf
backgroundPointCloud = 0;
extBin2Bg = 0;
if useBgCalib == 1
    [extBin2Bg, backgroundPointCloud] = getExactEnvCalib(sceneData, scenePath);
end

for obIdx = 1:size(sceneData.objects,2)
    % Parse segmentation masks and save confidence threshold used
    [objMasks,segmThresh,segmConfMaps] = getObjectMasks(tmpDataPath,sceneData.objects{1,obIdx},frames);
    dlmwrite(fullfile(scenePath,'masks',sprintf('%s.thresh.txt',sceneData.objects{1,obIdx})),segmThresh);
    
    % Create segmented point cloud of object
    [objSegmPts,objSegmConf,allCamColors] = getSegmentedPointCloud(sceneData,frames,objMasks,segmConfMaps);
    camPointCloud = pointCloud(objSegmPts','Color',allCamColors');

    % Remove points outside Shelf/Table
    if useBgCalib == 1
        [objSegmPts, allCamColors] = removeEnvPoints(sceneData, backgroundPointCloud, objSegmPts, allCamColors, extBin2Bg, 1);
    else
        [objSegmPts, allCamColors] = removeEnvPoints(sceneData, backgroundPointCloud, objSegmPts, allCamColors, extBin2Bg, 0);
    end

    % Store raw point cloud with colors
    % camPointCloud = pointCloud(objSegmPts','Color',allCamColors');
    % pclname = sprintf('rcnn-raw-%d',obIdx);
    % pclname = fullfile(scenePath, pclname);
    % pcwrite(camPointCloud,pclname,'PLYFormat','binary');

    try
        [objSegmPts, allCamColors] = denoisePointCloud(objSegmPts, allCamColors);
        
        camPointCloud = pointCloud(objSegmPts','Color',allCamColors');
        camPointCloud = pcdownsample(camPointCloud,'gridAverage',gridStep);
        camPointCloud = pcdenoise(camPointCloud,'NumNeighbors',4);

        objName = sceneData.objects{obIdx};
        pclname = sprintf('rcnn-clean-%s',objName);
        pclname = fullfile(scenePath, pclname);
        objSegmPts = camPointCloud.Location';
        objSegmPts = single(objSegmPts);
        nocolorpply = pointCloud(objSegmPts');
        pcwrite(nocolorpply,pclname,'PLYFormat','ascii');
    catch
    end
end