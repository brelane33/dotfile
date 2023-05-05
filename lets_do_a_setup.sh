#!/bin/bash

# We should grab rustup.
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y > /dev/null 2>&1

# We should also grab nodesource and run it.
curl -sL https://deb.nodesource.com/setup_18.x -o ~/nodesource_setup.sh > /dev/null 2>&1
chmod +x ~/nodesource_setup.sh
sudo bash ~/nodesource_setup.sh > /dev/null 2>&1

# Update our metadata.
sudo apt update > /dev/null 2>&1
# We need libfuse to run the appimage
sudo apt install -y libfuse2 > /dev/null 2>&1
# We need unzip to resolve :checkhealth issues
sudo apt install -y unzip > /dev/null 2>&1
# the one and only
sudo apt install -y build-essential > /dev/null 2>&1
# I hate javascript
sudo apt install -y nodejs > /dev/null 2>&1

# Clean up the script file
rm ~/nodesource_setup.sh > /dev/null 2>&1 | echo "y" > /dev/null

# Ensure local bin folder is created in home directory
mkdir -p ~/.local/bin/

# Let's get the stable release of NeoVim
if [[ ! -f ~/.local/bin/nvim.appimage ]];
then
     wget https://github.com/neovim/neovim/releases/download/stable/nvim.appimage -P ~/.local/bin/ > /dev/null 2>&1
else
     echo "NeoVim has already been downloaded"
fi

# Now we should make it executable
chmod +x ~/.local/bin/nvim.appimage

# Let's add NeoVim to our bash alias and overwrite vim.
ret=$(/usr/bin/cat ~/.bashrc | grep nvim.appimage)
if [[ "$ret" ]];
then
     echo "The NeoVim alias already exists"
else
     echo "alias vim='~/.local/bin/nvim.appimage'" >> ~/.bashrc
fi

# Make some backups and grab AstroNvim. It's nice.
# But if it already exists, let's not overwrite it...
if [[ ! -d ~/.config/nvim/ ]];
then
     git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim > /dev/null 2>&1
else
     echo "AstroNvim config already exists"
fi


# Make sure all of our fancy new stuff is in $ENV
eval "$(cat ~/.bashrc | tail -n +10)"

# Verify we installed a version that won't explode
echo "=============="
echo "Node verion. Should be greater than 18."
echo "=============="
node -v
echo ""
echo "=============="
echo "Rust version"
echo "=============="
cargo -V
echo ""

# Create a new rust folder to house projects, and a test project.
if [ ! -f ~/rust/test_proj/Cargo.toml ];
then
     mkdir -p ~/rust/
     cargo new ~/rust/test_proj
else
     echo "The rust directory already exists"
fi

