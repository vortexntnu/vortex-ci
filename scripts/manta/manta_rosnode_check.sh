#!/bin/bash

RED='\033[0;31m'
GREEN='\033[32m'
NC='\033[0m' # No Color

source /opt/ros/melodic/setup.bash
source ~/manta_ws/manta_connect.sh

nodes=(
    "/battery_monitor"
    "/controllers/dp_controller"
    "/ekf_se"
    "/front_cam_servo_interface"
    "/imu_driver"
    "/joystick_interface"
    "/lights_interface"
    "/odom_ned_frame_publisher"
    "/pca9685_ros_driver"
    "/thrust/thruster_allocator"
    "/thruster_interface"
    "/usb_cam"
    )

echo "***********ROSNODE STATUS***********"

while read i; do
    if [[ " ${nodes[*]} " == *"$i"* ]]; then
        echo -e "${GREEN}OK: $i ${NC}"
        nodes=( "${nodes[@]/$i}" )
    fi
done < <(rosnode list)

nodes_not_running=()
for i in "${nodes[@]}"
do
   if [ -z "$i" ]; then
     continue
   fi
    nodes_not_running+=("${i}")
done

echo ""

for i in "${nodes_not_running[@]}"
do
   echo -e "${RED}NOT OK: $i ${NC}"
done
