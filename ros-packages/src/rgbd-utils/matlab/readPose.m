function [obname, predObjPoseWorld] = readPose(pose_file, objectIdx)

[objName, val1, val2, val3, val4, ...
 val5, val6, val7, val8, ...
 val9, val10, val11, val12, val13, val14, val15] = textread(pose_file, '%s %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n');

predObjPoseWorld = zeros(4,4);

predObjPoseWorld(1,1) = val1(objectIdx,1);
predObjPoseWorld(1,2) = val2(objectIdx,1);
predObjPoseWorld(1,3) = val3(objectIdx,1);
predObjPoseWorld(1,4) = val4(objectIdx,1);
predObjPoseWorld(2,1) = val5(objectIdx,1);
predObjPoseWorld(2,2) = val6(objectIdx,1);
predObjPoseWorld(2,3) = val7(objectIdx,1);
predObjPoseWorld(2,4) = val8(objectIdx,1);
predObjPoseWorld(3,1) = val9(objectIdx,1);
predObjPoseWorld(3,2) = val10(objectIdx,1);
predObjPoseWorld(3,3) = val11(objectIdx,1);
predObjPoseWorld(3,4) = val12(objectIdx,1);
predObjPoseWorld(4,4) = 1;

obname = objName{objectIdx,1};
end