cmake_minimum_required(VERSION 3.1.0)
set(CMAKE_CXX_STANDARD 11)
project(marvin_convnet)

## Find catkin macros and libraries
## IF COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages

## System dependencies are found with CMake's conventions
find_package(catkin REQUIRED COMPONENTS
  roscpp
  message_generation
  geometry_msgs
  std_msgs
  tf
)

find_package(OpenCV REQUIRED)

# CUDA and CUDNN
find_package(CUDA REQUIRED)
set(CUDA_HOST_COMPILER "c++")
set(CUDA_NVCC_FLAGS "-std=c++11")
# set(CUDNN_INCLUDE_DIR /usr/local/cudnn/v5/include)
set(CUDNN_LIB_DIR /usr/local/cudnn/v5/lib64)

## Generate services in the 'srv' folder
add_service_files(
  FILES
  DetectObjects.srv
)

## Generate added messages and services with any dependencies listed here
generate_messages(
  DEPENDENCIES
  std_msgs  # Or other packages containing msgs
  geometry_msgs
)

# Add C++ header/source files
SET(HEADERS
  include/depth_utils.h
  src/marvin.hpp
)

## Declare a C++ executable
include_directories(include /usr/local/include ${catkin_INCLUDE_DIRS} ${OpenCV_INCLUDE_DIR})
link_directories(${CUDNN_LIB_DIR} ${OpenCV_LIB_DIR})

# cuda_add_executable(detect src/detect.cu ${HEADERS})
# target_link_libraries(detect ${catkin_LIBRARIES} realsense ${OpenCV_LIBS}
#                       pthread /usr/local/cudnn/v5/lib64/libcudnn.so.5.0.5 /usr/local/cudnn/v5/lib64/libcudnn_static.a ${CUDA_CUBLAS_LIBRARIES} ${CUDA_LIBRARIES} ${CUDA_curand_LIBRARY})
# add_dependencies(detect ${PROJECT_NAME}_gencpp)
# add_dependencies(detect ${PROJECT_NAME}_generate_messages_cpp)

cuda_add_executable(save_images src/save_images.cpp ${HEADERS})
target_link_libraries(save_images ${catkin_LIBRARIES} realsense ${OpenCV_LIBS}
                      pthread /usr/local/cuda/lib64/libcudnn.so /usr/local/cuda/lib64/libcudnn_static.a ${CUDA_CUBLAS_LIBRARIES} ${CUDA_LIBRARIES} ${CUDA_curand_LIBRARY})
add_dependencies(save_images ${PROJECT_NAME}_gencpp)
add_dependencies(save_images ${PROJECT_NAME}_generate_messages_cpp)
