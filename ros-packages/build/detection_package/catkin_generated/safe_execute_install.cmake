execute_process(COMMAND "/home/pracsys/github/PHYSIM_6DPose/ros-packages/build/detection_package/catkin_generated/python_distutils_install.sh" RESULT_VARIABLE res)

if(NOT res EQUAL 0)
  message(FATAL_ERROR "execute_process(/home/pracsys/github/PHYSIM_6DPose/ros-packages/build/detection_package/catkin_generated/python_distutils_install.sh) returned error code ")
endif()
