#!/bin/bash

# rpi
export ROS_MASTER_URI="http://10.0.0.100:11311"
# own device
export ROS_IP=10.0.0.35
export ROS_HOSTNAME=10.0.0.35

source ~/manta_ws/manta_connect.sh
~/manta_ws/manta_rosnode_check.sh

source ~/manta_ws/devel/setup.bash
roslaunch auv_setup pc.launch
