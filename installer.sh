#!/usr/bin/env bash

# In order to get this file only, use command below:
# curl https://raw.githubusercontent.com/karrvel/dotfiles/main/installer.sh -O installer.sh; chmod +x installer.sh; ./installer.sh

# Identify Package Manager
echo "> Identifying Package Manager..."

declare -A osInfo;
osInfo[/etc/redhat-release]="yum install"
osInfo[/etc/arch-release]="pacman -S"
osInfo[/etc/debian_version]="apt-get install"

for f in ${!osInfo[@]}
do
  if [[ -f $f ]];then
    echo "> Package Manager found: " ${osInfo[$f]}

    # Install required packages
    echo "> Installing required packages..."

    sudo ${osInfo[$f]} wget git i3 i3blocks i3status feh flameshot kitty rofi vim neovim picom zsh
  fi
done


# Install Oh-My-Zsh and plugins for it
echo "> Installing Oh-My-Zsh and plugins for it..."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions $HOME/.oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting


# Get Dotfiles
echo "> Getting Dotfiles... (will be saved at $HOME/dotfiles)"

git clone https://github.com/karrvel/dotfiles $HOME/dotfiles

# Remove default files
rm $HOME/.config/i3
rm $HOME/.zshrc


# Linking Proccess
echo "> Linking Config Files..."
mkdir $HOME/.config

linker ()
{
  echo "Linking $1"
  ln -s $HOME/dotfiles/$1 $HOME/.config/$1
}

linker i3
linker i3blocks
linker i3status

linker kitty
linker picom
linker wallpapers

linker vim
linker nvim

ln -s $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc

mkdir $HOME/.local 2>/dev/null
mkdir $HOME/.local/share 2>/dev/null
ln -s $HOME/dotfiles/fonts $HOME/.local/share/fonts


# Update fonts
echo "> Updating fonts..."

$HOME/dotfiles/fonts/font-updater

# Make zshctf file (See: https://github.com/karrvel/dotfiles/blob/main/zsh/.zshrc#L88)
touch $HOME/.zshctf

echo "> In order to change wallpaper check out i3 config (:Line 20)"
echo "> Installing Finished! Happy ricing)"
