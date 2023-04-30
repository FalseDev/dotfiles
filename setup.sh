#!/usr/bin/env bash

# Variables
# MOLD_VERSION="1.11.0"
HELIX_VERSION="23.03"
FZF_VERSION="0.39.0"
CARGO_PKGS="bat bore-cli bottom \
  cargo-watch cross diskus erdtree \
  exa fd-find fnm gitui git-delta \
  hurl just lsd navi nomino ripgrep \
  sd so typos-cli xh zellij zoxide"


# Install fish
echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_11/ /' | sudo tee /etc/apt/sources.list.d/shells:fish:release:3.list
curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_11/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg >/dev/null
sudo apt-get update -y
sudo apt-get install -y fish
sudo chsh "$(id -un)" --shell "/usr/bin/fish"
fish -c exit


# Install basic tools
sudo apt-get update -y
sudo apt-get install -y wget tar


# Install neovim
wget -O ~/.local/bin/nvim https://github.com/neovim/neovim/releases/download/stable/nvim.appimage

# Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# Update fish path
fish -c 'fish_add_path ~/.cargo/bin/'
# Update bash path for this script
source "$HOME/.bashrc"


# Install mold
# wget -O mold.tar.gz "https://github.com/rui314/mold/releases/download/v$MOLD_VERSION/mold-$MOLD_VERSION-$(arch)-linux.tar.gz"
# tar xf mold.tar.gz
# rm mold.tar.gz
# Invalid
# mv mold ~/.local/bin/

# Install helix
wget -O helix "https://github.com/helix-editor/helix/releases/download/$HELIX_VERSION/helix-$HELIX_VERSION-$(arch).AppImage"
chmod +x helix
mv helix ~/.local/bin/

# Install cargo-binstall
wget -O cargo-binstall.tgz "https://github.com/cargo-bins/cargo-binstall/releases/latest/download/cargo-binstall-$(arch)-unknown-linux-musl.tgz"
tar xf cargo-binstall.tgz
rm cargo-binstall.tgz
mv cargo-binstall ~/.cargo/bin/

# Install fzf
wget -O fzf.tar.gz "https://github.com/junegunn/fzf/releases/download/$FZF_VERSION/fzf-$FZF_VERSION-linux_$(dpkg --print-architecture).tar.gz"
tar xf fzf.tar.gz
rm fzf.tar.gz
mv fzf ~/.local/bin/


# Install cargo packages through binstall
cargo binstall -y $CARGO_PKGS


# Init
echo "zoxide init fish | source" >> ~/.config/fish/config.fish
echo "starship init fish | source" >> ~/.config/fish/config.fish


# Completions
wget -O- https://github.com/sharkdp/bat/raw/master/assets/completions/bat.fish.in | sed 's/{{PROJECT_EXECUTABLE}}/bat/' > ~/.config/fish/completions/bat.fish
et --completions fish > ~/.config/fish/completions/et.fish
fnm completions > ~/.config/fish/completions/fnm.fish
just --completions fish > ~/.config/fish/completions/just.fish
starship completions fish > ~/.config/fish/completions/starship.fish
zellij setup --generate-completion fish > ~/.config/fish/completions/zellij.fish
