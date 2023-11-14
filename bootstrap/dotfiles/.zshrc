# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
ZSH=${HOME}/.oh-my-zsh

# Homebrew directory prefix differentiation M1 / Intel
[[ $(uname -p) == 'arm' ]] && HOMEBREW_DIR_PREFIX="/opt/homebrew" || HOMEBREW_DIR_PREFIX="/usr/local"

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
export DEFAULT_USER=`whoami`

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
  direnv 
  bgnotify 
  zsh-autosuggestions
  fzf 
  fzf-tab
  brew
)

# User configuration

# Set locale
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

# No sorting
# zstyle ':completion:complete:*:options' sort false
# Show preview when using cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -aFh1 -g --color-scale --icons --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'exa -aFh1 -g --color-scale --icons --color=always $realpath'
# Show preview when using exa (ls)
# zstyle ':fzf-tab:complete:exa:*' fzf-preview 'bat --color always --paging never $realpath'
zstyle ':fzf-tab:complete:exa:*' fzf-preview '
  if [[ -f $realpath ]]; then 
    if command -v bat > /dev/null 2>&1; then
      bat --color always --paging never $realpath
    else
      cat $realpath
    fi    
  else 
    exa -aFh1 -g --color-scale --icons --color=always $realpath
  fi
'
#export FZF_DEFAULT_OPTS='--height 40% --layout=reverse'
#export FZF_DEFAULT_OPTS='--layout=reverse'
# Uncomment the following line to disable fuzzy completion
# export DISABLE_FZF_AUTO_COMPLETION="true"
# Uncomment the following line to disable key bindings (CTRL-T, CTRL-R, ALT-C)
# export DISABLE_FZF_KEY_BINDINGS="true"
# Uncomment to specify default command when input is tty
# export FZF_DEFAULT_COMMAND='ag'

#-------------------------------------------------------------------------------
# History
#-------------------------------------------------------------------------------

# ignore these commands
export HISTORY_IGNORE="(la|ls|ll|cd|pwd|exit|cd ..)"
# increase maximum history entry count
export HISTSIZE=500000
# The maximum number of lines that are kept in the history file.
export SAVEHIST=$HISTSIZE
# Enables fast pasting
export DISABLE_MAGIC_FUNCTIONS=true
# Ignore duplicated items
setopt HIST_IGNORE_ALL_DUPS
# Tidy up the line when it is entered into the history by removing any excess blanks that mean nothing to the shell. This can also mean that the line becomes a duplicate of a previous one even if it would not have been in its untidied form. It is smart enough not to remove blanks which are important, i.e. are quoted.
setopt HIST_REDUCE_BLANKS
# A useful trick to prevent particular entries from being recorded into a history by preceding them with at least one space.
setopt HIST_IGNORE_SPACE
# Allows appending the new history to the old
setopt APPEND_HISTORY
# Each line is added to the history in this way as it is executed
setopt INC_APPEND_HISTORY
# As each line is added, the history file is checked to see if anything was written out by another shell, and if so it is included in the history of the current shell too
setopt SHARE_HISTORY
# If you try to scroll up or down beyond the end of the history list, the shell will beep. It is on by default, so use NO_HIST_BEEP to turn it off.
setopt NO_HIST_BEEP

[ -f "$ZSH"/oh-my-zsh.sh ] && source "$ZSH"/oh-my-zsh.sh
[ -f ~/dev/scripts/imports.sh ] && source ~/dev/scripts/imports.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# export EDITOR="subl -n -w"
export EDITOR="nano"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

#-------------------------------------------------------------------------------
# Completion System
#-------------------------------------------------------------------------------

# By the following 3 options, the completion selection menu is opened with the first press of TAB
setopt AUTOLIST AUTOMENU
unsetopt LIST_AMBIGUOUS

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
# Syntax Highlighting
#-------------------------------------------------------------------------------

source "${HOMEBREW_DIR_PREFIX}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

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

# atuin
# echo 'eval "$(atuin init zsh)"' >> ~/.zshrceval "$(atuin init zsh)"

# rbenv
eval "$(rbenv init - zsh)"

# zoxide
command -v zoxide > /dev/null 2>&1 && eval "$(zoxide init zsh)"




