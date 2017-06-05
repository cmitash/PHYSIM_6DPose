function runSceneOptimizer(start_pose, init_pose, final_pose, objNames, objModels, sceneData, scenePath)
global transOffset;
global rotOffset;
global sceneDepth;

% physics projection
t = tcpip('localhost',10000);
fopen(t);
fprintf(t,'%d',20);
fclose(t);

t2 = tcpip('localhost', 40000, 'NetworkRole', 'server');
fopen(t2);
fprintf('[Processing] Sending results\n');
fclose(t2)

copyfile(final_pose, init_pose);

% label: expo_dry_erase_board_eraser
% pose: 
%   position: 
%     x: 1.291261
%     y: -0.013044
%     z: 1.367616
%   orientation: 
%     x: 0.554085902189
%     y: -0.299888503239
%     z: -0.251242104699
%     w: 0.734801404086


x = [];
y = [];
score = [];

for obIdx = 1:1
    [~, curr_pose] = readPose(start_pose, obIdx);
    curr_x = curr_pose(1,4);
    curr_y = curr_pose(2,4);
    f_p = getSceneScore(sceneData, init_pose, sceneDepth, obIdx, 0);
    x = [x;curr_x];
    y = [y;curr_y];
    score = [score; f_p];

    count = 0;
    lim_x = 0.05;
    lim_y = 0.05;
    inc_x = 0.005;
    inc_y = 0.005;
    delta_x = -lim_x;
    while delta_x < lim_x
        delta_y = -lim_y;
        while delta_y < lim_y
            delta_x
            delta_y
            i_pose = tweakPoseRunPhysicsEngine2(start_pose, init_pose, obIdx, delta_x, delta_y, count);
            f_p = getSceneScore(sceneData, final_pose, sceneDepth, obIdx, count);
            x = [x;curr_x + delta_x];
            y = [y;curr_y + delta_y];
            score = [score; f_p];
            delta_y = delta_y + inc_y;
            count = count+1;
        end
        delta_x = delta_x + inc_x;
    end
scatter3(x,y,score);
% function ends
end