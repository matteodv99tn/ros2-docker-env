FROM osrf/ros:humble-desktop-full

RUN useradd -ms /bin/bash user

RUN apt-get update \
    && apt-get install -y \
        coreutils curl tmux git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sS https://starship.rs/install.sh | sh -s -- -y
RUN git clone https://github.com/catppuccin/tmux.git /home/user/.config/tmux/plugins/catppuccin

COPY .bashrc /home/user/.bashrc
COPY tmux.conf /home/user/.config/tmux/tmux.conf

WORKDIR /home/user/ros2_ws
RUN chown -R user:user /home/user

RUN apt-get update \
    && apt-get install -y \
        ros-humble-controller-manager \
        ros-humble-ign-ros2* \
    && rm -rf /var/lib/apt/lists/*

# ENTRYPOINT [/usr/bin/tmux]
