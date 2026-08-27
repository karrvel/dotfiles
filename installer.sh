#!/usr/bin/env bash
#
# Installs this rice: packages, oh-my-zsh, then symlinks every config into place.
#
# To fetch just this file:
#   curl -O https://raw.githubusercontent.com/karrvel/dotfiles/main/installer.sh
#   chmod +x installer.sh && ./installer.sh

set -u

DOTFILES="${DOTFILES:-$HOME/dotfiles}"
CONFIG="$HOME/.config"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

PACKAGES="wget git i3 i3blocks i3status feh flameshot kitty rofi vim neovim picom zsh cava conky"


# Identify package manager
echo "> Identifying package manager..."

declare -A osInfo
osInfo[/etc/redhat-release]="yum install"
osInfo[/etc/arch-release]="pacman -S"
osInfo[/etc/debian_version]="apt-get install"

for f in "${!osInfo[@]}"; do
  if [[ -f $f ]]; then
    echo "> Package manager found: ${osInfo[$f]}"
    echo "> Installing required packages..."
    sudo ${osInfo[$f]} $PACKAGES
  fi
done


# Install oh-my-zsh and its plugins
echo "> Installing Oh-My-Zsh and plugins..."

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
git clone https://github.com/zsh-users/zsh-autosuggestions "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting"


# Get the dotfiles
if [[ ! -d $DOTFILES ]]; then
  echo "> Cloning dotfiles into $DOTFILES..."
  git clone https://github.com/karrvel/dotfiles "$DOTFILES"
fi


# Link everything, backing up whatever is already there
echo "> Linking config files..."
mkdir -p "$CONFIG" "$HOME/.local/share" "$BACKUP"

link () {  # link <path-in-repo> <destination>
  local src="$DOTFILES/$1" dest="$2"

  if [[ -e $dest || -L $dest ]]; then
    mv "$dest" "$BACKUP/" 2>/dev/null && echo "  backed up $dest"
  fi

  echo "  $dest -> $src"
  ln -sfn "$src" "$dest"
}

link i3       "$CONFIG/i3"
link i3blocks "$CONFIG/i3blocks"
link i3status "$CONFIG/i3status"
link kitty    "$CONFIG/kitty"
link picom    "$CONFIG/picom"
link cava     "$CONFIG/cava"
link vim      "$CONFIG/vim"
link nvim     "$CONFIG/nvim"

link assets/wallpapers "$CONFIG/wallpapers"
link assets/fonts      "$HOME/.local/share/fonts"

link zsh/.zshrc  "$HOME/.zshrc"
link vim/.vimrc  "$HOME/.vimrc"


# Refresh the font cache
echo "> Updating fonts..."
"$DOTFILES/assets/fonts/font-updater"


# .zshrc sources this unconditionally; create it so a new shell does not error
touch "$HOME/.zshctf"

echo
echo "> Backups of any replaced files are in $BACKUP"
echo "> To change the wallpaper, edit i3/config (the feh line near the top)"
echo "> Install finished! Happy ricing)"
