# Docker ROS2 development environment

Set of utilities and scripts to create a ROS2 humble development environment using Docker.

Here there is a `Dockerfile` that crates the development image;
the image comprises my `bash` and `tmux` configurations.

The [`build_container.sh`](./build_container.sh) script provides the command to easily build the image.
The [`run_container.sh`](./run_container.sh) script can be used to test the correct functionality of the docker image while modifying it.

The reccomended way to use the image is by using the following alias:
```bash
alias ros2_devenv='docker run \
    --name ros2-venv \
    --rm -it \
    -e DISPLAY=$DISPLAY \
    --user user \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /dev:/dev/:rw \
    -v $(exec pwd):/home/user/ros2_ws/ \
    --device-cgroup-rule="c *:* rmw" \
    --net=host \
    --ipc=host \
    --hostname=docker  \
    --shm-size 2g \
    ros2-venv'
```
This will run the container and places the current working directory inside `~/ros2_ws/` of the container.
The default user for the container is `user`.
