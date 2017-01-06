# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "marvin_convnet: 0 messages, 1 services")

set(MSG_I_FLAGS "-Imarvin_convnet:/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/msg;-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg;-Igeometry_msgs:/opt/ros/indigo/share/geometry_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(marvin_convnet_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/srv/DetectObjects.srv" NAME_WE)
add_custom_target(_marvin_convnet_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "marvin_convnet" "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/srv/DetectObjects.srv" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(marvin_convnet
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/srv/DetectObjects.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/marvin_convnet
)

### Generating Module File
_generate_module_cpp(marvin_convnet
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/marvin_convnet
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(marvin_convnet_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(marvin_convnet_generate_messages marvin_convnet_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/srv/DetectObjects.srv" NAME_WE)
add_dependencies(marvin_convnet_generate_messages_cpp _marvin_convnet_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(marvin_convnet_gencpp)
add_dependencies(marvin_convnet_gencpp marvin_convnet_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS marvin_convnet_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(marvin_convnet
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/srv/DetectObjects.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/marvin_convnet
)

### Generating Module File
_generate_module_lisp(marvin_convnet
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/marvin_convnet
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(marvin_convnet_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(marvin_convnet_generate_messages marvin_convnet_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/srv/DetectObjects.srv" NAME_WE)
add_dependencies(marvin_convnet_generate_messages_lisp _marvin_convnet_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(marvin_convnet_genlisp)
add_dependencies(marvin_convnet_genlisp marvin_convnet_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS marvin_convnet_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(marvin_convnet
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/srv/DetectObjects.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/marvin_convnet
)

### Generating Module File
_generate_module_py(marvin_convnet
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/marvin_convnet
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(marvin_convnet_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(marvin_convnet_generate_messages marvin_convnet_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/marvin_convnet/srv/DetectObjects.srv" NAME_WE)
add_dependencies(marvin_convnet_generate_messages_py _marvin_convnet_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(marvin_convnet_genpy)
add_dependencies(marvin_convnet_genpy marvin_convnet_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS marvin_convnet_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/marvin_convnet)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/marvin_convnet
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(marvin_convnet_generate_messages_cpp std_msgs_generate_messages_cpp)
add_dependencies(marvin_convnet_generate_messages_cpp geometry_msgs_generate_messages_cpp)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/marvin_convnet)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/marvin_convnet
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(marvin_convnet_generate_messages_lisp std_msgs_generate_messages_lisp)
add_dependencies(marvin_convnet_generate_messages_lisp geometry_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/marvin_convnet)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/marvin_convnet\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/marvin_convnet
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
add_dependencies(marvin_convnet_generate_messages_py std_msgs_generate_messages_py)
add_dependencies(marvin_convnet_generate_messages_py geometry_msgs_generate_messages_py)
