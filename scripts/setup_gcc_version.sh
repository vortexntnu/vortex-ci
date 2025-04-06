#!/usr/bin/env bash

set -euo pipefail

# Script: setup_gcc_version.sh
# Description: Installs specified GCC/G++/GCOV version and sets it as default
# Usage: ./setup_gcc_version.sh <gcc_version>
# Example: ./setup_gcc_version.sh 13

GCC_VERSION=${1:-}

if [[ -z "$GCC_VERSION" ]]; then
  echo "Error: No GCC version provided."
  echo "Usage: $0 <gcc_version>"
  exit 1
fi

echo "Installing and configuring GCC version: $GCC_VERSION"

# Add Ubuntu Toolchain PPA
sudo apt-get update -qq
sudo apt-get install -y --no-install-recommends software-properties-common
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update -qq

# Install the specified GCC/G++/GCOV version
sudo apt-get install -y --no-install-recommends gcc-${GCC_VERSION} g++-${GCC_VERSION} lcov

# Configure alternatives to use the specified version
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${GCC_VERSION} 100
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-${GCC_VERSION} 100
sudo update-alternatives --install /usr/bin/gcov gcov /usr/bin/gcov-${GCC_VERSION} 100

# Display installed versions
echo "GCC version set to: $(gcc --version | head -n1)"
echo "G++ version set to: $(g++ --version | head -n1)"
echo "GCOV version set to: $(gcov --version | head -n1)"
