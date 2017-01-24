#!/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
    DESTDIR_ARG="--root=$DESTDIR"
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package"

# snsure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/python2.7/dist-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/lib/python2.7/dist-packages:/home/pracsys/github/PHYSIM_6DPose/ros-packages/build/lib/python2.7/dist-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/pracsys/github/PHYSIM_6DPose/ros-packages/build" \
    "/usr/bin/python" \
    "/home/pracsys/github/PHYSIM_6DPose/ros-packages/src/detection_package/setup.py" \
    build --build-base "/home/pracsys/github/PHYSIM_6DPose/ros-packages/build/detection_package" \
    install \
    $DESTDIR_ARG \
    --install-layout=deb --prefix="/home/pracsys/github/PHYSIM_6DPose/ros-packages/install" --install-scripts="/home/pracsys/github/PHYSIM_6DPose/ros-packages/install/bin"
