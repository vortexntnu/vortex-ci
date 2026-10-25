# Container-based development

Use a ROS 2 Humble development environment without installing its dependencies
on the host. The default service supports terminal-only development without a
GPU or desktop session. An optional override enables NVIDIA-accelerated X11
applications on Linux; other graphical setups are not covered here.

## Requirements

- Docker Engine with the Docker Compose plugin.
- Your ROS workspace sources in `${HOME}/ros2_ws/src/`. This directory is
  mounted read-write at `/ros2_ws/src/`; source edits affect the host files.
- For the simulator example, the workspace must already contain `stonefish_sim`
  and its source dependencies. The image installs the Stonefish library, not
  the simulator's ROS workspace.

Run all host commands below from the root of this repository.

## Build the image

```bash
docker build -t vortex:latest -f docker/Dockerfile .
```

The Compose service uses this same `vortex:latest` image. Rebuild it after
changing the Dockerfile; Compose does not build it automatically.

## Terminal-only development

```bash
docker compose -f docker/compose.yaml run --rm ros2
```

This starts Bash in `/ros2_ws`. No NVIDIA runtime, `DISPLAY`, or `XAUTHORITY` is
required. The image's entrypoint sources ROS 2 Humble automatically. If needed
in another shell, run `source /opt/ros/humble/setup.bash`.

The container currently runs as root. Files it creates in the source bind mount
can therefore be root-owned on a Linux host. Build and install output stays in
the container and is removed when the `--rm` container exits.

## Optional NVIDIA/X11 graphics

In addition to Docker, install the NVIDIA driver and
[NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
and configure the toolkit for Docker. This mode requires a working X11 or
XWayland desktop session on the host.

From a terminal in that desktop session, check that `DISPLAY` is set and set
`XAUTHORITY` to the existing authorization file for that session. It may already
be exported by your desktop. If it is not, find the session's actual file rather
than assuming it is always `~/.Xauthority`.

```bash
printf 'DISPLAY=%s\nXAUTHORITY=%s\n' "$DISPLAY" "$XAUTHORITY"
test -n "$DISPLAY" && test -f "$XAUTHORITY"
```

Only continue if the check succeeds. Both variables must be exported so Compose
can read them. The override mounts the X11 socket and authorization file
read-only; it does not disable X server access control.

```bash
docker compose -f docker/compose.yaml -f docker/compose.nvidia.yaml run --rm ros2
```

### Run the simulator inside the graphical container

```bash
colcon build --symlink-install --packages-up-to stonefish_sim
source install/setup.bash
ros2 launch stonefish_sim simulation.launch.py scenario:=tacc
```

## Validate the Compose configuration

These regression checks require Python 3 and Docker Compose, but do not build
images, start containers, or require an NVIDIA GPU or desktop session:

```bash
python3 -m unittest discover -s docker -p 'test_*.py' -v
```
