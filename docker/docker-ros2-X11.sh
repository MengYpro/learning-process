#!/bin/bash

xhost +local:docker

docker run -it \
	--name ros2_humble \
	--network host \
	-e DISPLAY=$DISPLAY \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v $(pwd)/ros_ws:/home/ros_ws \
	-v $HOME/.Xauthority:/root/.Xauthority \
	osrf/ros:humble-desktop \
	bash -c "source /opt/ros/humble/setup.bash && bash"

xhost -local:docker

