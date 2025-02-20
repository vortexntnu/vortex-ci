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
export CXXFLAGS="-std=c++17"
export CFLAGS="-std=c++17"

# Install Stonefish in /opt or a higher directory
cd ~
git clone https://github.com/patrykcieslak/stonefish.git
cd stonefish

# Build Stonefish
mkdir build
cd build
cmake ..
make -j"$(nproc)"
sudo make install

# Return to ROS workspace
cd ~/ros2_ws/src

echo "Stonefish installation complete."
echo "Finished installing extra dependencies."
