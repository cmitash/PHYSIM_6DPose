PHYSIM_6DPose

Installation :-

1) run catkin_init_workspace in "PHYSIM_6DPose/ros-packages/src".

2) run roscore

3) run make.m and follow instructions in "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/src/make.m"

4) run catkin_make in "/home/pracsys/github/PHYSIM_6DPose/ros-packages"

Caffe setup :-

https://github.com/rbgirshick/py-faster-rcnn

Running the program :-

1) run ./home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/bin/detect_bbox

2) run /home/pracsys/github/PHYSIM_6DPose/ros-packages/src/physics-scene-rendering-vision/StartPhysicsService.py

3) run /home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/src/poseServiceStart.m

4) run rosservice call /pose_estimation "scene folder path" "calibration folder path"

Add the following to .bashrc "-

export PHYSIM_6DPose_PATH=path to PHYSIM_6DPose repository

source $PHYSIM_6DPose_PATH/ros-packages/devel/setup.sh

export BLENDER_PATH=path to blender