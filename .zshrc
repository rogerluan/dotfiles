# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Format to display history timestamps
# See 'man strftime' for details.
HIST_STAMPS="%Y/%m/%d %k:%M"

# oh-my-zsh seems to enable this by default, not desired for
# workflow of controlling terminal title.
DISABLE_AUTO_TITLE="true"

# Plugins

BUNDLED_COMMANDS=(
  rubocop
  fastlane
)

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  bundler
  git
  pod
  pyenv
  rails
  z
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Fixes a warning when initializing zsh that can be safely silented.
# See https://github.com/ohmyzsh/ohmyzsh/issues/6835#issuecomment-390216875
ZSH_DISABLE_COMPFIX=true

if [ -f $ZSH/oh-my-zsh.sh ]; then
  source $ZSH/oh-my-zsh.sh
fi

################################################################################
# Exports
################################################################################

source "$HOME/.exports"
source "$HOME/.paths"

################################################################################
# User configuration
################################################################################

# Navigate to Projects folder if trying to open a new window under $HOME (which
# is the default folder). This works alongside "New tabs open with: Same Working
# Directory" behavior.
if [[ $PWD == $HOME ]]; then
  cd $HOME/Documents/Projects
fi

# Run Powerline Shell
function powerline_precmd() {
  if which powerline-shell > /dev/null; then
    PS1="$(powerline-shell --shell zsh $?)"
  fi
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

if [ "$TERM" != "linux" ]; then
  install_powerline_precmd
fi

# Initialize rbenv if it's already installed
if which rbenv > /dev/null; then
  eval "$(rbenv init -)"
fi

# Initialize pyenv if it's already installed
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# https://zsh.sourceforge.io/Doc/Release/Options.html#index-NOMATCH
# https://thoughtbot.com/blog/how-to-use-arguments-in-a-rake-task
if which unsetopt > /dev/null; then
  unsetopt nomatch
fi

# Init jenv if it's already installed
if which jenv > /dev/null; then
  eval "$(jenv init -)"
fi

# Mise - https://mise.jdx.dev
if which ~/.local/bin/mise > /dev/null; then
  eval "$(~/.local/bin/mise activate zsh)"
fi

# Set up fnm
# eval "$(fnm env --use-on-cd)"

################################################################################
# Aliases
################################################################################

source "$HOME/.aliases"

################################################################################
# Secrets
################################################################################

SECRETS_FILE="$HOME/.secrets"
if [ -f $SECRETS_FILE ]; then
  source $SECRETS_FILE
else
  echo "Warning: '$SECRETS_FILE' doesn't exist yet so it wasn't sourced."
fi
