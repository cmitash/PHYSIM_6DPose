# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "pose_estimation: 1 messages, 1 services")

set(MSG_I_FLAGS "-Ipose_estimation:/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg;-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/indigo/share/geometry_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(pose_estimation_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg" NAME_WE)
add_custom_target(_pose_estimation_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "pose_estimation" "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg" "geometry_msgs/Quaternion:geometry_msgs/Point:geometry_msgs/Pose"
)

get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/srv/EstimateObjectPose.srv" NAME_WE)
add_custom_target(_pose_estimation_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "pose_estimation" "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/srv/EstimateObjectPose.srv" "geometry_msgs/Quaternion:geometry_msgs/Point:pose_estimation/ObjectPose:geometry_msgs/Pose"
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(pose_estimation
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/pose_estimation
)

### Generating Services
_generate_srv_cpp(pose_estimation
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/srv/EstimateObjectPose.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/pose_estimation
)

### Generating Module File
_generate_module_cpp(pose_estimation
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/pose_estimation
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(pose_estimation_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(pose_estimation_generate_messages pose_estimation_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg" NAME_WE)
add_dependencies(pose_estimation_generate_messages_cpp _pose_estimation_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/srv/EstimateObjectPose.srv" NAME_WE)
add_dependencies(pose_estimation_generate_messages_cpp _pose_estimation_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(pose_estimation_gencpp)
add_dependencies(pose_estimation_gencpp pose_estimation_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS pose_estimation_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(pose_estimation
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/pose_estimation
)

### Generating Services
_generate_srv_lisp(pose_estimation
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/srv/EstimateObjectPose.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/pose_estimation
)

### Generating Module File
_generate_module_lisp(pose_estimation
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/pose_estimation
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(pose_estimation_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(pose_estimation_generate_messages pose_estimation_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg" NAME_WE)
add_dependencies(pose_estimation_generate_messages_lisp _pose_estimation_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/srv/EstimateObjectPose.srv" NAME_WE)
add_dependencies(pose_estimation_generate_messages_lisp _pose_estimation_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(pose_estimation_genlisp)
add_dependencies(pose_estimation_genlisp pose_estimation_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS pose_estimation_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(pose_estimation
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/pose_estimation
)

### Generating Services
_generate_srv_py(pose_estimation
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/srv/EstimateObjectPose.srv"
  "${MSG_I_FLAGS}"
  "/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Point.msg;/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg;/opt/ros/indigo/share/geometry_msgs/cmake/../msg/Pose.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/pose_estimation
)

### Generating Module File
_generate_module_py(pose_estimation
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/pose_estimation
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(pose_estimation_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(pose_estimation_generate_messages pose_estimation_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/msg/ObjectPose.msg" NAME_WE)
add_dependencies(pose_estimation_generate_messages_py _pose_estimation_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/pose_estimation/srv/EstimateObjectPose.srv" NAME_WE)
add_dependencies(pose_estimation_generate_messages_py _pose_estimation_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(pose_estimation_genpy)
add_dependencies(pose_estimation_genpy pose_estimation_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS pose_estimation_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/pose_estimation)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/pose_estimation
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(pose_estimation_generate_messages_cpp std_msgs_generate_messages_cpp)
add_dependencies(pose_estimation_generate_messages_cpp geometry_msgs_generate_messages_cpp)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/pose_estimation)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/pose_estimation
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(pose_estimation_generate_messages_lisp std_msgs_generate_messages_lisp)
add_dependencies(pose_estimation_generate_messages_lisp geometry_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/pose_estimation)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/pose_estimation\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/pose_estimation
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(pose_estimation_generate_messages_py std_msgs_generate_messages_py)
add_dependencies(pose_estimation_generate_messages_py geometry_msgs_generate_messages_py)
