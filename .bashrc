#!/bin/bash

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
export TERM=xterm-256color

# For robotpkg
export PATH=/opt/openrobots/bin:$PATH
export PKG_CONFIG_PATH=/opt/openrobots/lib/pkgconfig:$PKG_CONFIG_PATH
export LD_LIBRARY_PATH=/opt/openrobots/lib:$LD_LIBRARY_PATH
export PYTHONPATH=/opt/openrobots/lib/python3.10/site-packages:$PYTHONPATH # Adapt your desired python version here
export CMAKE_PREFIX_PATH=/opt/openrobots:$CMAKE_PREFIX_PATH

# NVIM
export PATH="$PATH:/opt/nvim-linux64/bin"

export CMAKE_EXPORT_COMPILE_COMMANDS=1

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

eval "$(starship init bash)"

# Command fixing issues in running ROS2 docker container on arch linux
# https://github.com/ros2/ros2/issues/1531
ulimit -n 1024

# For issues in downloading packages
# https://askubuntu.com/questions/1272386/dpkg-unrecoverable-fatal-error-aborting-unknown-system-group

source /opt/ros/humble/setup.bash
if test -f $HOME/ros2_ws/install/setup.bash; then
    source $HOME/ros2_ws/install/setup.bash
fi

alias cb='cd /home/user/ros2_ws && colcon build --symlink-install'
alias clr='rm -rf /home/user/ros2_ws/build /home/user/ros2_ws/install /home/user/ros2_ws/log'
