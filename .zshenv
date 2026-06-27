# Make paths and secrets available to non-interactive shells

if [ -f "$HOME/.paths" ]; then
  source "$HOME/.paths"
fi

if [ -f "$HOME/.secrets" ]; then
  source "$HOME/.secrets"
fi
