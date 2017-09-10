## PHYSIM_6DPose
This tool performs 6DoF Pose estimation for shelf and table-top environments using multi-view RGB-D images.

Methods you can chose from :-

Object segmentation : RCNN, PHYSIM-RCNN (Self-Supervised), FCN

Point Cloud registration : PCA, Super4PCS

Post-processing : ICP, Physics correction, PhyTrim ICP (Physics-ICP iterative reasoning)

### Installation

1. install ```Matlab Robotics toolbox```

2. execute in matlab ```path-to-repo/ros-packages/src/pose_estimation/src/make.m```

3. setup ```caffe``` for Faster-RCNN(https://github.com/rbgirshick/py-faster-rcnn)

4. setup ```caffe``` for [FCN](https://github.com/andyzeng/apc-vision-toolbox)

5. install [Blender](https://www.blender.org/features/releases/2-78/)

6. realsense camera [setup](https://github.com/IntelRealSense/librealsense/blob/master/doc/installation.md)

7. run ```cd path-to-repo/ros-packages/src```

8. run ```catkin_init_workspace```

9. run ```cd ../```

10. run ```catkin_make```

11. run ```cd src/super4pcs```

12. run ```mkdir build && cd build```

13. run ```cmake -DCMAKE_BUILD_TYPE=Release -DANN_DIR=$PWD/../ann_1.1.2/ ..```

14. run ```make```

in case dependecies are not installed refer to Super4PCS [installation](https://github.com/nmellado/Super4PCS/wiki/Compilation)

15. run ```cd path-to-repo/ros-packages/src/detection_package/lib```

16. run ```make```

17. Add the following to ```~/.bashrc``` :-
```export PHYSIM_6DPose_PATH=path to PHYSIM_6DPose repository```
```export BLENDER_PATH=path to blender```

### Run Pose Estimation on a demo scene

1. run ```cd $PHYSIM_6DPose_PATH```

2. run ```./runMaster.sh```

3. execute in matlab ```ros-packages/src/pose_estimation/src/poseServiceStart.m```

4. run ```rosservice call /pose_estimation "path-to-tmp-directory" "path-to-calibration-folder"```

### Run Pose Estimation on a demo scene

1. run ```robot.launch``` which publishes the realsense camera pose.

2. run ```rosrun marvin_convnet save_images _write_directory:="path-to-some-tmp-directory" _camera_service_name:="/realsense_camera"```

3. run ```rosservice call /save_images ["expo_dry_erase_board_eraser","other-object-names"] binId frameId``` (for table top you can use 13 as the ```bin id``` and for shelf from ```1-12```)

4. run ```rosservice call /pose_estimation "path-to-tmp-directory" "path-to-calibration-folder"```

### References 

1. [Multi-view Self-supervised Deep Learning for 6D Pose Estimation in the Amazon Picking Challenge](http://apc.cs.princeton.edu/) : Andy Zeng, Kuan-Ting Yu, Shuran Song, Daniel Suo, Ed Walker Jr., Alberto Rodriguez and Jianxiong Xiao 

2. [Super4PCS: Fast Global Pointcloud Registration via Smart Indexing](http://geometry.cs.ucl.ac.uk/projects/2014/super4PCS/) : Mellado, Nicolas and Aiger, Dror and Mitra, Niloy J. 

3. [Fast Global registration](http://vladlen.info/publications/fast-global-registration/): Qian-Yi Zhou, Jaesik Park, and Vladlen Koltun 
