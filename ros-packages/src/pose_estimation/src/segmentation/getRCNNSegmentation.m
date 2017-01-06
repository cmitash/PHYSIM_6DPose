function getRCNNSegmentation(sceneData, scenePath, tmpDataPath, apc_objects_strs, frames, numFrames)

% if you want to use background calibration (default = false)
useBgCalib = 0;

% grid size for downsampling point clouds
gridStep = 0.002;

% Call RCNN detector to do 2D object segmentation for each RGB-D frame
active_list = zeros(1,size(sceneData.objects,2));
for obIdx = 1:size(sceneData.objects,2)
    active_list(1,obIdx) = apc_objects_strs(sceneData.objects{1,obIdx});
end
disp(active_list);
[client,reqMsg] = rossvcclient('/update_active_list_and_frame');
[client2,reqMsg2] = rossvcclient('/update_bbox');
for frameIdx = 0:(numFrames-1)
    fprintf('%d ',frameIdx);
    frameStr = sprintf('%06d',frameIdx);
    reqMsg.ActiveList = active_list;
    reqMsg.ActiveFrame = frameStr;
    call(client,reqMsg);
    reqMsg2.Request = 1;
    response = call(client2,reqMsg2);
end

mkdir(fullfile(scenePath,'bbox_detections'));
copyfile(fullfile(tmpDataPath,'bbox_detections','*'),fullfile(scenePath,'bbox_detections'));

% Calibrate the table/shelf
backgroundPointCloud = 0;
extBin2Bg = 0;
if useBgCalib == 1
    [extBin2Bg, backgroundPointCloud] = getExactEnvCalib(sceneData, scenePath);
end

for obIdx = 1:size(sceneData.objects,2)
    maskFiles = dir(fullfile(tmpDataPath,'bbox_detections',sprintf('*.%s.mask.png',sceneData.objects{1,obIdx})));
    scoreFiles = dir(fullfile(tmpDataPath,'bbox_detections',sprintf('*.%s.score.txt',sceneData.objects{1,obIdx})));
    objMasks = {};
    allCamColors = [];
    objSegmPts = [];
    for frameIdx = frames
        objMasks{frameIdx} = imread(fullfile(tmpDataPath,'bbox_detections',maskFiles(frameIdx).name));
        file = fopen(fullfile(tmpDataPath,'bbox_detections',scoreFiles(frameIdx).name),'r');
        score = fscanf(file,'%f');
        fclose(file);
        if score > 0.0
            tmpObjMask = objMasks{frameIdx};
            tmpDepth = sceneData.depthFrames{frameIdx};
            color = sceneData.colorFrames{frameIdx};
            tmpExtCam2World = sceneData.extCam2World{frameIdx};
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
        end
    end

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

    [objSegmPts, allCamColors] = denoisePointCloud(objSegmPts, allCamColors);
    
    camPointCloud = pointCloud(objSegmPts','Color',allCamColors');
    camPointCloud = pcdownsample(camPointCloud,'gridAverage',gridStep);
    camPointCloud = pcdenoise(camPointCloud,'NumNeighbors',4);

    objName = sceneData.objects{obIdx};
    pclname = sprintf('rcnn-clean-%s',objName);
    pclname = fullfile(scenePath, pclname);
    objSegmPts = camPointCloud.Location';
    nocolorpply = pointCloud(objSegmPts');
    pcwrite(nocolorpply,pclname,'PLYFormat','ascii');
end