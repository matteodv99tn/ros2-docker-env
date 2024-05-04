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
    # --user $(id -u):$(id -g) \
    # --volume="/etc/group:/etc/group:ro" \
    # --volume="/etc/shadow:/etc/shadow:ro" \
