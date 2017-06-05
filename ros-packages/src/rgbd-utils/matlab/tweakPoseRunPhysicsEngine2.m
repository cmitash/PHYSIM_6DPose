function tweaked_pose = tweakPoseRunPhysicsEngine2(start_pose, pose_file, objectIdx, chng_x, chng_y, gradDir)

[~, tweaked_pose] = readPose(start_pose, objectIdx);


[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12, val13, val14, val15] = textread(start_pose, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n');


val4(objectIdx,1) = val4(objectIdx,1) + chng_x;
tweaked_pose(1,4) = tweaked_pose(1,4) + chng_x;

val8(objectIdx,1) = val8(objectIdx,1) + chng_y;
tweaked_pose(2,4) = tweaked_pose(2,4) + chng_y;

pf = fopen(pose_file, 'wt');
% finf = fopen('/home/chaitanya/github/PHYSIM_6DPose/tmp/final_pose.txt', 'wt');

for obIdx = 1:size(val1,1)
    name = objName{obIdx,1};

	fprintf(pf, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
	                name, ...
	                val1(obIdx,1), val2(obIdx,1), val3(obIdx,1), val4(obIdx,1), ...
	                val5(obIdx,1), val6(obIdx,1), val7(obIdx,1), val8(obIdx,1), ...
	                val9(obIdx,1), val10(obIdx,1), val11(obIdx,1), val12(obIdx,1), ...
	                val13(obIdx,1), val14(obIdx,1), val15(obIdx,1) ...
	            );

	% fprintf(finf, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
	%                 name, ...
	%                 val1(obIdx,1), val2(obIdx,1), val3(obIdx,1), val4(obIdx,1), ...
	%                 val5(obIdx,1), val6(obIdx,1), val7(obIdx,1), val8(obIdx,1), ...
	%                 val9(obIdx,1), val10(obIdx,1), val11(obIdx,1), val12(obIdx,1), ...
	%                 val13(obIdx,1), val14(obIdx,1), val15(obIdx,1) ...
	%             );
end
fclose(pf);
% fclose(finf);

t = tcpip('localhost',10000);
fopen(t);
fprintf(t,'%d',5);
fclose(t);

t2 = tcpip('localhost', 40000, 'NetworkRole', 'server');
fopen(t2);
fprintf('[Processing] Sending results\n');
fclose(t2)

end