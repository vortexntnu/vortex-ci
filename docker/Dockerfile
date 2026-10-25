FROM ros:humble-ros-base

# Adding stuff for gcc-13 first
RUN apt-get update && apt-get install -y --no-install-recommends \
    software-properties-common \
    ca-certificates \
    gnupg \
    && add-apt-repository -y ppa:ubuntu-toolchain-r/test \
    && rm -rf /var/lib/apt/lists/*

# deps
RUN apt-get update && apt-get install -y \
    libzmq3-dev \
    libglm-dev \
    libsdl2-dev \
    libfreetype6-dev \
    python3-colcon-common-extensions \
    python3-vcstool \
    ros-humble-pcl-conversions \
    ros-humble-vision-msgs \
    ros-humble-behaviortree-cpp \
    ros-humble-image-transport \
    ros-humble-cv-bridge \
    python3-rosdep \
    python3-pip \
    gnuplot \
    ros-humble-yasmin \
    ros-humble-yasmin-ros \
    libgnuplot-iostream-dev \
    gcc-13 \
    g++-13 \
    lcov \
    ros-humble-gtsam \
    && rm -rf /var/lib/apt/lists/*

# deps for working with git
RUN apt-get update && apt-get install -y \
    git \
    clang-format \
    ros-humble-ament-cppcheck \
    ros-humble-ament-cpplint \
    && rm -rf /var/lib/apt/lists/*

# setup stonefish
RUN git clone https://github.com/vortexntnu/stonefish.git && sed -i '30i#include <cstdint>' stonefish/Library/include/sensors/Sample.h

WORKDIR stonefish

RUN mkdir -p build

WORKDIR build

RUN cmake .. && make -j4 && make install

ENV LD_LIBRARY_PATH="/opt/ros/humble/lib/x86_64-linux-gnu:/opt/ros/humble/lib:/usr/local/lib:/opt/stonefish"

# export 13
ENV CC=/usr/bin/gcc-13
ENV CXX=/usr/bin/g++-13

CMD ["bash"]
