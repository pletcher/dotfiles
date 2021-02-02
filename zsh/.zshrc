# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="common"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "norm" "pygmalion" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

COMPLETION_WAITING_DOTS="true"

DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  lein
  zsh-completions
  zsh-syntax-highlighting
)
autoload -U compinit && compinit

fpath=(/share/zsh/site-functions $fpath)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

export EDITOR='nvim'

alias vim=nvim

ulimit -n 200000
ulimit -u 2048

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

function source_if_exists() {
	if [[ -f $1 && -r $1 ]]; then
		source $1
	fi
}

source_if_exists "$HOME/.profile"
source_if_exists "$HOME/.zshenv"
source_if_exists "$HOME/.fzf.zsh"
source_if_exists "$HOME/.iterm2_shell_integration.zsh"

function emc() {
	emacsclient -c -a '' $1
}

function light() {
  pbpaste | highlight --syntax=js --font-size 24 --font Iosevka --style solarized-light -O rtf | pbcopy
}

function mmv() {
  mkdir -p -- "$argv[-1]"
  mv "$@"
}

function md2docx() {
  pandoc -d markdown -i $1 -o $(date +%Y-%m-%d)_${1/%.md/.docx}
}

function compile_md() {
  pandoc --filter pandoc-citeproc \
    -i $1 -V fontsize=12pt -V mainfont="CMU Serif" \
    --pdf-engine=xelatex -o $(date +%Y-%m-%d)_${1/%.md/.pdf}
  md2docx $1
}

function org2docx() {
  pandoc -d org -i $1 -o $(date +%Y-%m-%d)_${1/%.org/.docx}
}

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)"

if [ -x "$(command -v rbenv)" ]; then
	eval "$(rbenv init -)"
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

export PATH="$HOME/.n/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
