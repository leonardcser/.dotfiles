#!/usr/bin/env bash

# "Disable" dock
defaults write com.apple.dock autohide-delay -float 1000; killall Dock
# Allow to drag windows from anywhere by holding ctrl+cmd (not working)
defaults write -g NSWindowShouldDragOnGesture -bool true

# NPM
npm install -g @fsouza/prettierd

# Batt
sudo brew services start batt
sudo batt limit 80
sudo batt disable-charging-pre-sleep enable
sudo batt magsafe-led enable
