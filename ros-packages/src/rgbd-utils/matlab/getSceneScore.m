function score = getSceneScore(sceneData, final_pose, obs_scene, objectIndexChanged, scene_num)
global gridStep;
global objNames;
global objModels;

for obIdx = 1:size(sceneData.objects,2)
    [name, predObjPoseWorld]  = readPose(final_pose, obIdx);
    objModel = objModels{find(ismember(objNames,name))};
    objModelPts = objModel.Location';
    predObjPoseCam = inv(sceneData.extCam2World{1})*predObjPoseWorld;

    tmpObjModelPts = predObjPoseCam(1:3,1:3) * objModelPts + repmat(predObjPoseCam(1:3,4),1,size(objModelPts,2));
    if obIdx == 1
    	ObjPointCloud = pointCloud(tmpObjModelPts');
    else
    	ObjPointCloud = pcmerge(ObjPointCloud,pointCloud(tmpObjModelPts'),gridStep);
    end
end

camPts = ObjPointCloud.Location';
tmpsceneDepth = renderDepth(sceneData, camPts, sprintf('~/Desktop/tmp_scene-%d-%d.png',objectIndexChanged, scene_num));

maskimg = zeros(480,640);
nonZeroEl = find(obs_scene);
maskimg(nonZeroEl) = 1;

intersectImg = tmpsceneDepth.*maskimg;
% intersectCount = size(find(intersectImg),1);
% int_score = intersectCount/size(nonZeroEl,1);

dist_score = sumabs(intersectImg - obs_scene);

score = dist_score;
end