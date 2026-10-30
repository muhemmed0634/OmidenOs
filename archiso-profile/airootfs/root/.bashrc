# OmidenOS - Bash Configuration

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
PS1='\[\033[01;35m\]OmidenOS\[\033[00m\]@\[\033[01;36m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend
shopt -s checkwinsize

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias mkdir='mkdir -pv'
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias df='df -h'
alias free='free -h'
alias update='pacman -Syu'
alias install='pacman -S'
alias search='pacman -Ss'
alias vi='nvim'
alias vim='nvim'
alias cat='bat 2>/dev/null || cat'

# Fastfetch on startup
fastfetch 2>/dev/null

# Path
export PATH="$HOME/.local/bin:$PATH"
