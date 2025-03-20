#!/bin/bash
#
#
# 允许Docker访问X服务器
xhost +local:docker

# 启动ROS 2容器
docker run -it \
  --network=host \
  --privileged \
  --env="DISPLAY=$DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  --volume="$HOME/.Xauthority:/root/.Xauthority:rw" \
  --volume="$HOME/ros2_projects:/root/ros2_ws" \
  my_ros2_custom_image bash
