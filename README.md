6D Pose estimation for shelf and table-top environments.

Methods you can chose from :-

Object segmentation : RCNN, PHYSIM-RCNN (Self-Supervised), FCN 

Point Cloud registration : PCA, Super4PCS

Post-processing : ICP, Physics correction, PhyTrim ICP (Physics-ICP iterative reasoning) 

Installation :-

1) setup matlab, robotics toolbox and run "ros-packages/src/pose_estimation/src/make.m"

2) setup caffe according to "https://github.com/rbgirshick/py-faster-rcnn"

3) install blender (for using physics)

4) follow installation for librealsense as in "https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md"

5) catkin_make in ros-packages

Add the following to .bashrc :-

export PHYSIM_6DPose_PATH=path to PHYSIM_6DPose repository

source $PHYSIM_6DPose_PATH/ros-packages/devel/setup.sh

export BLENDER_PATH=path to blender (In case you want to use physics)

Basic Usage :-

1) start "robot.launch" which publishes the realsense camera pose. (staticTrans.txt in repository root has current camera pose)

2) run "./ros-packages/src/detection_package/bin/detect_bbox" (you would need the trained model)

3) start matlab and run "ros-packages/src/pose_estimation/src/poseServiceStart.m"

4) rosrun marvin_convnet save_images _write_directory:="path-to-some-tmp-directory" _camera_service_name:="/realsense_camera"

5) rosservice call /save_images ["expo_dry_erase_board_eraser","other-object-names"] binId frameId
(for table top you can use 13 as the bin id, and for shelf from 1-12)

6) rosservice call /pose_estimation "path-to-tmp-directory" "path-to-calibration-folder" 



more details coming soon...