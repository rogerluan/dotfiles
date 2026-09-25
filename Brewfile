# Taps
#
# Removed, and why — all four used to fail on a fresh machine:
#   homebrew/bundle        deprecated & emptied; `brew bundle` is built in now.
#   robotsandpencils/made  repo is gone (the project moved to XcodesOrg), so
#                          tapping it failed and took `xcodes` down with it.
#                          `xcodes` now ships in homebrew-core.
#   heroku/brew            untrusted-tap errors; `heroku` is in homebrew-core.
# dopplerhq/cli is kept because doppler is only distributed there — it needs
# `brew trust --tap dopplerhq/cli`, which set_up_dependencies.sh runs first.
tap "dopplerhq/cli"

brew "aria2" # Download utility (enables faster Xcode downloads)
brew "bfg" # Remove large files or passwords from Git history like git-filter-branch
brew "cmake" # Cross-platform make
brew "docker" # You know what it is
brew "fnm" # Fast Node Manager (Node version manager) — https://github.com/Schniz/fnm
brew "gh" # GitHub command-line tool
brew "gnupg"
brew "heroku" # https://devcenter.heroku.com/articles/heroku-cli
brew "hub" # https://hub.github.com
brew "make" # https://www.gnu.org/software/make/manual/make.html
brew "markdownlint-cli" # https://github.com/igorshubovych/markdownlint-cli
brew "pipenv" # Python dependency management tool
brew "postgresql@15" # PostgreSQL
brew "pyenv" # https://github.com/pyenv/pyenv
brew "rbenv" # https://github.com/rbenv/rbenv
brew "ruby-build" # https://github.com/rbenv/ruby-build
brew "swiftformat" # https://github.com/nicklockwood/SwiftFormat
brew "typos-cli" # https://github.com/crate-ci/typos
brew "xcbeautify" # https://github.com/tuist/xcbeautify
brew "xcodes" # https://github.com/XcodesOrg/xcodes
cask "asset-catalog-tinkerer" # https://github.com/insidegui/AssetCatalogTinkerer
cask "dopplerhq/cli/doppler" # https://www.doppler.com/ — distributed as a cask now, not a formula
cask "iterm2" # Terminal replacement (configured via Terminal/Solarized Dark.json dynamic profile)
cask "middleclick" # Utility to enable middle click on trackpads
# cask "tinypng4mac" # https://github.com/kyleduo/TinyPNG4Mac — disabled upstream
# on 2026-09-01 for failing the macOS Gatekeeper check. Install manually if needed.
