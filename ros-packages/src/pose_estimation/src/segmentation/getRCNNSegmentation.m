function getRCNNSegmentation(sceneData, scenePath, tmpDataPath, apc_objects_strs, frames, numFrames)

global gridStep;
global useBgCalib;
global detThreshold;
global debugOption;

% Calibrate the table/shelf
backgroundPointCloud = 0;
extBin2Bg = 0;
if useBgCalib == 1
    [extBin2Bg, backgroundPointCloud] = getExactEnvCalib(sceneData, scenePath);
end

% Call RCNN detector to do 2D object segmentation for each RGB-D frame
active_list = zeros(1,size(sceneData.objects,2));
for obIdx = 1:size(sceneData.objects,2)
    active_list(1,obIdx) = int16(apc_objects_strs(sceneData.objects{1,obIdx}));
end
disp(active_list);
[client,reqMsg] = rossvcclient('/update_active_list_and_frame');
[client2,reqMsg2] = rossvcclient('/update_bbox');
for frameIdx = frames
    fprintf('%d ',frameIdx);
    frameStr = sprintf('%06d',frameIdx-1);
    reqMsg.ActiveList = active_list;
    reqMsg.ActiveFrame = frameStr;
    call(client,reqMsg);
    reqMsg2.Request = 1;
    response = call(client2,reqMsg2);
end

mkdir(fullfile(scenePath,'bbox_detections'));
copyfile(fullfile(tmpDataPath,'bbox_detections','*'),fullfile(scenePath,'bbox_detections'));

for obIdx = 1:size(sceneData.objects,2)
    maskFiles = dir(fullfile(tmpDataPath,'bbox_detections',sprintf('*.%s.mask.png',sceneData.objects{1,obIdx})));
    scoreFiles = dir(fullfile(tmpDataPath,'bbox_detections',sprintf('*.%s.score.txt',sceneData.objects{1,obIdx})));
    allCamColors = [];
    objSegmPts = [];
    for frameIdx = 1:size(frames,2)
        file = fopen(fullfile(tmpDataPath,'bbox_detections',scoreFiles(frameIdx).name),'r');
        score = fscanf(file,'%f');
        fclose(file);
        if score > detThreshold
            tmpObjMask = imread(fullfile(tmpDataPath,'bbox_detections',maskFiles(frameIdx).name));
            tmpDepth = sceneData.depthFrames{frames(1,frameIdx)};
            color = sceneData.colorFrames{frames(1,frameIdx)};
            tmpExtCam2World = sceneData.extCam2World{frames(1,frameIdx)};
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

    try
        % Remove points outside Shelf/Table
        if useBgCalib == 1
            [objSegmPts, allCamColors] = removeEnvPoints(sceneData, backgroundPointCloud, objSegmPts, allCamColors, extBin2Bg, 1);
        else
            [objSegmPts, allCamColors] = removeEnvPoints(sceneData, backgroundPointCloud, objSegmPts, allCamColors, extBin2Bg, 0);
        end
    catch
        fprintf('No points found');
    end

    try
        [objSegmPts, allCamColors] = denoisePointCloud(objSegmPts, allCamColors);
        
        camPointCloud = pointCloud(objSegmPts','Color',allCamColors');
        camPointCloud = pcdownsample(camPointCloud,'gridAverage',gridStep);
        camPointCloud = pcdenoise(camPointCloud,'NumNeighbors',4);

        objName = sceneData.objects{obIdx};
        pclname = sprintf('seg-no-color-%s',objName);
        pclname = fullfile(scenePath, pclname);

        % debug option : store colored point cloud of the results
        if debugOption == true
            pclname_color = sprintf('seg-color-%s',objName);
            pclname_color = fullfile(scenePath, pclname_color);
            pcwrite(camPointCloud,pclname_color,'PLYFormat','binary');
        end

        objSegmPts = camPointCloud.Location';
        objSegmPts = single(objSegmPts);
        nocolorpply = pointCloud(objSegmPts');
        pcwrite(nocolorpply,pclname,'PLYFormat','binary');
    catch
        fprintf('No points found');
    end
end