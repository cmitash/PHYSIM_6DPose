function runSceneOptimizer(start_pose, init_pose, final_pose, objNames, objModels, sceneData, scenePath)
global transOffset;
global rotOffset;
global sceneDepth;

t = tcpip('localhost',10000);
fopen(t);
fprintf(t,'%d',10);
fclose(t);

t2 = tcpip('localhost', 40000, 'NetworkRole', 'server');
fopen(t2);
fprintf('[Processing] Sending results\n');
fclose(t2)

copyfile(start_pose,final_pose);
numIter = 5;
for iter=1:numIter
    for obIdx = 1:size(sceneData.objects,2)
        f_x = getSceneScore(sceneData, start_pose, sceneDepth, obIdx, 0);

        % x-gradient
        i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'x', transOffset, 1);
        f_p_x = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 1);
        i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'x', -transOffset, 2);
        f_n_x = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 2);

        if (f_p_x < f_x) && (f_n_x < f_x)
            p_grad = f_x - f_p_x;
            n_grad = f_x - f_n_x;
            if p_grad > n_grad
                grad_x = p_grad;
            else
                grad_x = -n_grad;
            end
        elseif (f_p_x < f_x)
            grad_x = f_x - f_p_x;
        elseif (f_n_x < f_x)
            grad_x = -(f_x - f_n_x);
        else grad_x = 0;
        end

        % y-gradient
        i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'y', transOffset, 3);
        f_p_y = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 3);
        i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'y', -transOffset, 4);
        f_n_y = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 4);
        if (f_p_y < f_x) && (f_n_y < f_x)
            p_grad = f_x - f_p_y;
            n_grad = f_x - f_n_y;
            if p_grad > n_grad
                grad_y = p_grad;
            else
                grad_y = -n_grad;
            end
        elseif (f_p_y < f_x)
            grad_y = f_x - f_p_y;
        elseif (f_n_y < f_x)
            grad_y = -(f_x - f_n_y);
        else grad_y = 0;
        end

        % z-gradient
        i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'z', transOffset, 5);
        f_p_z = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 5);
        i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'z', -transOffset, 6);
        f_n_z = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 6);

        if (f_p_z < f_x) && (f_n_z < f_x)
            p_grad = f_x - f_p_z;
            n_grad = f_x - f_n_z;
            if p_grad > n_grad
                grad_z = p_grad;
            else
                grad_z = -n_grad;
            end
        elseif (f_p_z < f_x)
            grad_z = f_x - f_p_z;
        elseif (f_n_x < f_x)
            grad_z = -(f_x - f_n_z);
        else grad_z = 0;
        end


        grad_x
        grad_y
        grad_z
        vec_length = sqrt(grad_x^2 + grad_y^2 + grad_z^2);

        if vec_length > 0
            grad_x = (transOffset*grad_x)/vec_length;
            grad_y = (transOffset*grad_y)/vec_length;
            grad_z = (transOffset*grad_z)/vec_length;

            writePose(start_pose, obIdx, 'x', grad_x);
            writePose(start_pose, obIdx, 'y', grad_y);
            writePose(start_pose, obIdx, 'z', grad_z);
        else
            break;
        end

    %     % % +ve roll-gradient
    %     i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'r', rotOffset, 7);
    %     score = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 7);
    %     if score < minscore
    %         minscore = score;
    %         bestObjIdx = obIdx;
    %         bestdir = 7;
    %         grad = 1;
    %     end

    %     % % -ve roll-gradient
    %     i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'r', -rotOffset, 8);
    %     score = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 8);
    %     if score < minscore
    %         minscore = score;
    %         bestObjIdx = obIdx;
    %         bestdir = 8;
    %         grad = 1;
    %     end

    %     % % +ve pitch-gradient
    %     i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'p', rotOffset, 9);
    %     score = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 9);
    %     if score < minscore
    %         minscore = score;
    %         bestObjIdx = obIdx;
    %         bestdir = 9;
    %         grad = 1;            
    %     end

    %     % % -ve pitch-gradient
    %     i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'p', -rotOffset, 10);
    %     score = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 10);
    %     if score < minscore
    %         minscore = score;
    %         bestObjIdx = obIdx;
    %         bestdir = 10;
    %         grad = 1;            
    %     end

    %     % % +ve yaw-gradient
    %     i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'w', rotOffset, 11);
    %     score = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 11);
    %     if score < minscore
    %         minscore = score;
    %         bestObjIdx = obIdx;
    %         bestdir = 11;
    %         grad = 1;
    %     end

    %     % % -ve yaw-gradient
    %     i_pose = tweakPoseRunPhysicsEngine(start_pose, init_pose, obIdx, 'w', -rotOffset, 12);
    %     score = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 12);
    %     if score < minscore
    %         minscore = score;
    %         bestObjIdx = obIdx;
    %         bestdir = 12;
    %         grad = 1;
    %     end
    end
end




end