#!/bin/sh
xrandr --output HDMI-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal --output DVI-D-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DP-0 --off --output DP-1 --off
nvidia-settings --assign CurrentMetaMode="HDMI-0: nvidia-auto-select +1920+0 { ForceCompositionPipeline=On}, DVI-D-0: nvidia-auto-select +0+0 {ForceCompositionPipeline=On}"
