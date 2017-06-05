function writePose(pose_file, objectIdx, chaxis, chval)

[~, tweaked_pose] = readPose(pose_file, objectIdx);

[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12, val13, val14, val15] = textread(pose_file, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n');

obname = objName{objectIdx,1};

if(strcmp(chaxis,'x') == 1)
	val4(objectIdx,1) = val4(objectIdx,1) + chval;
	tweaked_pose(1,4) = tweaked_pose(1,4) + chval;
elseif(strcmp(chaxis,'y') == 1)
	val8(objectIdx,1) = val8(objectIdx,1) + chval;
	tweaked_pose(2,4) = tweaked_pose(2,4) + chval;
elseif(strcmp(chaxis,'z') == 1)
	val12(objectIdx,1) = val12(objectIdx,1) + chval;
	tweaked_pose(3,4) = tweaked_pose(3,4) + chval;	
elseif(strcmp(chaxis,'r') == 1)
	rotMatrix = [val1(objectIdx,1), val2(objectIdx,1), val3(objectIdx,1);...
				 val5(objectIdx,1), val6(objectIdx,1), val7(objectIdx,1);...
	             val9(objectIdx,1), val10(objectIdx,1), val11(objectIdx,1)];
	origeulZYX = rotm2eul(rotMatrix);
	origeulZYX(1,1) = origeulZYX(1,1) + chval;
	tweaked_pose(1:3,1:3) = eul2rotm(origeulZYX);
	val1(objectIdx,1) = tweaked_pose(1,1);
	val2(objectIdx,1) = tweaked_pose(1,2);
	val3(objectIdx,1) = tweaked_pose(1,3);
	val5(objectIdx,1) = tweaked_pose(2,1);
	val6(objectIdx,1) = tweaked_pose(2,2);
	val7(objectIdx,1) = tweaked_pose(2,3);
    val9(objectIdx,1) = tweaked_pose(3,1);
    val10(objectIdx,1) = tweaked_pose(3,2);
    val11(objectIdx,1) = tweaked_pose(3,3);

elseif(strcmp(chaxis,'p') == 1)
	rotMatrix = [val1(objectIdx,1), val2(objectIdx,1), val3(objectIdx,1);...
				 val5(objectIdx,1), val6(objectIdx,1), val7(objectIdx,1);...
	             val9(objectIdx,1), val10(objectIdx,1), val11(objectIdx,1)];
	origeulZYX = rotm2eul(rotMatrix);
	origeulZYX(1,2) = origeulZYX(1,2) + chval;
	tweaked_pose(1:3,1:3) = eul2rotm(origeulZYX);
	val1(objectIdx,1) = tweaked_pose(1,1);
	val2(objectIdx,1) = tweaked_pose(1,2);
	val3(objectIdx,1) = tweaked_pose(1,3);
	val5(objectIdx,1) = tweaked_pose(2,1);
	val6(objectIdx,1) = tweaked_pose(2,2);
	val7(objectIdx,1) = tweaked_pose(2,3);
    val9(objectIdx,1) = tweaked_pose(3,1);
    val10(objectIdx,1) = tweaked_pose(3,2);
    val11(objectIdx,1) = tweaked_pose(3,3);	
elseif(strcmp(chaxis,'w') == 1)
	rotMatrix = [val1(objectIdx,1), val2(objectIdx,1), val3(objectIdx,1);...
				 val5(objectIdx,1), val6(objectIdx,1), val7(objectIdx,1);...
	             val9(objectIdx,1), val10(objectIdx,1), val11(objectIdx,1)];
	origeulZYX = rotm2eul(rotMatrix);
	origeulZYX(1,3) = origeulZYX(1,3) + chval;
	tweaked_pose(1:3,1:3) = eul2rotm(origeulZYX);
	val1(objectIdx,1) = tweaked_pose(1,1);
	val2(objectIdx,1) = tweaked_pose(1,2);
	val3(objectIdx,1) = tweaked_pose(1,3);
	val5(objectIdx,1) = tweaked_pose(2,1);
	val6(objectIdx,1) = tweaked_pose(2,2);
	val7(objectIdx,1) = tweaked_pose(2,3);
    val9(objectIdx,1) = tweaked_pose(3,1);
    val10(objectIdx,1) = tweaked_pose(3,2);
    val11(objectIdx,1) = tweaked_pose(3,3);	
end

pf = fopen(pose_file, 'wt');
for obIdx = 1:size(val1,1)
    name = objName{obIdx,1};

	fprintf(pf, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n', ...
	                name, ...
	                val1(obIdx,1), val2(obIdx,1), val3(obIdx,1), val4(obIdx,1), ...
	                val5(obIdx,1), val6(obIdx,1), val7(obIdx,1), val8(obIdx,1), ...
	                val9(obIdx,1), val10(obIdx,1), val11(obIdx,1), val12(obIdx,1), ...
	                val13(obIdx,1), val14(obIdx,1), val15(obIdx,1) ...
	            );
end

end