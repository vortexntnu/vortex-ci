#!/bin/bash
# requirements.sh
# This script installs additional dependencies that are not managed by rosdep.
# It can install both Python libraries (using pip) and C++ libraries (using apt-get).

# Exit immediately if any command fails to prevent the script from continuing after an error.
set -e

echo "Starting manual installation of extra dependencies..."

# ----------------------------- PYTHON DEPENDENCIES -----------------------------
# Upgrade pip to ensure compatibility with the latest packages
pip3 install --upgrade pip
pip3 install --upgrade 'numpy<1.25' 'scipy<1.12'

# ----------------------------- C++ DEPENDENCIES -----------------------------
# Update and install dependencies needed by Stonefish, as well as typical build tools
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  cmake \
  git \
  libglm-dev \
  libsdl2-dev \
  libfreetype6-dev

# ----------------------------- STONEFISH INSTALLATION -----------------------------
echo "Cloning and building Stonefish..."
export CXXFLAGS="-std=c++14"
export CFLAGS="-std=c++14"

# Install Stonefish in /opt or a higher directory
mkdir -p ~/opt
cd ~/opt
git clone https://github.com/patrykcieslak/stonefish.git
cd stonefish

# Build Stonefish
mkdir build
cd build
cmake ..
make -j"$(nproc)"
sudo make install

cd ~/ros2_ws
. /opt/ros/humble/setup.sh  # Source ROS 2

# First, build Stonefish
colcon build --packages-select stonefish_ros2 --symlink-install

# Source and build the rest
. install/setup.bash
colcon build --packages-ignore stonefish_ros2 --symlink-install

echo "Stonefish installation complete."
echo "Finished installing extra dependencies."
