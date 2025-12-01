FROM osrf/ros:humble-desktop-full

RUN useradd -ms /bin/bash user \
    && adduser user sudo \
    && echo 'user:user' | chpasswd \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Base software packages
RUN apt-get update \
    && apt-get install -y \
        psmisc \
        curl \
        wget \
        tmux \
        git \
        unzip \
        bash-completion \
        vim \
        btop \
        figlet \
        iputils-ping \
        libxcb-cursor0 \
        clang \
        libc++-dev \
        libc++abi-dev \
        clang-tidy \
        clang-format \
        cmake \
        cmake-curses-gui \
        python3.10-venv \
        python3-yapf \
        python3-pip \
        python-is-python3\
        yapf3 \
        ripgrep \ 
        dbus-x11 \
        xorg-dev \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s /usr/bin/yapf3 /usr/bin/yapf 
# Prepare user environment: starship, tmux
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y -y

USER user

# Setup nvm / node
SHELL ["/bin/bash", "--login", "-c"]
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash 
RUN cd ~ && . ~/.nvm/nvm.sh && nvm install 22

RUN git clone https://github.com/catppuccin/tmux.git /home/user/.config/tmux/plugins/catppuccin

RUN mkdir -p ~/.local && cd ~/.local \
    && curl -LO https://github.com/neovim/neovim/releases/download/v0.11.5/nvim-linux-x86_64.tar.gz \
    && rm -rf ~/.local/nvim \
    && tar -C ~/.local -xzf nvim-linux-x86_64.tar.gz

RUN git clone https://github.com/matteodv99tn/nvim /home/user/.config/nvim \
    && git clone --depth 1 https://github.com/wbthomason/packer.nvim /home/user/.local/share/nvim/site/pack/packer/start/packer.nvim

RUN ~/.local/nvim-linux-x86_64/bin/nvim \
    --noplugin -u NONE \
    -c "set nomore" \
    -c "edit /home/user/.config/nvim/lua/matteodv99/packer.lua" \
    -c 'so' -c 'PackerSync' \
    -c 'sleep 25' -c 'qa'
RUN ~/.local/nvim-linux-x86_64/bin/nvim \
    -c "edit /home/user/.config/nvim/lua/matteodv99/packer.lua" \
    -c 'so' -c 'PackerSync' \
    -c 'sleep 25' -c 'TSUpdate' \
    -c 'sleep 20' -c 'qa'
# RUN /opt/nvim-linux64/bin/nvim \
#     -c 'MasonInstall jedi_language_server' -c 'sleep 60' -c 'qa'


COPY tmux.conf /home/user/.config/tmux/tmux.conf
COPY clang-format /home/user/.clang-format

# Custom .bashrc setup
RUN echo "export TERM=xterm-256color" >> ~/.bashrc \
    && echo "export PATH=\$PATH:~/.local/nvim-linux-x86_64/bin" >> ~/.bashrc \ 
    && echo "export CMAKE_EXPORT_COMPILE_COMMANDS=1" >> ~/.bashrc \ 
    && echo "" >> ~/.bashrc \
    && echo "alias ..='cd ..'" >> ~/.bashrc \ 
    && echo "alias ...='cd ../..'" >> ~/.bashrc \
    && echo "alias ....='cd ../../..'" >> ~/.bashrc \
    && echo "alias .....='cd ../../../..'" >> ~/.bashrc \
    && echo "" >> ~/.bashrc \
    && echo "eval '$(starship init bash)'" >> ~/.bashrc \
    && echo "" >> ~/.bashrc \
    && echo "ulimit -n 1024" >> ~/.bashrc \
    && echo "" >> ~/.bashrc \
    && echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc \
    && echo "if test -f $HOME/ros2_ws/install/setup.bash; then" >> ~/.bashrc \
    && echo "    source $HOME/ros2_ws/install/setup.bash" >> ~/.bashrc \
    && echo "fi" >> ~/.bashrc \
    && echo "if test -f $HOME/ros_ws/install/setup.bash; then" >> ~/.bashrc \
    && echo "    source $HOME/ros_ws/install/setup.bash" >> ~/.bashrc \
    && echo "fi" >> ~/.bashrc \
    && echo "" >> ~/.bashrc \
    && echo "alias cb='cd ~/ros_ws && colcon build --symlink-install'" >> ~/.bashrc \
    && echo "alias clr='rm -rf ~/ros_ws/build ~/ros_ws/install ~/ros_ws/log'" >> ~/.bashrc \ 
    && echo "" >> ~/.bashrc

RUN mkdir /home/user/ros_ws
WORKDIR /home/user/ros_ws

# ENTRYPOINT [/usr/bin/tmux]
