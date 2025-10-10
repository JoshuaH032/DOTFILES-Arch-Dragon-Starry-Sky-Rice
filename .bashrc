# ~/.bashrc — Arch-Dragon Starry Sky 🌌🐉
# Painterly Realism Edition

# Exit if non-interactive
[[ $- != *i* ]] && return

# --- Locale ---
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# --- Wayland tweaks ---
export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland

# --- Bash behavior niceties ---
shopt -s histappend checkwinsize cdspell autocd
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:ignorespace
HISTTIMEFORMAT="%F %T "
PROMPT_COMMAND='history -a; history -c; history -r'

# --- Bash completion ---
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    . /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    . /etc/bash_completion
  fi
fi

# --- Colors for ls/grep ---
if command -v dircolors >/dev/null 2>&1; then
  [[ -f ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# --- QoL aliases ---
alias ..='cd ..'
alias ...='cd ../..'
alias update='sudo pacman -Syu'

cleanup() {
  local o; o="$(pacman -Qdtq 2>/dev/null || true)"
  [[ -n "$o" ]] && sudo pacman -Rns $o || echo "🌌 No orphaned constellations."
}

# --- Reload toolkit ---
reload() { source ~/.bashrc && echo -e "✨ Bashrc refreshed under starlight!"; }

# --- Terminal title ---
set_title() { printf "\033]2;%s\007" "$*"; }
PROMPT_COMMAND="set_title \"\u@\h: \w\"; $PROMPT_COMMAND"

# --- Starry Sky Prompt ---
# cobalt user/host + starlight yellow directory
PS1='\[\e[38;5;75m\]\u\[\e[0m\]@\[\e[38;5;39m\]\h \[\e[38;5;226m\]\W\[\e[0m\]\$ '

# --- Starry Sky Welcome Banner ---
clear
echo -e "\e[38;5;39m============================================\e[0m"
echo -e "   🌌 Welcome back, \e[38;5;226mArch-Dragon\e[0m — beneath the Starry Sky"
echo -e "   Host:   \e[94m$(uname -n)\e[0m"
echo -e "   Kernel: \e[96m$(uname -r)\e[0m"
echo -e "   Uptime: \e[93m$(uptime -p | cut -d ' ' -f2-)\e[0m"
echo -e "   Date:   \e[95m$(date)\e[0m"
echo -e "\e[38;5;39m============================================\e[0m"
echo -e "   🎨 Every command paints another star"
echo

# --- Fastfetch (if installed) ---
command -v fastfetch >/dev/null 2>&1 && fastfetch

# --- Git bare repo alias for dotfiles ---
alias config='/usr/bin/git --git-dir=/home/joshuah/.cfg/ --work-tree=/home/joshuah'
