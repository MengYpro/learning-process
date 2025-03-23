#!/bin/bash


if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
    echo "Warning: not Wayland, this shell is only for Wayland."
    exit 1
fi

 
if [ -z "$XDG_RUNTIME_DIR" ] || [ ! -d "$XDG_RUNTIME_DIR" ]; then
    echo "Error: XDG_RUNTIME_DIR don't exist."
    exit 1
fi


if [ -z "$WAYLAND_DISPLAY" ]; then
    echo "Warning: WAYLAND_DISPLAY undefined, try to use wayland-0"
    export WAYLAND_DISPLAY=wayland-0
fi


if [ ! -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ]; then
    echo "Error: Wayland socket don't exist: $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY"
    exit 1
fi

echo "run ROS2 Humble Container supporting by Wayland Humble..."



docker run -it \
    --name ros2_humble \
    --rm \
    --network host \
    --security-opt=no-new-privileges \
    -e DISPLAY=$DISPLAY \
    -e WAYLAND_DISPLAY=$WAYLAND_DISPLAY \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -v $XDG_RUNTIME_DIR/$WAYLAND_DISPLAY:$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY \
    -v $XDG_RUNTIME_DIR/pulse:$XDG_RUNTIME_DIR/pulse \
    -v $HOME/.config/pulse/cookie:/root/.config/pulse/cookie \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(pwd)/ros_ws:/home/ros_ws \
    osrf/ros:humble-desktop \
    bash -c "source /opt/ros/humble/setup.bash && bash"

echo "ROS 2 Humble Container quit."

