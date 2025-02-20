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

# Install Python packages with specified versions that are not handled by rosdep.
pip3 install control==0.10.1
pip3 install "numpy<1.25.0"

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

# According to Stonefish README, we need to fix sdl2-config.cmake by removing the extra space
# after '-lSDL2'.
# Adjust the path if your sdl2-config.cmake is located elsewhere on your system.
sudo sed -i 's/-lSDL2 /-lSDL2/g' /usr/lib/x86_64-linux-gnu/cmake/SDL2/sdl2-config.cmake || true

# ----------------------------- STONEFISH INSTALLATION -----------------------------
echo "Cloning and building Stonefish..."

# Clone Stonefish repository
git clone https://github.com/patrykcieslak/stonefish.git
cd stonefish

# Create build directory
mkdir build
cd build

# Run CMake
cmake ..

# Build with all available CPU cores
make -j"$(nproc)"

# Install
sudo make install

echo "Stonefish installation complete."
echo "Finished installing extra dependencies."
