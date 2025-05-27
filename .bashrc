# ~/.bashrc: executed by bash(1) for non-login shells.
# Enhanced version with productivity features

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# =============================================================================
# HISTORY CONFIGURATION
# =============================================================================
# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth:erasedups
# Append to the history file, don't overwrite it
shopt -s histappend
# Large history size for better command recall
HISTSIZE=10000
HISTFILESIZE=20000
# Save multi-line commands as single history entry
shopt -s cmdhist
# Save timestamp with history
HISTTIMEFORMAT='%F %T '
# Ignore common commands to reduce clutter
HISTIGNORE='ls:ll:la:cd:pwd:exit:clear:history'

# =============================================================================
# SHELL OPTIONS
# =============================================================================
# Check the window size after each command
shopt -s checkwinsize
# Enable recursive globbing with **
shopt -s globstar
# Case-insensitive pathname expansion
shopt -s nocaseglob
# Correct minor errors in directory names
shopt -s cdspell
# Correct minor errors in directory component names
shopt -s dirspell
# Enable extended pattern matching
shopt -s extglob
# Auto-correct directory names when using cd
shopt -s autocd

# =============================================================================
# ENVIRONMENT VARIABLES
# =============================================================================
# Set default editor (prioritize nvim if available)
if command -v nvim >/dev/null 2>&1; then
    export EDITOR='nvim'
    export VISUAL='nvim'
elif command -v vim >/dev/null 2>&1; then
    export EDITOR='vim'
    export VISUAL='vim'
else
    export EDITOR='nano'
    export VISUAL='nano'
fi

# Set pager
export PAGER='less'
export LESS='-R -M -S -i -J --mouse'

# Colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# =============================================================================
# PROMPT CONFIGURATION
# =============================================================================
# Function to get git branch
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Function to get git status
parse_git_dirty() {
    [[ $(git status --porcelain 2>/dev/null) ]] && echo "*"
}

# Enhanced colored prompt
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # Colors
    RED='\[\033[0;31m\]'
    GREEN='\[\033[0;32m\]'
    YELLOW='\[\033[1;33m\]'
    BLUE='\[\033[0;34m\]'
    PURPLE='\[\033[0;35m\]'
    CYAN='\[\033[0;36m\]'
    WHITE='\[\033[1;37m\]'
    RESET='\[\033[0m\]'
    
    # Custom prompt with git support
    PS1="${debian_chroot:+($debian_chroot)}${GREEN}\u${RESET}@${BLUE}\h${RESET}:${PURPLE}\w${RESET}${YELLOW}\$(parse_git_branch)${RED}\$(parse_git_dirty)${RESET}\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w$(parse_git_branch)$(parse_git_dirty)\$ '
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# =============================================================================
# COLOR SUPPORT
# =============================================================================
# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias diff='diff --color=auto'
    alias ip='ip --color=auto'
fi


# =============================================================================
# ENHANCED ALIASES
# =============================================================================
# Smart ls aliases - use eza if available, otherwise fall back to ls
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --group-directories-first'
    alias ll='eza -la --group-directories-first'
    alias la='eza -a --group-directories-first'
    alias l='eza --group-directories-first'
    alias lt='eza -l --sort=modified --group-directories-first'     # Sort by time
    alias lh='eza -lh --group-directories-first'                   # Human readable sizes
    alias lS='eza -l --sort=size --group-directories-first'        # Sort by size
    alias tree='eza --tree --color=auto'                           # Tree view with eza
else
    alias ls='ls --color=auto'
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
    alias lt='ls -ltr'     # Sort by time
    alias lh='ls -lh'      # Human readable sizes
    alias lS='ls -lS'      # Sort by size
    alias tree='tree -C'   # Colored tree (if tree is installed)
fi

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

# Directory operations
alias mkdir='mkdir -pv'
alias rmdir='rmdir -v'

# File operations
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias ln='ln -iv'

# Smart cat alias - use bat if available
if command -v bat >/dev/null 2>&1; then
    alias cat='bat'
    alias less='bat --paging=always'
elif command -v batcat >/dev/null 2>&1; then
    alias cat='batcat'
    alias bat='batcat'
    alias less='batcat --paging=always'
fi

# System information
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias ports='netstat -tuln'

# Process management
if command -v htop >/dev/null 2>&1; then
    alias top='htop'
fi
alias pstree='pstree -p'

# Network
alias ping='ping -c 5'
alias wget='wget -c'
alias curl='curl -L'

# Text processing
alias less='less -R'
alias more='less'

# Smart grep aliases - use ripgrep if available
if command -v rg >/dev/null 2>&1; then
    alias grep='rg --color=auto'
    alias rgrep='rg'
else
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'
fi

# Archive operations
alias tar='tar -v'
alias untar='tar -xvf'
alias targz='tar -czvf'
alias untargz='tar -xzvf'

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gst='git stash'
alias gw='git whatchanged'

# Quick edit configs
alias bashrc='${EDITOR} ~/.bashrc && source ~/.bashrc'
alias vimrc='${EDITOR} ~/.vimrc'
alias nvimrc='${EDITOR} ~/.config/nvim/init.vim'

# System shortcuts
alias c='clear'
alias h='history'
alias j='jobs -l'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

# Safety features
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Alert alias for long running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Cheatsheet alias
alias cheat='bat ~/.bash_cheatsheet.md || cat ~/.bash_cheatsheet.md'
alias bashhelp='cheat'

# =============================================================================
# FUNCTIONS
# =============================================================================
# Extract function for various archive formats
extract() {
    if [ -f "$1" ]; then
        case $1 in
            *.tar.bz2)   tar xjf "$1"        ;;
            *.tar.gz)    tar xzf "$1"        ;;
            *.tar.xz)    tar xJf "$1"        ;;
            *.bz2)       bunzip2 "$1"        ;;
            *.rar)       unrar x "$1"        ;;
            *.gz)        gunzip "$1"         ;;
            *.tar)       tar xf "$1"         ;;
            *.tbz2)      tar xjf "$1"        ;;
            *.tgz)       tar xzf "$1"        ;;
            *.zip)       unzip "$1"          ;;
            *.Z)         uncompress "$1"     ;;
            *.7z)        7z x "$1"           ;;
            *.deb)       ar x "$1"           ;;
            *.tar.lzma)  tar --lzma -xf "$1" ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find file by name
ff() {
    find . -type f -name "*$1*" 2>/dev/null
}

# Find directory by name
fd() {
    find . -type d -name "*$1*" 2>/dev/null
}

# Show disk usage of current directory
dus() {
    du -sh "${1:-.}" | sort -hr
}

# Quick backup function
backup() {
    cp "$1"{,.bak}
}

# Weather function (requires curl)
weather() {
    curl -s "wttr.in/${1:-}" | head -n -3
}

# Show most used commands
top10() {
    history | awk '{print $2}' | sort | uniq -c | sort -rn | head -10
}

# Generate random password
genpass() {
    openssl rand -base64 "${1:-12}"
}

# Quick server
serve() {
    python3 -m http.server "${1:-8000}"
}

# Process search
psgrep() {
    ps aux | grep "$1" | grep -v grep
}

# =============================================================================
# COMPLETION ENHANCEMENTS
# =============================================================================
# Case-insensitive tab completion
bind 'set completion-ignore-case on'
# Treat hyphens and underscores as equivalent
bind 'set completion-map-case on'
# Display matches for ambiguous patterns at first tab press
bind 'set show-all-if-ambiguous on'
# Immediately add a trailing slash when autocompleting symlinks to directories
bind 'set mark-symlinked-directories on'

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load custom completions if they exist
for completion in ~/.bash_completion.d/*; do
    [ -r "$completion" ] && source "$completion"
done

eval "$(starship init bash)"

# =============================================================================
# =============================================================================
# =============================================================================
    
    # Enhanced directory search
    fzf-cd() {
        local dir
        dir=$(find . -type d -not -path "*/\.git/*" 2>/dev/null | fzf --preview 'ls -la {}') && cd "$dir"
    }
    alias cf='fzf-cd'
# =============================================================================

# Autojump integration (if available) - with error handling
if [ -f /usr/share/autojump/autojump.sh ]; then
    source /usr/share/autojump/autojump.sh 2>/dev/null || true
elif [ -f /usr/share/autojump/autojump.bash ]; then
    source /usr/share/autojump/autojump.bash 2>/dev/null || true
fi

# =============================================================================
# CUSTOM ALIASES AND FUNCTIONS
# =============================================================================
# Load custom aliases if they exist
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Load custom functions if they exist
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Load local configuration if it exists
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

# =============================================================================
# STARTUP MESSAGES
# =============================================================================
# Display system information on login
if [ -t 0 ]; then
    # Show a fortune if available
    if command -v fortune >/dev/null 2>&1 && command -v cowsay >/dev/null 2>&1; then
        fortune | cowsay
    elif command -v fortune >/dev/null 2>&1; then
        fortune
    elif command -v neofetch >/dev/null 2>&1; then
        neofetch
    fi
    
    # Show tip about cheatsheet
    echo -e "\n💡 Type 'cheat' or 'bashhelp' to see available commands and shortcuts!"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# ==============================
# My custom aliases 
# ==============================

