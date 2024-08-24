FROM osrf/ros:humble-desktop-full

RUN useradd -ms /bin/bash user
RUN chown -R user:user /home/user

# Install base packages
RUN apt-get update \
    && apt-get install -y \
        coreutils curl wget tmux git unzip \
        python3-pip python-is-python3 \
    && rm -rf /var/lib/apt/lists/*

# Add robotpkg software repository
RUN echo "deb [arch=amd64] http://robotpkg.openrobots.org/packages/debian/pub jammy robotpkg" | tee /etc/apt/sources.list.d/robotpkg.list \
    && curl http://robotpkg.openrobots.org/packages/debian/robotpkg.key | apt-key add -

RUN apt-get update \
    && apt-get install -y \
        ros-humble-controller-manager \
        ros-humble-ign-ros2* \
        robotpkg-py310-tsid \
        npm btop \
        libc++-dev \
        python3.10-venv python3-yapf clang-tidy clang-format \
        ripgrep yapf3 clang-format figlet \
        libpoco-dev libyaml-cpp-dev liburdfdom-tools \
        ros-humble-control-msgs ros-humble-realtime-tools ros-humble-xacro \
        ros-humble-joint-state-publisher-gui ros-humble-ros2-control \
        ros-humble-ros2-controllers ros-humble-gazebo-msgs ros-humble-moveit-msgs \
        ros-humble-actuator-msgs ros-humble-ros-gz-interfaces ros-humble-vision-msgs\
        ros-humble-gazebo-ros2-control ros-humble-rqt-controller-manager \
        ros-humble-ros-ign-gazebo ros-humble-hardware-interface-testing \
        dbus-x11\
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/yapf3 /usr/bin/yapf 


WORKDIR /
# RUN curl -L https://github.com/isl-org/Open3D/archive/refs/tags/v0.18.0.zip -o Open3D.zip \
#     && mkdir -p /Open3D_src \
#     && unzip Open3D.zip -d /Open3D_src\
#     && rm Open3D.zip \
#     && cd Open3D_src/Open3D-0.18.0 \
#     && ./util/install_deps_ubuntu.sh assume-yes \
#     && mkdir build \
#     && cd build \
#     && cmake .. \
#     && make -j16 install-pip-package
    

RUN echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list \
    && wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add - \
    && apt-get update \
    && apt-get install -y \
        libignition-gazebo6-dev ros-humble-gazebo-ros-pkgs ros-humble-moveit-msgs \
        ros-humble-ros-gz-sim ros-humble-ament-cmake-clang* ros-humble-pinocchio \
    && rm -rf /var/lib/apt/lists/* 

# Prepare user environment: starship, tmux
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y -y
RUN git clone https://github.com/catppuccin/tmux.git /home/user/.config/tmux/plugins/catppuccin

RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && rm -rf /opt/nvim \
    && tar -C /opt -xzf nvim-linux64.tar.gz

RUN git clone https://github.com/matteodv99tn/nvim /home/user/.config/nvim \
    && git clone --depth 1 https://github.com/wbthomason/packer.nvim /home/user/.local/share/nvim/site/pack/packer/start/packer.nvim
RUN chown -R user:user /home/user

RUN apt-get update \
    && apt-get install -y \
    xorg-dev libxcb-shm0 libglu1-mesa-dev python3-dev clang libc++-dev libc++abi-dev \
    libsdl2-dev ninja-build libxi-dev libtbb-dev libosmesa6-dev libudev-dev \
    autoconf libtool \
    && rm -rf /var/lib/apt/lists/* 

USER user

RUN /opt/nvim-linux64/bin/nvim \
    --noplugin -u NONE \
    -c "set nomore" \
    -c "edit /home/user/.config/nvim/lua/matteodv99/packer.lua" \
    -c 'so' -c 'PackerSync' \
    -c 'sleep 25' -c 'qa'
RUN /opt/nvim-linux64/bin/nvim \
    -c "edit /home/user/.config/nvim/lua/matteodv99/packer.lua" \
    -c 'so' -c 'PackerSync' \
    -c 'sleep 25' -c 'TSUpdate' \
    -c 'sleep 20' -c 'qa'
# RUN /opt/nvim-linux64/bin/nvim \
#     -c 'MasonInstall jedi_language_server' -c 'sleep 60' -c 'qa'
USER root

RUN apt-get update \
    && apt-get install -y \
       ros-dev-tools ros-humble-moveit-configs-utils \
    && rm -rf /var/lib/apt/lists/* 

USER user

COPY .bashrc /home/user/.bashrc
COPY tmux.conf /home/user/.config/tmux/tmux.conf
COPY clang-format /home/user/.clang-format

RUN mkdir /home/user/ros2_ws
WORKDIR /home/user/ros2_ws

# ENTRYPOINT [/usr/bin/tmux]
