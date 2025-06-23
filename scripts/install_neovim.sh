#!/bin/bash -e

sudo apt-get update
sudo apt-get install -y tmux tar git

mkdir -p ~/.local 
cd ~/.local 
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-linux-x86_64.tar.gz 
rm -rf ~/.local/nvim 
tar -C ~/.local -xzf nvim-linux-x86_64.tar.gz

git clone --depth 1 https://github.com/wbthomason/packer.nvim /home/user/.local/share/nvim/site/pack/packer/start/packer.nvim

~/.local/nvim-linux-x86_64/bin/nvim \
    --noplugin -u NONE \
    -c "set nomore" \
    -c "edit /home/user/.config/nvim/lua/matteodv99/packer.lua" \
    -c 'so' -c 'PackerSync' \
    -c 'sleep 25' -c 'qa'
~/.local/nvim-linux-x86_64/bin/nvim \
    -c "edit /home/user/.config/nvim/lua/matteodv99/packer.lua" \
    -c 'so' -c 'PackerSync' \
    -c 'sleep 25' -c 'TSUpdate' \
    -c 'sleep 20' -c 'qa'
echo "export PATH=$PATH:~/.local/nvim-linux-x86_64/bin" >> ~/.bashrc
