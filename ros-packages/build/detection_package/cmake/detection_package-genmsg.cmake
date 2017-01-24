# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "detection_package: 0 messages, 2 services")

set(MSG_I_FLAGS "-Istd_msgs:/opt/ros/indigo/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genlisp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(detection_package_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateActiveListFrame.srv" NAME_WE)
add_custom_target(_detection_package_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "detection_package" "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateActiveListFrame.srv" ""
)

get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateBbox.srv" NAME_WE)
add_custom_target(_detection_package_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "detection_package" "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateBbox.srv" ""
)

#
#  langs = gencpp;genlisp;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(detection_package
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateActiveListFrame.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/detection_package
)
_generate_srv_cpp(detection_package
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateBbox.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/detection_package
)

### Generating Module File
_generate_module_cpp(detection_package
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/detection_package
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(detection_package_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(detection_package_generate_messages detection_package_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateActiveListFrame.srv" NAME_WE)
add_dependencies(detection_package_generate_messages_cpp _detection_package_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateBbox.srv" NAME_WE)
add_dependencies(detection_package_generate_messages_cpp _detection_package_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(detection_package_gencpp)
add_dependencies(detection_package_gencpp detection_package_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS detection_package_generate_messages_cpp)

### Section generating for lang: genlisp
### Generating Messages

### Generating Services
_generate_srv_lisp(detection_package
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateActiveListFrame.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/detection_package
)
_generate_srv_lisp(detection_package
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateBbox.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/detection_package
)

### Generating Module File
_generate_module_lisp(detection_package
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/detection_package
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(detection_package_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(detection_package_generate_messages detection_package_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateActiveListFrame.srv" NAME_WE)
add_dependencies(detection_package_generate_messages_lisp _detection_package_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateBbox.srv" NAME_WE)
add_dependencies(detection_package_generate_messages_lisp _detection_package_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(detection_package_genlisp)
add_dependencies(detection_package_genlisp detection_package_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS detection_package_generate_messages_lisp)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(detection_package
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateActiveListFrame.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/detection_package
)
_generate_srv_py(detection_package
  "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateBbox.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/detection_package
)

### Generating Module File
_generate_module_py(detection_package
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/detection_package
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(detection_package_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(detection_package_generate_messages detection_package_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateActiveListFrame.srv" NAME_WE)
add_dependencies(detection_package_generate_messages_py _detection_package_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/srv/UpdateBbox.srv" NAME_WE)
add_dependencies(detection_package_generate_messages_py _detection_package_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(detection_package_genpy)
add_dependencies(detection_package_genpy detection_package_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS detection_package_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/detection_package)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/detection_package
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
add_dependencies(detection_package_generate_messages_cpp std_msgs_generate_messages_cpp)

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/detection_package)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/detection_package
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
add_dependencies(detection_package_generate_messages_lisp std_msgs_generate_messages_lisp)

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/detection_package)
  install(CODE "execute_process(COMMAND \"/usr/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/detection_package\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/detection_package
    DESTINATION ${genpy_INSTALL_DIR}
    # skip all init files
    PATTERN "__init__.py" EXCLUDE
    PATTERN "__init__.pyc" EXCLUDE
  )
  # install init files which are not in the root folder of the generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/detection_package
    DESTINATION ${genpy_INSTALL_DIR}
    FILES_MATCHING
    REGEX "${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/detection_package/.+/__init__.pyc?$"
  )
endif()
add_dependencies(detection_package_generate_messages_py std_msgs_generate_messages_py)
