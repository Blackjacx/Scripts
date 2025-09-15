# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Path to your oh-my-zsh installation.
ZSH=${HOME}/.oh-my-zsh

# Homebrew directory prefix differentiation M1 / Intel
[[ $(uname -p) == 'arm' ]] && HOMEBREW_DIR_PREFIX="/opt/homebrew" || HOMEBREW_DIR_PREFIX="/usr/local"

# Conform to XDG Standard
# https://stackoverflow.com/a/78361332/971329
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CONFIG_DIR="${XDG_CONFIG_HOME}"

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#
# CURRENTLY POWERLEVEL10K THEME IS USED - SOURCED BELOW
#
# ZSH_THEME="gnzh"
# ZSH_THEME="Spaceship"
# ZSH_THEME="superjarin"
# ZSH_THEME="duellj"
# ZSH_THEME="random"
# ZSH_THEME="agnoster"

# Set orange background and white foreground for the zsh-autosuggestions plugin 
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ffffff,bg=#d18e1e"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
UPDATE_ZSH_DAYS=7

# Uncomment if you would like oh-my-zsh to automatically upgrade itself without prompting you.
DISABLE_UPDATE_PROMPT=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="false"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Configure bgnotify
bgnotify_threshold=3  ## set your own notification threshold

# Configure agnoster theme
DEFAULT_USER="$(whoami)"
export DEFAULT_USER

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git 
  git-extras 
  swiftpm 
  bundler 
  common-aliases 
  colored-man-pages 
  bgnotify 
  zsh-autosuggestions
  # fzf # tab-completion does not work when this is enabled
  fzf-tab
  you-should-use
)

# User configuration

# Set locale, affects sort order when using `sort` (https://superuser.com/a/1598323/1860273)
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
# Set user gem path to avoid the need of sudo
export GEM_HOME=$HOME/.gem
# Set the path using specified order
export PATH="$HOME/.rbenv/bin:${HOME}/.mint/bin:${GEM_HOME}/bin:${HOMEBREW_DIR_PREFIX}/sbin:${HOMEBREW_DIR_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki:/opt/local/libexec/gnubin:/Library/TeX/texbin:${PATH}"

#-------------------------------------------------------------------------------
# FZF
#-------------------------------------------------------------------------------
# Configuration: https://github.com/Aloxaf/fzf-tab/wiki/Configuration
# Preview: https://github.com/Aloxaf/fzf-tab/wiki/Preview

# Mise compatibility
export FZF_BASE="${HOME}/.local/share/mise/installs/fzf/0"

# Check if the $TMUX environment variable is set and not empty
# ${TMUX:-} gives a default empty string if unset — so it won’t crash when using `set -u`.
# -n tests for non-empty
if [ -n "${TMUX:-}" ]; then
    # We are in tmux, so run fzf-tmux in poopup mode
    alias fzf="fzf-tmux -p90%,70%"
else
    # We are not in tmux, so run fzf normally
    unalias fzf
fi

# no sorting
# zstyle ':completion:complete:*:options' sort false
# show preview when using cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --all --header -1 -g --color-scale --icons --color=always $realpath | head -200'
# show preview when using zoxide
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --all --header -1 -g --color-scale --icons --color=always $realpath | head -200'
# show preview when using open
zstyle ':fzf-tab:complete:open:*' fzf-preview '
  if [[ -f $realpath ]]; then 
    if command -v bat > /dev/null 2>&1; then
      bat --color always --paging never $realpath --line-range :500
    else
      cat $realpath
    fi    
  else
    eza --all --header -1 -g --color-scale --icons --color=always $realpath | head -200
  fi
'
# Show preview when using eza (ls)
zstyle ':fzf-tab:complete:eza:*' fzf-preview '
  if [[ -f $realpath ]]; then 
    if command -v bat > /dev/null 2>&1; then
      bat --color always --paging never $realpath --line-range :500
    else
      cat $realpath
    fi    
  else
    eza --all --header -1 -g --color-scale --icons --color=always $realpath | head -200
  fi
'
# Show preview when using bat (cat)
zstyle ':fzf-tab:complete:bat:*' fzf-preview '
  if [[ -f $realpath ]]; then 
    if command -v bat > /dev/null 2>&1; then
      bat --color always --paging never $realpath --line-range :500
    else
      cat $realpath
    fi    
  else 
    eza --all --header -1 -g --color-scale --icons --color=always $realpath | head -200
  fi
'

# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'
# Use tmux popup for tab completion (https://github.com/Aloxaf/fzf-tab/wiki/Configuration#fzf-command)
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# Default
zstyle ':fzf-tab:*' fzf-command fzf

# export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
# export FZF_DEFAULT_OPTS='--layout=reverse'
# export FZF_DEFAULT_OPTS='--cycle --tmux --color bg:#222222,preview-bg:#333333 --info=inline-right --ellipsis=… --tabstop=4 --highlight-line'
# Uncomment the following line to disable fuzzy completion
# export DISABLE_FZF_AUTO_COMPLETION="true"
# Uncomment the following line to disable key bindings (CTRL-T, CTRL-R, ALT-C)
# export DISABLE_FZF_KEY_BINDINGS="true"
# Uncomment to specify default command when input is tty

# -- START: 7 Amazing CLI Tools You Need To Try (https://www.youtube.com/watch?v=mmqDYw9C30I)

# -- Use fd instead of find --
FD_OPTIONS="--follow --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_COMMAND="fd --type=f $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d $FD_OPTIONS"

# Show FZF popup instead of inline
export FZF_CTRL_R_OPTS="--reverse"
export FZF_TMUX_OPTS="-p90%,70%"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

export FZF_CTRL_T_OPTS="--preview 'bat -n --color=always --line-range :500 {}'" 
export FZF_ALT_C_OPTS="--preview 'eza --tree —color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)               fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset)     fzf --preview "eval 'echo \$'{}" "$@" ;;
    ssh)              fzf --preview 'dig {}' "$@" ;;
    *)                fzf --preview 'bat -n --color=always --line-range :500 {}' "$@" ;;
  esac
}

# -- END: 7 Amazing CLI Tools You Need To Try (https://www.youtube.com/watch?v=mmqDYw9C30I)

#-------------------------------------------------------------------------------
# History
#-------------------------------------------------------------------------------

export HISTFILE="${HOME}/.zsh_history"                # Explicitly set the history file
export HISTORY_IGNORE="(la|ls|ll|cd|pwd|exit|cd ..)"  # Ignore these commands
export HISTSIZE=5000                                  # Max number of commands loaded into memory from the history file (having too much lines in the buffer makes scrolling in tmux super slow)
export HISTFILESIZE=500000
export SAVEHIST=500000                                # Max number of commands stored in the zsh history file
export DISABLE_MAGIC_FUNCTIONS=true                   # Enables fast pasting.
setopt HIST_IGNORE_DUPS                               # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS                           # Delete old recorded entry if new entry is a duplicate.
setopt HIST_SAVE_NO_DUPS                              # Don't write duplicate entries in the history file.
setopt HIST_FIND_NO_DUPS                              # Do not display a line previously found.
setopt HIST_EXPIRE_DUPS_FIRST                         # Expire duplicate entries first when trimming history.
setopt HIST_REDUCE_BLANKS                             # Tidy up the line when it is entered into the history by removing any excess blanks that mean nothing to the shell. This can also mean that the line becomes a duplicate of a previous one even if it would not have been in its untidied form. It is smart enough not to remove blanks which are important, i.e. are quoted.
setopt HIST_IGNORE_SPACE                              # A useful trick to prevent particular entries from being recorded into a history by preceding them with at least one space.
setopt APPEND_HISTORY                                 # Allows appending the new history to the old
# Don't enable when SHARE_HIST is enabled: https://askubuntu.com/a/23631
# setopt INC_APPEND_HISTORY                             # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY                                  # Share history between all sessions.
setopt NO_HIST_BEEP                                   # If you try to scroll up or down beyond the end of the history list, the shell will beep. It is on by default, so use NO_HIST_BEEP to turn it off.
setopt HIST_VERIFY                                    # Don't execute immediately upon history expansion.
setopt BANG_HIST                                      # Treat the '!' character specially during expansion.


[ -f "$ZSH"/oh-my-zsh.sh ] && source "$ZSH"/oh-my-zsh.sh
[ -f ~/dev/scripts/imports.sh ] && source ~/dev/scripts/imports.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# export EDITOR="subl -n -w"
# export EDITOR="nano"
export VISUAL="nvim"
export EDITOR="$VISUAL"


# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

#-------------------------------------------------------------------------------
# Completions
#-------------------------------------------------------------------------------

# By the following 3 options, the completion selection menu is opened with the first press of TAB
setopt AUTOLIST AUTOMENU
unsetopt LIST_AMBIGUOUS

setopt nocaseglob # ignore case
# setopt correct # correct spelling mistakes

# Expand aliases when pressing TAB
# zstyle ':completion:*' completer _expand_alias _complete _ignored

# Fastlane autocompletion
[ -f ~/.fastlane/completions/completion.sh ] && source ~/.fastlane/completions/completion.sh
# Do Not Track Environment Variables
[ -f ~/dotfiles/do_not_track_env_vars.sh ] && source ~/dotfiles/do_not_track_env_vars.sh

# Lots of different, nice looking completions

if type brew &>/dev/null; then
  fpath=($(brew --prefix)/share/zsh-completions $fpath)
  # If you receive "zsh compinit: insecure directories" warnings when 
  # attempting to load these completions, you may need to run these commands:
  #
  # chmod go-w '$HOMEBREW_PREFIX/share'
  # chmod -R go-w '$HOMEBREW_PREFIX/share/zsh'
fi

#-------------------------------------------------------------------------------
# Key Bindings
#-------------------------------------------------------------------------------

# Uses YAZI to conveniently navigate file system and stay in that directory when exit yazi.
# Default on exit: stay in directory where yazi was started from.
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

#-------------------------------------------------------------------------------
# Power Level 10K
#-------------------------------------------------------------------------------

# Load powerlevel10K theme
source "${HOMEBREW_DIR_PREFIX}/share/powerlevel10k/powerlevel10k.zsh-theme"
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh

#-------------------------------------------------------------------------------
# Load tools for ZSH
#-------------------------------------------------------------------------------

# rbenv
command -v rbenv > /dev/null 2>&1 && eval "$(rbenv init - zsh)"
# zoxide
command -v zoxide > /dev/null 2>&1 && eval "$(zoxide init zsh --cmd cd)"

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
  print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
    print -P "%F{33} %F{34}Installation successful.%f%b" || \
    print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

#-------------------------------------------------------------------------------
# Zinit Plugins • Completions • Aliases
#-------------------------------------------------------------------------------

zsh_plugins_official=(
  "direnv"
  "fzf"
)
for plugin in "${zsh_plugins_official[@]}"; do
  zinit snippet OMZ::plugins/$plugin/$plugin.plugin.zsh
done

zsh_plugins_external=(
  "zsh-users/zsh-syntax-highlighting"
  "TamCore/autoupdate-oh-my-zsh-plugins"
)
for plugin in "${zsh_plugins_external[@]}"; do
  zinit light $plugin
done

# Activate mise
export PATH="$PATH:$HOME/.local/share/mise/shims"
# Make mise shims available
eval "$("${HOME}"/.local/bin/mise activate zsh)"
# Activate mise completions
eval "$("${HOME}"/.local/bin/mise completion zsh)"


# Ensure compatibility tmux <-> direnv (https://github.com/direnv/direnv/issues/106)
if [ -n "$TMUX" ] && [ -n "$DIRENV_DIR" ]; then
    unset -m "DIRENV_*"  # unset env vars starting with DIRENV_
fi
eval "$(direnv hook zsh)"
