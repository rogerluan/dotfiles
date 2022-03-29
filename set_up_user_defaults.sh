#!/bin/bash

# TODO:
# - MagicPrefs 3 finger click mapping to middle button
# - Telegram settings
# - Which icons shows on menu bar (sound, wifi, bluetooth)
# - Toggl
# - Zoom
# - Set up the Side Bar with the right apps
# - Set up Finder side menu folders (remove tags, add all the folders)
# - Set up the gesture where drag down 3 windows to open all related windows
# - Show bluetooth on status bar
# - Show sound on status bar **ALWAYS**

################################################################################
### Configure macOS's helpful UserDefaults (aka simply `defaults`)
################################################################################

# Prerequisite:
# - Atom
# - Xcode
# - SizeUp
# - SourceTree
# - GPG Suite

set -e # Immediately rethrows exceptions
set -x # Logs every command on Terminal

################################################################################
# Script Setup                                                                 #
################################################################################

# Close any open instances of the following programs, to prevent them from
# overriding settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'
osascript -e 'tell app "Xcode" to quit'
osascript -e 'tell app "Atom" to quit'
osascript -e 'tell app "SizeUp" to quit'
osascript -e 'tell app "SourceTree" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

################################################################################
# Misc User Experience                                                         #
################################################################################

# When clicking scroll indicator, navigate to the spot that's clicked
defaults write -g AppleScrollerPagingBehavior -bool true

# Maximizes the application upon double clicking its navigation bar
defaults write -g AppleActionOnDoubleClick -string "Maximize"

# Set the macOS interface style to Dark
defaults write -g AppleInterfaceStyle -string "Dark"

# Plays sound feedback when volume is changed
defaults write -g com.apple.sound.beep.feedback -int 1

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

################################################################################
# Keyboard                                                                     #
################################################################################

# Disable automatic capitalization as it’s annoying when typing code
defaults write -g NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# Disables automatic text completion
defaults write -g NSAutomaticTextCompletionEnabled -bool false

# Set a blazingly fast keyboard repeat rate (even faster than max values via UI)
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10

# Enable press and hold for all keys. Requires a reboot to take affect.
defaults write -g ApplePressAndHoldEnabled -bool false

# Add keyboard shortcut `⌘ + option + right` to show the next tab, globally.
defaults write -g NSUserKeyEquivalents -dict-add "Show Next Tab" "@~\\U2192"

# Add keyboard shortcut `⌘ + option + left` to show the previous tab, globally.
defaults write -g NSUserKeyEquivalents -dict-add "Show Previous Tab" "@~\\U2190"

# Add keyboard shortcut `⌘ + shift + x` to strikethrough the currently selected text, globally.
defaults write -g NSUserKeyEquivalents -dict-add "Strikethrough" "@\$x"

# Add keyboard shortcut `ctrl + i` to Auto Indent
defaults write com.github.atom NSUserKeyEquivalents -dict-add "Auto Indent" "^i"

# Add keyboard shortcut `ctrl + shift + i` to Sort Selected Lines
# (requires SortingMatters https://apps.apple.com/us/app/sortingmatters/id1556795117?mt=12)
defaults write com.apple.dt.Xcode NSUserKeyEquivalents -dict-add "Sort Selected Lines" "^\$i"

################################################################################
# Spotlight                                                                    #
################################################################################

# Move the spotlight bar to the top right corner of the screen
defaults write com.apple.Spotlight lastWindowPosition -string "{{984, 950}, {680, 52}}"
defaults write com.apple.Spotlight userHasMovedWindow -bool true
# Skip showing the "learn more" tutorial
defaults write com.apple.Spotlight showedLearnMore -bool true

################################################################################
# Trackpad                                                                     #
################################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 1

defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 0
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 1

defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

# Disable the swipe to navigate using 2 fingers (because we're enabling the
# swipe to navigate using 3 fingers, which skips animations)
defaults write -g AppleEnableSwipeNavigateWithScrolls -bool false

# Set the pointer tracking speed when using a trackpad. Value ranges from 0 to 3
defaults write -g com.apple.trackpad.scaling -float 2.5

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# wvous-tl-corner: Top Left corner
# wvous-tr-corner: Top Right corner
# wvous-bl-corner: Bottom Left corner
# wvous-br-corner: Bottom Right corner

# Top right screen corner → Desktop
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

################################################################################
# Touch Bar                                                                    #
################################################################################

# Set the touch bar to be a fixed control strip
defaults write com.apple.touchbar.agent PresentationModeGlobal -string "fullControlStrip"

# Configure which controls will be shown on the strip
defaults write com.apple.controlstrip FullCustomized -array "com.apple.system.group.brightness" "com.apple.system.screen-lock" "NSTouchBarItemIdentifierFlexibleSpace" "com.apple.system.group.media" "com.apple.system.group.volume"

################################################################################
# Language & Region                                                            #
################################################################################

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write -g AppleLanguages -array "en-US" "pt-BR"
defaults write -g AppleLocale -string "en_US@currency=USD"
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleMetricUnits -bool true

# Set the default temperature unit to Celsius
defaults write -g AppleTemperatureUnit -string "Celsius"

# Set the default hour format to use the 24-hour format
defaults write -g AppleICUForce24HourTime -bool true

# Hide language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool false

################################################################################
# Power Management                                                             #
################################################################################

# Set machine sleep to X minutes while charging. Set 0 for "never"
sudo pmset -c sleep 0

# Set machine sleep to X minutes on battery. Set 0 for "never"
sudo pmset -b sleep 10

# Disable proximity wake on all scenarios. This should save some battery
sudo pmset -a proximitywake 0

# Disable power nap
sudo pmset -a powernap 0

# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

################################################################################
# Screenshots                                                                  #
################################################################################

# Create a Screenshots folder inside Pictures, if needed
mkdir -p ~/Pictures/Screenshots
# Save screenshots in the given folder
defaults write com.apple.screencapture location -string "~/Pictures/Screenshots"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Set shadows in screenshots as disabled
defaults write com.apple.screencapture disable-shadow -bool false

################################################################################
# Finder                                                                       #
################################################################################

# Set Desktop as the default location for new Finder windows
# For Desktop, use `PfDe` and `file://${HOME}/Desktop/`
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfLo"
# Create a Projects folder inside Documents, if needed
mkdir -p ~/Documents/Projects
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Documents/Projects/"

# Whether icons for HDD, servers, and removable media should show on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: hide path bar
defaults write com.apple.finder ShowPathbar -bool false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 128" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
# /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

################################################################################
# Dock                                                                         #
################################################################################

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0
# Customize the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -float 0.4

# Set the icon size of Dock items
defaults write com.apple.dock tilesize -int 62

# Set the large size of Dock items when over magnification effect
defaults write com.apple.dock largesize -float 76

# Enable magnification of the Dock
defaults write com.apple.dock magnification -bool true

# Enable the animation to minimize the application to the app icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true

# Changes the orientation of the Dock
defaults write com.apple.dock orientation -string "left"

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Don’t automatically rearrange Spaces based on most recent use, as this shuffles the Spaces unexpectedly
defaults write com.apple.dock mru-spaces -bool false

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

################################################################################
# Safari                                                                       #
################################################################################

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"

# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

################################################################################
# Terminal                                                                     #
################################################################################

# Enable Secure Keyboard Entry in Terminal.app. Secure keyboard entry can
# prevent other apps on your computer or the network from detecting and
# recording what you type in Terminal.
# See: https://security.stackexchange.com/a/47786/8918
defaults write com.apple.Terminal SecureKeyboardEntry -bool true

################################################################################
# TextEdit                                                                     #
################################################################################

# Set the author for the produced documents
defaults write com.apple.TextEdit author -string "Roger Oba"

# Whether TextEdit will produce rich text documents
defaults write com.apple.TextEdit RichText -int 0

# Whether TextEdit will use smart copy and paste
defaults write com.apple.TextEdit SmartCopyPaste -bool false

################################################################################
# App Store                                                                    #
################################################################################

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Turn off app auto-update
defaults write com.apple.commerce AutoUpdate -bool false

################################################################################
# Photos                                                                       #
################################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

################################################################################
# SizeUp                                                                       #
################################################################################

# Hide the icon from menu bar
defaults write com.irradiatedsoftware.SizeUp MenuEnabled -bool false

# Don’t show the preferences window on next start
defaults write com.irradiatedsoftware.SizeUp ShowPrefsOnNextStart -bool false

################################################################################
# Xcode                                                                        #
################################################################################

# Automatically trim trailing whitespaces, including whitespace-only lines
defaults write com.apple.dt.Xcode DVTTextEditorTrimWhitespaceOnlyLines -bool YES

# Don't indent Swift switch case
defaults write com.apple.dt.Xcode DVTTextIndentCase -bool FALSE

# Indent text on paste
defaults write com.apple.dt.Xcode DVTTextIndentOnPaste -bool YES

# Set editor overscroll to small
defaults write com.apple.dt.Xcode DVTTextOverscrollAmount -float 0.25

# Hide authors panel
defaults write com.apple.dt.Xcode DVTTextShowAuthors -bool FALSE

# Hide minimap panel
defaults write com.apple.dt.Xcode DVTTextShowMinimap -bool FALSE

# Show all build steps on activity log
defaults write com.apple.dt.Xcode IDEActivityLogShowsAllBuildSteps -bool YES

# Analyzer results on activity log
defaults write com.apple.dt.Xcode IDEActivityLogShowsAnalyzerResults -bool YES

# Show errors on activity log
defaults write com.apple.dt.Xcode IDEActivityLogShowsErrors -bool YES

# Show warnings on activity log
defaults write com.apple.dt.Xcode IDEActivityLogShowsWarnings -bool YES

# Command-click jumps to definition
defaults write com.apple.dt.Xcode IDECommandClickOnCodeAction -int 1

# Show Indexing numeric progress
defaults write com.apple.dt.Xcode IDEIndexerActivityShowNumericProgress -bool YES

# Enable project build time
defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool YES

defaults write com.apple.dt.Xcode IDEEditorCoordinatorTarget_DoubleClick -string "SameAsClick"
defaults write com.apple.dt.Xcode IDEEditorNavigationStyle_DefaultsKey -string "IDEEditorNavigationStyle_OpenInPlace"
defaults write com.apple.dt.Xcode IDEIssueNavigatorDetailLevel -int 4
defaults write com.apple.dt.Xcode IDESearchNavigatorDetailLevel -int 4

################################################################################
# SourceTree                                                                   #
################################################################################

# Preferred dimensions
defaults write com.torusknot.SourceTreeNotMAS SidebarWidth_ -int 140
defaults write com.torusknot.SourceTreeNotMAS commitPaneHeight -int 242

# Also show diff for *.lock files
defaults write com.torusknot.SourceTreeNotMAS diffSkipFilePatterns -string "*.pbxuser, *.xcuserstate, Cartfile.resolved"

# Sets the GPG binary location
defaults write com.torusknot.SourceTreeNotMAS gpgProgram -string "/usr/local/MacGPG2/bin"

defaults write com.torusknot.SourceTreeNotMAS fileStatusStagingViewMode -int 1
defaults write com.torusknot.SourceTreeNotMAS fileStatusViewMode2 -int 0
# Skip tutorials
defaults write com.torusknot.SourceTreeNotMAS showStagingTip -bool false
defaults write com.torusknot.SourceTreeNotMAS DidShowGettingStarted -bool true
# Enable Dark Mode
defaults write com.torusknot.SourceTreeNotMAS currentTheme -int 1
# Don't restore windows on startup
defaults write com.torusknot.SourceTreeNotMAS windowRestorationMethod -int 1
# Use fixed-width font for commit messages
defaults write com.torusknot.SourceTreeNotMAS useFixedWithCommitFont -bool true
# Display column guide in commit message at character: 50
defaults write com.torusknot.SourceTreeNotMAS commitColumnGuideWidth -int 50
# Keep bookmarks closed on startup
defaults write com.torusknot.SourceTreeNotMAS bookmarksClosedOnStartup -bool true
# Ask to bookmark upon opening new repo
defaults write com.torusknot.SourceTreeNotMAS bookmarksWindowOpen -bool false

################################################################################
# Telegram                                                                     #
################################################################################

defaults write ru.keepcoder.Telegram NSNavLastRootDirectory -string "~/Downloads"
defaults write ru.keepcoder.Telegram kForceTouchAction -int 1
defaults write ru.keepcoder.Telegram kAutomaticConvertEmojiesType2 -bool true

################################################################################
# MagicPrefs                                                                   #
################################################################################

defaults write com.vladalexa.MagicPrefs noMenubarIcon -bool true

################################################################################
# Finish                                                                       #
################################################################################

echo "Done. Please reboot your system for the changes to take effect."
