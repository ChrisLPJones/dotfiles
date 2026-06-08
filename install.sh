#!/bin/bash


sudo apt update && sudo apt upgrade -y
sudo apt install -y \
    curl wget zsh tmux git alacritty grc wl-clipboard xclip ripgrep stow unzip fontconfig \
    python3-pip python3-venv python3-pynvim command-not-found gpg

git clone https://github.com/ChrisLPJones/dotfiles.git "$HOME/dotfiles"

DOTFILES_DIR="$HOME/dotfiles"

sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

nvim_version=$(nvim --version 2>/dev/null | head -1 | grep -oP '\d+\.\d+\.\d+' || echo "0.0.0")
if [ "$nvim_version" != "0.12.2" ]; then
    set -e
    platform="x86_64"
    [ "$(uname -m)" = "aarch64" ] && platform="arm64"
    tarball="nvim-linux-${platform}.tar.gz"
    curl -L "https://github.com/neovim/neovim/releases/download/v0.12.2/${tarball}" -o "/tmp/${tarball}"
    tar xzf "/tmp/${tarball}" -C /tmp
    sudo cp -r "/tmp/nvim-linux-${platform}/"* /usr/local/
    rm -rf "/tmp/${tarball}" "/tmp/nvim-linux-${platform}"
    set +e
fi

if ! command -v tree-sitter &>/dev/null; then
    set -e
    ts_platform="x64"
    [ "$(uname -m)" = "aarch64" ] && ts_platform="arm64"
    wget -q "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-cli-linux-${ts_platform}.zip" \
        -O /tmp/tree-sitter.zip
    unzip -o /tmp/tree-sitter.zip tree-sitter -d /tmp/tree-sitter-bin
    sudo mv /tmp/tree-sitter-bin/tree-sitter /usr/local/bin/tree-sitter
    sudo chmod +x /usr/local/bin/tree-sitter
    rm -rf /tmp/tree-sitter.zip /tmp/tree-sitter-bin
    set +e
fi

if [ ! -d ~/.oh-my-zsh ]; then
    set -e
    RUNZSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended --keep-zshrc
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting \
        "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    set +e
fi

if [ ! -d ~/.fzf ]; then
    set -e
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --no-update-rc --all
    set +e
fi

if ! command -v starship &>/dev/null; then
    set -e
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
    set +e
fi

sudo chsh -s "$(which zsh)" "$USER"


if ! command -v eza &>/dev/null; then
    set -e
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
        | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
        | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
    set +e
fi

if ! fc-list | grep -qi "CaskaydiaCove"; then
    set -e
    mkdir -p ~/.local/share/fonts
    wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/CascadiaCode.zip" \
        -O /tmp/CascadiaCode.zip
    unzip -o /tmp/CascadiaCode.zip -d ~/.local/share/fonts/CascadiaCode
    fc-cache -f
    rm /tmp/CascadiaCode.zip
    set +e
fi

# Remove any files or stale symlinks that would block stow
for f in ~/.zshrc ~/.tmux.conf ~/.config/starship.toml; do
    if [ -L "$f" ] && [ ! -e "$f" ]; then rm -f "$f"        # broken symlink
    elif [ -f "$f" ] && [ ! -L "$f" ]; then rm -f "$f"      # regular file
    fi
done
for d in ~/.config/nvim ~/.config/alacritty; do
    if [ -L "$d" ] && [ ! -e "$d" ]; then rm -f "$d"        # broken symlink
    elif [ -d "$d" ] && [ ! -L "$d" ]; then rm -rf "$d"     # regular directory
    fi
done

# Deploy dotfiles before any tool setup that depends on them
mkdir -p ~/.config
stow -d "$DOTFILES_DIR" -t "$HOME" zsh tmux alacritty starship nvim

if [ ! -d ~/.tmux/plugins/tpm ]; then
    set -e
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ~/.tmux/plugins/tpm/bin/install_plugins
    sed -i 's/@thm_maroon}\"/@thm_mauve}"/' ~/.tmux/plugins/tmux/status/application.conf
    sed -i 's/@thm_rosewater}\"/@thm_mauve}"/' ~/.tmux/plugins/tmux/status/directory.conf
    sed -i 's/@thm_green}/@thm_mauve}/' ~/.tmux/plugins/tmux/status/session.conf
    sed -i 's/@thm_sky\"/@thm_mauve"/' ~/.tmux/plugins/tmux/status/user.conf
    sed -i 's/@thm_bg "#[^"]*"/@thm_bg "#1c1c1f"/' ~/.tmux/plugins/tmux/themes/catppuccin_mocha_tmux.conf
    sed -i 's/@thm_mauve "[^"]*"/@thm_mauve "#81A1C1"/' ~/.tmux/plugins/tmux/themes/catppuccin_mocha_tmux.conf
    sed -i 's/@thm_maroon "[^"]*"/@thm_maroon "#81A1C1"/' ~/.tmux/plugins/tmux/themes/catppuccin_mocha_tmux.conf
    sed -i 's/@thm_sapphire "[^"]*"/@thm_sapphire "#1c1c1f"/' ~/.tmux/plugins/tmux/themes/catppuccin_mocha_tmux.conf
    sed -i 's/@thm_lavender "[^"]*"/@thm_lavender "#81A1C1"/' ~/.tmux/plugins/tmux/themes/catppuccin_mocha_tmux.conf
    sed -i 's/@thm_overlay_2 "[^"]*"/@thm_overlay_2 "#4d6174"/' ~/.tmux/plugins/tmux/themes/catppuccin_mocha_tmux.conf
    sed -i 's/@thm_surface_0 "[^"]*"/@thm_surface_0 "#45475a"/' ~/.tmux/plugins/tmux/themes/catppuccin_mocha_tmux.conf
    sed -i 's/@thm_mantle "[^"]*"/@thm_mantle "#1c1c1f"/' ~/.tmux/plugins/tmux/themes/catppuccin_mocha_tmux.conf
    sed -i "s/'C-h'/'M-Left'/" ~/.tmux/plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
    sed -i "s/'C-l'/'M-Right'/" ~/.tmux/plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
    sed -i "s/'C-k'/'M-Up'/" ~/.tmux/plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
    sed -i "s/'C-j'/'M-Down'/" ~/.tmux/plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
    sed -i "s/'C-\\\\'/'M-\\\\'/" ~/.tmux/plugins/vim-tmux-navigator/vim-tmux-navigator.tmux
    set +e
fi
