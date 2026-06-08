# Load custom aliases
if [ -f ~/.zsh_aliases ]; then
    source ~/.zsh_aliases
fi

# Prevent PATH duplication
typeset -U path

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY

# Navigation and correction
setopt AUTO_CD
#setopt CORRECT
setopt CDABLE_VARS

# Firefox
export MOZ_ENABLE_WAYLAND=1
export MOZ_DISABLE_RDD_SANDBOX=1

# Directory hashes for quick access
hash -d docs=~/Documents
hash -d dl=~/Downloads
hash -d proj=~/Projects
hash -d cfg=~/.config

# Oh-my-zsh setup
export ZSH="$HOME/.oh-my-zsh"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source "$ZSH/oh-my-zsh.sh"

# Initialize starship (after oh-my-zsh)
eval "$(starship init zsh)"

# Syntax highlighting styles
ZSH_HIGHLIGHT_STYLES+=(path none path_prefix none)

# eza parameters and aliases
export EZA_COLORS="da=36"  # dates in cyan instead of blue
eza_params=('--icons' '--group-directories-first')
alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'

# GRC
alias curl="grc curl"
alias ifconfig="grc ifconfig"
alias iwconfig="grc iwconfig"
alias netstat="grc netstat"
alias ping="grc ping"
alias ps="grc ps"
alias tcpdump="grc tcpdump"
alias whois="grc whois"

# PATH additions
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"

# fzf integration
export FZF_DEFAULT_OPTS='--exact --height=100%'
export FZF_CTRL_R_OPTS='--reverse'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Go Path
export GOPATH="$HOME/.local/share/go"
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"

# Oracle Path
export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_4:$LD_LIBRARY_PATH
export PATH=$LD_LIBRARY_PATH:$PATH

# Ruby
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"
