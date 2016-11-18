cmake_minimum_required(VERSION 2.8.3)
project(pose_estimation)

## is used, also find other catkin packages
find_package(catkin REQUIRED)

## System dependencies are found with CMake's conventions
find_package(catkin REQUIRED COMPONENTS roscpp message_generation geometry_msgs std_msgs)

## Generate messages in the 'msg' folder
add_message_files(
  FILES
  ObjectPose.msg
)

## Generate services in the 'srv' folder
add_service_files(
  FILES
  EstimateObjectPose.srv
)

## Generate added messages and services with any dependencies listed here
generate_messages(
  DEPENDENCIES
  std_msgs  # Or other packages containing msgs
  geometry_msgs
)

catkin_package(
)