function getGTBBoxSegmentation(sceneData, scenePath, tmpDataPath, apc_objects_strs, frames, numFrames, objNames)

% if you want to use background calibration (default = false)
useBgCalib = 1;

% grid size for downsampling point clouds
gridStep = 0.002;

% Calibrate the table/shelf
backgroundPointCloud = 0;
extBin2Bg = 0;
if useBgCalib == 1
    [extBin2Bg, backgroundPointCloud] = getExactEnvCalib(sceneData, scenePath);
end

mkdir(fullfile(scenePath,'bbox_detections'));

for obIdx = 1:size(sceneData.objects,2)
    objMasks = {};
    allCamColors = [];
    objSegmPts = [];
    objName = sceneData.objects{obIdx};
    for frameIdx = frames
        currGroundTruthSegm = imread(fullfile(scenePath,'segm',sprintf('frame-%06d.segm.png',frameIdx-1)));
        objId = find(~cellfun(@isempty,strfind(objNames,objName)));
        currGroundTruthMask = double(currGroundTruthSegm)./6 == objId;
        region = regionprops(currGroundTruthMask, 'BoundingBox');
        maxidx = 1;
        maxsize = 0;
        for i=1:size(region,1)
            BB = region(i).BoundingBox;
            if(BB(1,3) > maxsize)
                maxsize = BB(1,3);
                maxidx = i;
            end
        end
        if maxsize > 0
            bbox = region(maxidx).BoundingBox;
            currGroundTruthMask(int16(bbox(1,2)):int16(bbox(1,2)) + int16(bbox(1,4))-2, int16(bbox(1,1)):int16(bbox(1,1)) + int16(bbox(1,3))-2) = 1;
        end

        imwrite(currGroundTruthMask, fullfile(scenePath,'bbox_detections',sprintf('frame-%06d.%s.mask.png',frameIdx-1,objName)));
        objMasks{frameIdx} = currGroundTruthMask;

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

    % Remove points outside Shelf/Table
    if useBgCalib == 1
        [objSegmPts, allCamColors] = removeEnvPoints(sceneData, backgroundPointCloud, objSegmPts, allCamColors, extBin2Bg, 1);
    else
        [objSegmPts, allCamColors] = removeEnvPoints(sceneData, backgroundPointCloud, objSegmPts, allCamColors, extBin2Bg, 0);
    end

    [objSegmPts, allCamColors] = denoisePointCloud(objSegmPts, allCamColors);
    
    camPointCloud = pointCloud(objSegmPts','Color',allCamColors');
    camPointCloud = pcdownsample(camPointCloud,'gridAverage',gridStep);
    camPointCloud = pcdenoise(camPointCloud,'NumNeighbors',4);

    pclname = sprintf('rcnn-clean-%s',objName);
    pclname = fullfile(scenePath, pclname);
    objSegmPts = camPointCloud.Location';
    nocolorpply = pointCloud(objSegmPts');
    pcwrite(nocolorpply,pclname,'PLYFormat','ascii');
end