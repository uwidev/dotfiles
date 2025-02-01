########### SETUP #########

# zsh specific HISTFILE 
export HISTFILE="$XDG_STATE_HOME"/zsh/history
export HISTSIZE=5000
export SAVEHIST=$HISTSIZE
export HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# zsh histfile requires dir to already be there
if [ ! -e "$HISTFILE" ]; then
    mkdir -p "$HISTFILE"
fi

# plugin manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -e "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

source "${ZINIT_HOME}/zinit.zsh"

# themeing
# source $ZSH/oh-my-zsh.sh
eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/ohmyposh/config.toml)"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Load completions
autoload -Uz compinit && compinit
compdef _git dotfiles

zinit cdreplay -q

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Add in zsh plugins
# zinit light zsh-users/zsh-syntax-highlighting
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light z-shell/zsh-eza

# Ollama completions
zinit light ocodo/ollama_zsh_completion

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found
# zinit snippet OMZP::autoenv
zinit snippet OMZP::dotenv

# Keybindings
bindkey -v
bindkey '^p' up-line-or-beginning-search
bindkey '^n' down-line-or-beginning-search
bindkey '^y' accept-line
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# Move zcoredumps out of home
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

eval "$(fzf --zsh)"

# Set title
autoload -Uz add-zsh-hook

function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# foot integration
function osc7-pwd() {
    emulate -L zsh # also sets localoptions for us
    setopt extendedglob
    local LC_ALL=C
    printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}

function chpwd-osc7-pwd() {
    (( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd

# zoxide better cd
# eval "$(zoxide init --cmd cd zsh)"
eval "$(zoxide init zsh)"
ZO_EXCLUDE_DIRS='$HOME:/home/private'

# Apply themeing from pywal
# (cat ~/.cache/wal/sequences) # pywal
cat ~/.cache/wallust/sequences # wallust

######### ALIASES ############
# Quickly get hyprland logs
alias hyprlog="cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log"
alias hyprlog-stream="tail -f $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log"
alias adb='HOME="$XDG_DATA_HOME"/android adb'

alias vim=nvim

# To get sudo to alias correctly
alias sudo='sudo '
# An alias alternative... but it will notify literally whenever sudo is ran, even when doing sudo --help
# alias sudo='sudo -n true || notify-send "Sudo Password Prompt" "Please enter your sudo password" && sudo  '

# Per xdg-ninja alias to declutter $HOME
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"


# Docker alias wrapper to ignore .env files on compose
# Needs to be a function parser to support subcommands
# Unfortunately, breaks autocompletion
# docker () {
#     echo "docker alias"
# 	case $1 in
# 		compose)
# 		    echo "compose"
# 			shift # handle compose ourselves
# 			command docker compose --env-file /dev/null "$@"
# 			;;
# 		*)
# 			command docker "$@"
# 			;;
#     esac
# }

# yazi wrapper to cd as we navigate
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'


# better folder navigation

# alias ls='ls --color'
# alias l='ls -Alh'

alias ..='cd ..'
alias ...='cd ../..'

# systemd management
alias sys='systemctl'
alias sysu='systemctl --user'
alias ja='journalctl'
alias jab='journalctl -b'

# safe-rm
alias rm='rm -i'

# # trashy aliases
# alias trash-restore="trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy restore --match=exact --force"
# alias trash-empty="trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy empty --match=exact --force"

# conceal to trash
# alias trash='conceal'

# alias trash-restore='echo 0 | trash-restore $(trash-list | grep $(pwd) --color=never | sed "s/^[^/]*//" | fzf) > /dev/null'
