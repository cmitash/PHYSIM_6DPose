# Install script for directory: /home/pracsys/github/PHYSIM_6DPose/ros-packages/src/librealsense

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/pracsys/github/PHYSIM_6DPose/ros-packages/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/pracsys/github/PHYSIM_6DPose/ros-packages/build/librealsense/catkin_generated/installspace/librealsense.pc")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/librealsense/cmake" TYPE FILE FILES
    "/home/pracsys/github/PHYSIM_6DPose/ros-packages/build/librealsense/catkin_generated/installspace/librealsenseConfig.cmake"
    "/home/pracsys/github/PHYSIM_6DPose/ros-packages/build/librealsense/catkin_generated/installspace/librealsenseConfig-version.cmake"
    )
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/librealsense" TYPE FILE FILES "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/librealsense/package.xml")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  if(EXISTS "$ENV{DESTDIR}/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/librealsense.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/librealsense.so")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/librealsense.so"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/librealsense.so")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib" TYPE SHARED_LIBRARY FILES "/home/pracsys/github/PHYSIM_6DPose/ros-packages/devel/lib/librealsense.so")
  if(EXISTS "$ENV{DESTDIR}/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/librealsense.so" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/librealsense.so")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/librealsense.so")
    endif()
  endif()
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/include/librealsense")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/include" TYPE DIRECTORY FILES "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/librealsense/include/librealsense")
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
  include("/home/pracsys/github/PHYSIM_6DPose/ros-packages/build/librealsense/unit-tests/cmake_install.cmake")

endif()

