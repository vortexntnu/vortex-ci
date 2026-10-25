# How to run container based development

### Why?

- Enshure that the thing work on any computer.
- Works on any machine (graphics for stonefish might not work)

### Dependencies

**Docker** : https://www.docker.com/ 

****

### How

**Build the image**: `docker build -t vortex:latest . `

**Run the compose file**: `compose run --rm ros2`

> !Note
> This wil sync the files with the container. So changes will be updated