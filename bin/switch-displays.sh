#!/bin/sh
# DISPLAY_SCRIPTS=(~/.screenlayout/*.sh)

function is_connected() {
  local MON
  MON=$1; shift
  echo "checking connected $MON"
  xrandr -q | grep -w "connected" | grep $MON &> /dev/null
}

function is_active() {
  local MON
  local REZ
  MON=$1; shift
  REZ=$1

  if is_connected $MON; then
    echo "checking active $MON $REZ"
    xrandr -q | grep $MON | grep $REZ &> /dev/null
  else
    false
  fi
}


function lower_dpi() {
  xrdb -merge ~/dotfiles/Xresources-lower
  xrandr --dpi 96
}

function higher_dpi() {
  xrdb -merge ~/dotfiles/Xresources
  xrandr --dpi 192
}

INTERNAL=eDP1
EXTERNAL=DP2

if is_active $EXTERNAL 1600 && is_active $INTERNAL 2160; then
  echo "Turning on Ultrawide"
  ~/.screenlayout/ultrawide.sh
  echo "Lowering DPI"
  lower_dpi
elif is_connected $EXTERNAL 1600 && is_active $INTERNAL 2160; then
  echo "Turning on Dual screen"
  ~/.screenlayout/dual.sh
  higher_dpi
elif is_active $EXTERNAL 1600 && ! is_active $INTERNAL 2160; then
  echo "Turning on Dual screen"
  ~/.screenlayout/dual.sh
  higher_dpi
else
  echo "Turning on internal screen"
  ~/.screenlayout/internal.sh
  higher_dpi
fi

sleep 2
~/dotfiles/bin/launch_polybar.sh
