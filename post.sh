#!/usr/bin/env bash

sudo brew services start batt
sudo batt limit 80
sudo batt disable-charging-pre-sleep enable
sudo batt magsafe-led enable
