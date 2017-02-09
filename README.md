<snippet>
  <content><![CDATA[

# ${1:PHYSIM_6DPose}
6D Pose estimation for shelf and table-top environments.

Methods you can chose from :-

Object segmentation : RCNN, PHYSIM-RCNN (Self-Supervised), FCN

Point Cloud registration : PCA, Super4PCS

Post-processing : ICP, Physics correction, PhyTrim ICP (Physics-ICP iterative reasoning)

## Installation

1) setup Matlab, Matlab Robotics toolbox 

2) run ros-packages/src/pose_estimation/src/make.m

2) setup caffe for RCNN according to : https://github.com/rbgirshick/py-faster-rcnn

3) setup caffe for FCN according to : https://github.com/andyzeng/apc-vision-toolbox

4) install blender (if you wish to use physics or generate synthetic dataset)

5) for realsense camera setup : https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md

6) run catkin_make in the workspace to compile

7) cd ros-packages/src/super4pcs

8) mkdir build && cd build

9) cmake -DCMAKE_BUILD_TYPE=Release -DANN_DIR=$PWD/../ann_1.1.2/ ..

10) make

11) this might require dependencies as in https://github.com/nmellado/Super4PCS/wiki/Compilation

12) cd /home/pracsys/repos/pracsys_ws/src/PHYSIM_6DPose/ros-packages/src/detection_package/lib

13) make

14) Add the following to .bashrc :-

export PHYSIM_6DPose_PATH=path to PHYSIM_6DPose repository

source $PHYSIM_6DPose_PATH/ros-packages/devel/setup.sh

export BLENDER_PATH=path to blender

## Usage

1) start "robot.launch" which publishes the realsense camera pose. (staticTrans.txt in repository root has current camera pose)

2) run "./ros-packages/src/detection_package/bin/detect_bbox" (you would need the trained model)

3) start matlab and run "ros-packages/src/pose_estimation/src/poseServiceStart.m"

4) rosrun marvin_convnet save_images _write_directory:="path-to-some-tmp-directory" _camera_service_name:="/realsense_camera"

5) rosservice call /save_images ["expo_dry_erase_board_eraser","other-object-names"] binId frameId (for table top you can use 13 as the bin id, and for shelf from 1-12)

6) rosservice call /pose_estimation "path-to-tmp-directory" "path-to-calibration-folder"

## References 

]]></content>
  <tabTrigger>readme</tabTrigger>
</snippet>
