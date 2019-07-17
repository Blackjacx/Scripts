# Path to your oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh

# Set the locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="gnzh"
ZSH_THEME="Spaceship"
#ZSH_THEME="agnoster"
#ZSH_THEME="superjarin"
#ZSH_THEME="duellj"
#ZSH_THEME="random"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

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

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git-extras sublime git gem pod brew bundler common-aliases httpie colored-man-pages dotenv)

# User configuration

# Set user gem path to avoid the need of sudo
export GEM_HOME=$HOME/.gem
# Set the path using specified order
export PATH="$GEM_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki:/opt/local/libexec/gnubin"

### History settings
### ignore these commands
export HISTORY_IGNORE="(la|ls|ll|cd|pwd|exit|cd ..)"
### increase history to the last 10000 commands
export HISTSIZE=10000
### The maximum number of lines that are kept in the history file.
export SAVEHIST=$HISTSIZE
### Ignore duplicated
setopt hist_ignore_all_dups
### A useful trick to prevent particular entries from being recorded into a history by preceding them with at least one space.
setopt hist_ignore_space
### Allows appending the new history to the old
setopt APPEND_HISTORY
### Each line is added to the history in this way as it is executed
setopt INC_APPEND_HISTORY
### As each line is added, the history file is checked to see if anything was written out by another shell, and if so it is included in the history of the current shell too
setopt SHARE_HISTORY

[ -f "$ZSH"/oh-my-zsh.sh ] && source $ZSH/oh-my-zsh.sh
[ -f "${HOME}"/dev/scripts/imports.sh ] && source "${HOME}"/dev/scripts/imports.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='subl -n -w'
else
  export EDITOR='subl -n -w'  
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias cddb="cd ${HOME}/dev/projects/db/beiwagen"
alias opendoc='cd ${HOME}/dev/projects/db/api-docs; git reset --hard; git checkout master; git pull; open passenger-api.html; cd -'
alias cdtmp='cd "$(mktemp -d)"'
alias git=hub
alias ddd="rm -rf ${HOME}/Library/Developer/Xcode/DerivedData"
alias glogd="git log --oneline --decorate --graph develop.."
alias brsc="brew search --casks"
alias sss='xcrun simctl io booted screenshot ${HOME}/Desktop/screenshots/`date +%Y-%m-%d.%H:%M:%S`.png'

# enble fastlane autocompletion
[ -f ~/.fastlane/completions/completion.sh ] && source ~/.fastlane/completions/completion.sh

# suggestion after last Homebrew update
fpath=(/usr/local/share/zsh-completions $fpath)

# init rbenv ruby
eval "$(rbenv init -)"

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh