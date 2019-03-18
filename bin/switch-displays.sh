#!/bin/sh
# DISPLAY_SCRIPTS=(~/.screenlayout/*.sh)

INTERNAL=eDP1
EXTERNAL1=DP1
EXTERNAL2=DP2
LOWER_DPI=96
HIGHER_DPI=192

function is_connected() {
  local MON
  MON=$1; shift

  echo "checking connected $MON"
  xrandr -q | grep -w "connected" | grep -w $MON &> /dev/null
}

function is_active() {
  local MON
  MON=$1; shift

  if is_connected $MON; then
    echo "checking active $MON"
    xrandr -q | grep -w $MON | awk '{print $4}' | grep -P '\d' &> /dev/null
  else
    false
  fi
}

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

if is_active $EXTERNAL1 && is_active $INTERNAL; then
  echo "Turning on Ultrawide only"
  ~/.screenlayout/ultrawide1.sh
  lower_dpi
elif is_active $EXTERNAL2 && is_active $INTERNAL; then
  echo "Turning on Ultrawide only"
  ~/.screenlayout/ultrawide2.sh
  lower_dpi
elif is_connected $EXTERNAL1 && is_active $INTERNAL; then
  echo "Turning on Dual screen - Ultrawide"
  ~/.screenlayout/dual1.sh
  higher_dpi
elif is_connected $EXTERNAL2 && is_active $INTERNAL; then
  echo "Turning on Dual screen - Ultrawide"
  ~/.screenlayout/dual2.sh
  higher_dpi
elif is_active $EXTERNAL1 && ! is_active $INTERNAL; then
  echo "Turning on Dual screen - Internal"
  ~/.screenlayout/dual1.sh
  higher_dpi
elif is_active $EXTERNAL2 && ! is_active $INTERNAL; then
  echo "Turning on Dual screen - Internal"
  ~/.screenlayout/dual2.sh
  higher_dpi
else
  echo "Turning on internal screen"
  ~/.screenlayout/internal.sh
  higher_dpi
fi

sleep 2
~/dotfiles/bin/launch_polybar.sh
