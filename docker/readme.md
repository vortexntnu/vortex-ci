# How to run container based development

### Why?

- Enshure that the thing work on any computer.
- Works on any machine (graphics for stonefish might not work)

### Dependencies

**Docker** : https://www.docker.com/

**Nvidia container toolkit (for gpu accelerated containers )** : https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html

### Usage

**Build the image**: `docker build -t vortex:latest . `

**Run the compose file**: `compose run --rm ros2`

> !Note
> This wil sync the files with the container. So changes will be updated

**source setup file** : `source /opt/ros/humble/setup.bash`

#### Example for running the sim

**Build** `colcon build --symlink-install --packages-up-to stonefish_sim`

**Source** `source install/setup.bash`

**Graphical** `ros2 launch stonefish_sim simulation.launch.py scenario:=tacc`
