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

# Tools
nmap() {
    if [ "$EUID" -eq 0 ]; then
        command grc nmap "$@"
    else
        sudo grc nmap "$@"
    fi
}
alias nikto="/opt/nikto/program/nikto.pl"
alias nuclei="/opt/nuclei/cmd/nuclei/nuclei"
alias ffuf="/opt/ffuf/ffuf"
alias sqlmap="/opt/sqlmap/sqlmap.py"
alias nosqlmap="python2.7 /opt/NoSQLMap/nosqlmap.py"
alias responder="sudo /opt/Responder/venv/bin/python3 /opt/Responder/Responder.py"
alias hashcat="/opt/hashcat/hashcat"
alias john="/opt/john/run/john"
alias msfconsole="sudo /opt/metasploit-framework/msfconsole -q"
alias msfvenom="sudo /opt/metasploit-framework/msfvenom"
alias searchsploit="/opt/exploitdb/searchsploit"
alias hydra="/opt/hydra/hydra"
alias ghidra="/opt/ghidra_12.0_PUBLIC/ghidraRun"
alias evil-winrm="RUBYOPT='-W0' /opt/evil-winrm/evil-winrm.rb"
alias nxc="/opt/NetExec/venv/bin/nxc"
alias GitHack="python3 /opt/GitHack/GitHack.py"
alias enum4linux-ng="/opt/enum4linux-ng/venv/bin/python3 /opt/enum4linux-ng/enum4linux-ng.py"
alias onesixtyone="/opt/onesixtyone/onesixtyone"
alias smbmap="/opt/smbmap/venv/bin/python3 /opt/smbmap/smbmap/smbmap.py"
alias dnsenum="/opt/dnsenum2/dnsenum.pl"
alias smtp-user-enum="/opt/smtp-user-enum/venv/bin/python3 /opt/smtp-user-enum/venv/bin/smtp-user-enum"
alias braa="/opt/braa/braa"
alias snmpcheck="/opt/snmpcheck/snmpcheck.rb"
alias odat="/opt/odat/odat.py"
alias reconspider="python3 /opt/ReconSpider/ReconSpider.py"
alias gobuster="/opt/gobuster/gobuster"
alias jwt_tool="/opt/jwt_tool/venv/bin/python3 /opt/jwt_tool/jwt_tool.py"
alias chisel="/opt/chisel/chisel"
alias creds="/opt/DefaultCreds-cheat-sheet/venv/bin/python3 /opt/DefaultCreds-cheat-sheet/venv/bin/creds"
alias pykatz="/opt/pypykatz/venv/bin/python3 /opt/pypykatz/venv/bin/pypykatz"
alias username-anarchy="/opt/username-anarchy/username-anarchy"
alias kerbrute="/opt/kerbrute/kerbrute"

# Impacket
alias samrdump="venv/bin/python3 examples/samrdump.py"
alias mssqlclient="/opt/impacket/venv/bin/python3 /opt/impacket/venv/bin/mssqlclient.py "
alias smbserver="sudo /opt/impacket/venv/bin/python3.14 /opt/impacket/venv/bin/smbserver.py"

# PATH additions
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"

# fzf integration
export FZF_DEFAULT_OPTS='--exact --height=100%'
export FZF_CTRL_R_OPTS='--reverse'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Pearl Paths
#PATH="$HOME/.local/perl5/bin${PATH:+:${PATH}}"; export PATH;
#PERL5LIB="$HOME/.local/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
#PERL_LOCAL_LIB_ROOT="$HOME/.local/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
#PERL_MB_OPT="--install_base \"$HOME/.local/perl5\""; export PERL_MB_OPT;
#PERL_MM_OPT="INSTALL_BASE=$HOME/.local/perl5"; export PERL_MM_OPT;
#eval "$(perl -I$HOME/.local/lib/perl5 -Mlocal::lib=$HOME/.local)"

# Go Path
export GOPATH="$HOME/.local/share/go"
export PATH="$HOME/.local/bin:$GOPATH/bin:$PATH"

# Oracle Path
export LD_LIBRARY_PATH=/opt/oracle/instantclient_21_4:$LD_LIBRARY_PATH
export PATH=$LD_LIBRARY_PATH:$PATH


# Ruby
#export PATH="$HOME/.rbenv/bin:$PATH"
#eval "$(rbenv init -)"
