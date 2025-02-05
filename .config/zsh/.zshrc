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

# set up necessary infrstructure for code completion

# antidote plugin manager
zsh_plugins=${ZDOTDIR:-$HOME}/.zsh_plugins
source ${ZDOTDIR:-$HOME}/.antidote/antidote.zsh
antidote load ${ZDOTDIR:-$HOME}/.zsh_plugins.txt

autoload -Uz compinit
compinit

# dotfiles
alias dotfiles='/usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'
alias dfi=dotfiles
compdef _git dfi # use git comp for alias `dotfiles`

# themeing
eval "$(oh-my-posh init zsh --config $XDG_CONFIG_HOME/ohmyposh/config.toml)"

# better fzf key bindings
# autoload tells zsh to look for this function on fpath as needed
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search

# register function for zsh line editor widget
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

# Keybindings
bindkey -v
bindkey '^p' up-line-or-beginning-search
bindkey '^n' down-line-or-beginning-search
bindkey '^y' accept-line
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# bindings for history substring plugin
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down


# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# init fzf (fuzzy cd)
eval "$(fzf --zsh)"

# Move zcoredumps out of home
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# dynamically set window title
autoload -Uz add-zsh-hook  # allow custom hook functions for zsh
function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}
#
function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}
#
if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# # we switched to uv to manage python
# # pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
# eval "$(pyenv init -)"

# foot integration
# https://codeberg.org/dnkl/foot/wiki#zsh
#
# allows <C-N> (capital N) to spawn new instance of same pwd
function osc7-pwd() {
	emulate -L zsh # also sets localoptions for us
	setopt extendedglob
	local LC_ALL=C
	printf '\e]7;file://%s%s\e\' $HOST ${PWD//(#m)([^@-Za-z&-;_~])/%${(l:2::0:)$(([##16]#MATCH))}}
}
#
function chpwd-osc7-pwd() {
	(( ZSH_SUBSHELL )) || osc7-pwd
}
add-zsh-hook -Uz chpwd chpwd-osc7-pwd
#
# foot integration
# allow jumping between prompts with <C-Z> and <C-X>
precmd() {
	print -Pn "\e]133;A\e\\"
}
#
# foot integration
# allow piping of last output to next command with <C-G>
function precmd {
	if ! builtin zle; then
		print -n "\e]133;D\e\\"
	fi
}
#
# foot integration
# allow piping capabilities of last cmd out
# foot conf binds <C-G> to pipe to wl-copy (system clipboard)
function preexec {
	print -n "\e]133;C\e\\"
}

# init zoxide better cd
eval "$(zoxide init zsh)"
ZO_EXCLUDE_DIRS='$HOME:/home/private'

# Apply themeing from pywal
# (cat ~/.cache/wal/sequences) # pywal
# cat ~/.cache/wallust/sequences # wallust

###########
# ALIASES #
###########
# Make sudo work with aliases
alias sudo='sudo '
# An alias alternative... but it will notify literally whenever sudo is ran, even when doing sudo --help
# alias sudo='sudo -n true || notify-send "Sudo Password Prompt" "Please enter your sudo password" && sudo	'

# Quickly get hyprland logs
alias hyprlog="cat $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log"
alias hyprlog-stream="tail -f $XDG_RUNTIME_DIR/hypr/$(ls -t $XDG_RUNTIME_DIR/hypr/ | head -n 1)/hyprland.log"
alias adb='HOME="$XDG_DATA_HOME"/android adb'

alias vim=nvim

# Per xdg-ninja alias to declutter $HOME
alias nvidia-settings='nvidia-settings --config="$XDG_CONFIG_HOME"/nvidia/settings'
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# Docker alias wrapper to ignore .env files on compose
# Needs to be a function parser to support subcommands
# Unfortunately, breaks autocompletion
# docker () {
#	  echo "docker alias"
#	case $1 in
#		compose)
#			echo "compose"
#			shift # handle compose ourselves
#			command docker compose --env-file /dev/null "$@"
#			;;
#		*)
#			command docker "$@"
#			;;
#	  esac
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

# better folder navigation
alias ..='cd ..'
alias ...='cd ../..'

# systemd management
alias sys='systemctl'
alias sysu='systemctl --user'
alias ja='journalctl'
alias jab='journalctl - b'
alias jau='journalctl --user'
alias jaub='journalctl --user -b'

# safe-rm replaces rm, and its default behavior does not ask or confirmation
# this will make it ask always
alias rm='rm -i'

# # trashy aliases
# alias trash-restore="trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy restore --match=exact --force"
# alias trash-empty="trash list | fzf --multi | awk '{$1=$1;print}' | rev | cut -d ' ' -f1 | rev | xargs trashy empty --match=exact --force"

# alias trash-restore='echo 0 | trash-restore $(trash-list | grep $(pwd) --color=never | sed "s/^[^/]*//" | fzf) > /dev/null'

# uv run autocomplete files fix
# https://github.com/astral-sh/uv/issues/8432#issuecomment-2453494736
_uv_run_mod() {
    if [[ "$words[2]" == "run" && "$words[CURRENT]" != -* ]]; then
        _arguments '*:filename:_files'
    else
        _uv "$@"
    fi
}
compdef _uv_run_mod uv

# vim: ts=4
