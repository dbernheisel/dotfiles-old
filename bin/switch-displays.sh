#!/bin/sh
# DISPLAY_SCRIPTS=(~/.screenlayout/*.sh)

INTERNAL=eDP1
EXTERNAL1=DP1
EXTERNAL2=DP2
LOWER_DPI=96
HIGHER_DPI=192

source ~/dotfiles/bin/monitor-detection.sh

function lower_dpi() {
  echo "Lowering DPI"
  xrdb -merge ~/dotfiles/Xresources-lower
  xrandr --dpi $LOWER_DPI
}

function higher_dpi() {
  echo "Raising DPI"
  xrdb -merge ~/dotfiles/Xresources
  xrandr --dpi $HIGHER_DPI
}

if is_active $EXTERNAL2 && is_active $INTERNAL; then
  echo "Turning on Ultrawide only - Port 2"
  ~/.screenlayout/ultrawide2.sh
  lower_dpi
elif is_active $EXTERNAL1 && is_active $INTERNAL; then
  echo "Turning on Ultrawide only - Port 1"
  ~/.screenlayout/ultrawide1.sh
  lower_dpi
elif is_connected $EXTERNAL1 && is_active $INTERNAL; then
  echo "Turning on Dual screen - Ultrawide - Port 1"
  ~/.screenlayout/dual1.sh
  higher_dpi
elif is_connected $EXTERNAL2 && is_active $INTERNAL; then
  echo "Turning on Dual screen - Ultrawide - Port 2"
  ~/.screenlayout/dual2.sh
  higher_dpi
elif is_active $EXTERNAL1 && ! is_active $INTERNAL; then
  echo "Turning on Dual screen - Internal - Port 1"
  ~/.screenlayout/dual1.sh
  higher_dpi
elif is_active $EXTERNAL2 && ! is_active $INTERNAL; then
  echo "Turning on Dual screen - Internal - Port 2"
  ~/.screenlayout/dual2.sh
  higher_dpi
else
  echo "Turning on internal screen"
  ~/.screenlayout/internal.sh
  higher_dpi
fi

sleep 2
~/dotfiles/bin/launch_polybar.sh
