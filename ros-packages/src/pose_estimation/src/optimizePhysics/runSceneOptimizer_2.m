function runSceneOptimizer(start_pose, init_pose, final_pose, objNames, objModels, sceneData, scenePath)
global transOffset;
global rotOffset;
global sceneDepth;

t = tcpip('localhost',10000);
fopen(t);
fprintf(t,'%d',20);
fclose(t);

t2 = tcpip('localhost', 40000, 'NetworkRole', 'server');
fopen(t2);
fprintf('[Processing] Sending results\n');
fclose(t2)

copyfile(final_pose, init_pose);

for iter = 1:1
    for obIdx = 1:1
        init_p = getSceneScore(sceneData, init_pose, sceneDepth, obIdx, 0)
        
        % +ve x line search
        curr_p = init_p;
        while 1
            i_pose = tweakPoseRunPhysicsEngine(init_pose, init_pose, obIdx, 'x', transOffset, 1);
            f_p = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 1)
            if f_p < curr_p
                curr_p = f_p;
                copyfile(final_pose, init_pose);
            else
                break;
            end
        end

        % % -ve x line search
        % curr_p = init_p;
        % while 1
        %     i_pose = tweakPoseRunPhysicsEngine(init_pose, init_pose, obIdx, 'x', -transOffset, 2);
        %     f_p = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 1);
        %     if f_p < curr_p
        %         curr_p = f_p;
        %         copyfile(final_pose, init_pose);
        %     else
        %         break;
        %     end
        % end

        %  % +ve y line search
        % init_p = curr_p;
        % while 1
        %     i_pose = tweakPoseRunPhysicsEngine(init_pose, init_pose, obIdx, 'y', transOffset, 3);
        %     f_p= getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 1);
        %     if f_p < curr_p
        %         curr_p = f_p;
        %         copyfile(final_pose, init_pose);
        %     else
        %         break;
        %     end
        % end

        % % -ve y line search
        % curr_p = init_p;
        % while 1
        %     i_pose = tweakPoseRunPhysicsEngine(init_pose, init_pose, obIdx, 'y', -transOffset, 4);
        %     f_p = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, 1);
        %     if f_p < curr_p
        %         curr_p = f_p;
        %         copyfile(final_pose, init_pose);
        %     else
        %         break;
        %     end
        % end
    end
end

% function ends
end