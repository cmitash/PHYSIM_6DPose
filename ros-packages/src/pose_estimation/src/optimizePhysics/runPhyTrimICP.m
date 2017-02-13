function runPhyTrimICP(init_pose, final_pose, objNames, objModels, sceneData, scenePath)

gridStep = 0.002;
icpWorstRejRatio = 0.9;

% Iterative Optimization : Vision and Physics
numItr = 3;
icp_factor = 1;
for iter = 1:numItr
    fprintf('Iteration : %d\n', iter);

    fprintf('[Processing] get Physics fix vector\n');

    t = tcpip('localhost',10000);
    fopen(t);
    fprintf(t,'%d',5);
    fclose(t);
    
    t2 = tcpip('localhost', 40001, 'NetworkRole', 'server');
    fopen(t2);
    fprintf('[Processing] Sending results\n');
    fclose(t2)

    % Read Current Pose
    [objName, val1, val2, val3, val4, ...
     val5, val6, val7, val8, ...
     val9, val10, val11, val12, val13, val14, val15] = textread(final_pose, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n');

    fprintf('[Processing] get ICP fix vector\n');
    ip = fopen(init_pose, 'wt');
    for obIdx = 1:size(val1,1)
        name = objName{obIdx,1};
        objModel = objModels{find(ismember(objNames,name))};
        try
            objModelPts = objModel.Location;
            objModelCloud = pointCloud(objModelPts);
            objModelCloud = pcdownsample(objModelCloud,'gridAverage',gridStep);
            objModelPts = objModelCloud.Location';

            predObjPoseWorld = zeros(4,4);

            predObjPoseWorld(1,1) = val1(obIdx,1);
            predObjPoseWorld(1,2) = val2(obIdx,1);
            predObjPoseWorld(1,3) = val3(obIdx,1);
            predObjPoseWorld(1,4) = val4(obIdx,1);
            predObjPoseWorld(2,1) = val5(obIdx,1);
            predObjPoseWorld(2,2) = val6(obIdx,1);
            predObjPoseWorld(2,3) = val7(obIdx,1);
            predObjPoseWorld(2,4) = val8(obIdx,1);
            predObjPoseWorld(3,1) = val9(obIdx,1);
            predObjPoseWorld(3,2) = val10(obIdx,1);
            predObjPoseWorld(3,3) = val11(obIdx,1);
            predObjPoseWorld(3,4) = val12(obIdx,1);
            predObjPoseWorld(4,4) = 1;

            predObjPoseBin = inv(sceneData.extBin2World)*predObjPoseWorld;
            tmpObjModelPts = predObjPoseBin(1:3,1:3) * objModelPts + repmat(predObjPoseBin(1:3,4),1,size(objModelPts,2));
            tmpObjModelCloud = pointCloud(tmpObjModelPts');

            pclname = sprintf('rcnn-clean-%s.ply',name);
            pclname = fullfile(scenePath, pclname);
            objSegCloud = pcread(pclname);

            pclname = sprintf('rcnn-model-%s',name);
            pclname = fullfile(scenePath, pclname);
            pcwrite(tmpObjModelCloud,pclname,'PLYFormat','binary');

            [tform,movingReg,icpRmse] = pcregrigidGPU(objSegCloud,tmpObjModelCloud,'InlierRatio',icpWorstRejRatio/icp_factor,...
                                            'MaxIterations',100,'Tolerance',[0.0001 0.0009],'Verbose',false,'Extrapolate',true);
            
            % Final pose ICP
            VRt = inv(tform.T');
            VPose = VRt * predObjPoseBin;
            VPose = sceneData.extBin2World * VPose;

            % Write Poses to a file
            fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
                name, ...
                VPose(1,1), VPose(1,2), VPose(1,3), VPose(1,4), ...
                VPose(2,1), VPose(2,2), VPose(2,3), VPose(2,4), ...
                VPose(3,1), VPose(3,2), VPose(3,3), VPose(3,4), ...
                sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
            );
        catch
            fprintf('No points for ICP\n');
            % Write Poses to a file
            fprintf(ip, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
                name, ...
                1, 0, 0, 0, ...
                0, 1, 0, 0, ...
                0, 0, 1, 0, ...
                sceneData.extBin2World(1,4), sceneData.extBin2World(2,4), sceneData.extBin2World(3,4) ...
            );
        end
    end
    fclose(ip);
    icp_factor = icp_factor*1.2;
    
end

fprintf('[Processing] Final Physics Fix\n');

t = tcpip('localhost',10000);
fopen(t);
fprintf(t,'%d', 20);
fclose(t);

t2 = tcpip('localhost', 40001, 'NetworkRole', 'server');
fopen(t2);
fprintf('[Processing] Sending results\n');
fclose(t2)

end