# .zprofile — sourced for LOGIN shells, AFTER the system /etc/zprofile.
#
# macOS's /etc/zprofile runs `path_helper`, which REBUILDS $PATH and moves the
# system dirs (/usr/bin, /bin, …) to the FRONT — burying our tool dirs (rbenv
# shims, etc.) behind them. For an INTERACTIVE login shell that's harmless,
# because .zshrc re-sources .paths afterward and puts our dirs back in front.
#
# But a LOGIN, NON-interactive shell — e.g. the `zsh -lc '…'` that Paseo / Codex
# (and many tools) spawn to run a command — runs path_helper and then NEVER
# sources .zshrc, so it would fall back to macOS system Ruby instead of the
# rbenv shims. Re-sourcing .paths here restores the correct PATH order for that
# case. (Non-login shells don't run path_helper, so .zshenv already suffices.)
#
# We also source .exports here so a login, non-interactive shell gets the
# exported env (JAVA_HOME, EDITOR, PYENV_ROOT, …) it would otherwise miss by
# skipping .zshrc. Kept in .zprofile (login) rather than .zshenv so the one-off
# `$(/usr/libexec/java_home)` cost isn't paid by every non-login script.
if [ -f "$HOME/.exports" ]; then
  source "$HOME/.exports"
fi

if [ -f "$HOME/.paths" ]; then
  source "$HOME/.paths"
fi
