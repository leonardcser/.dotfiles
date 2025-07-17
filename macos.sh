#!/usr/bin/env bash

set -xe

# SAFARI
# Show full URL in Safari
defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true"
killall Safari

# FINDER
# Show extensions
defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"
# Show hidden files
defaults write com.apple.finder "AppleShowAllFiles" -bool "true"
# Show path bar
defaults write com.apple.finder "ShowPathbar" -bool "true"
# Search the current folder by default
defaults write com.apple.finder "FXDefaultSearchScope" -string "SCcf"
# Delete items in Trash after 30 days
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true"
# Hide rename extension warning
defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"
killall Finder


# DESKTOP
# Hide elements on desktop
defaults write com.apple.finder "CreateDesktop" -bool "false"
killall Finder

# KEYBOARD
# Repeat keys
defaults write NSGlobalDomain "ApplePressAndHoldEnabled" -bool "false"
# Focus native UI elements with Tab and shift-Tab
defaults write NSGlobalDomain AppleKeyboardUIMode -int "2"
# Key repeat rate
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 1

# MISSION CONTROL & DOCK
# Do not rearrange spaces automatically
defaults write com.apple.dock "mru-spaces" -bool "false"
# Group windows by application
defaults write com.apple.dock "expose-group-apps" -bool "true"
# Dock customization
defaults write com.apple.dock tilesize -int 47
defaults write com.apple.dock largesize -int 16
defaults write com.apple.dock magnification -bool "false"
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide -bool true
# "Disable" dock
defaults write com.apple.dock "autohide-delay" -float 1000
killall Dock

# SECURITY
# Enable firewall
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1
# Enable stealth mode
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1

# MISC
# Disable siri
defaults write com.apple.assistant.support "Assistant Enabled" -boolean false
# Allow to drag windows from anywhere by holding ctrl+cmd (not working)
defaults write -g NSWindowShouldDragOnGesture -bool true
# Set screnshot location to ~/Downloads
defaults write com.apple.screencapture location "~/Downloads" && killall SystemUIServer
# Set refresh rate to 2s
defaults write com.apple.ActivityMonitor "UpdatePeriod" -int "2" && killall Activity\ Monitor

sudo shutdown -r now
