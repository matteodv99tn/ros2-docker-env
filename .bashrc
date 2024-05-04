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

alias cb='colcon build --symlink-install'
