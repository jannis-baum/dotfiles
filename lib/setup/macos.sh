#!/bin/sh

# see https://mths.be/macos

# close any open system preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# ask for the administrator password upfront
sudo -v
# keep-alive: update existing `sudo` time stamp until script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# use touch-id for sudo
sed "s/^#auth/auth/" /etc/pam.d/sudo_local.template | sudo tee /etc/pam.d/sudo_local

# --------------------------------------------------------------------------
# UI -----------------------------------------------------------------------

# disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# set highlight color to pink
defaults write NSGlobalDomain AppleHighlightColor -string "1.000000 0.749020 0.823529"

# expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true


# --------------------------------------------------------------------------
# DOCK, FINDER, DASHBOARD, MENUBAR -----------------------------------------

# avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# disable dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# don't show dashboard as a space
defaults write com.apple.dock dashboard-in-overlay -bool true

# remove the auto-hiding dock delay
defaults write com.apple.dock autohide-delay -float 0
# remove the animation when hiding/showing the dock
defaults write com.apple.dock autohide-time-modifier -float 0
# automatically hide and show the dock
defaults write com.apple.dock autohide -bool true
# don’t show recent applications in dock
defaults write com.apple.dock show-recents -bool false

# automatically hide and show the menu bar
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# disable shadow in window screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# show hidden files in finder
defaults write com.apple.finder AppleShowAllFiles -bool true
# disable desktop
defaults write com.apple.finder CreateDesktop false


# --------------------------------------------------------------------------
# IO -----------------------------------------------------------------------

# mouse/trackpad
# enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# correct scrolling direction
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# keyboard
# fast key hold repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
# disable auto capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
# disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# disable automatic period substitution
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
# disable smart quotes
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false


# --------------------------------------------------------------------------
# SAFARI -------------------------------------------------------------------

# privacy: don't send search queries to apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# disable plug-ins
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# disable java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

# block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# enable "do not track"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true
