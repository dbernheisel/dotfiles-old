#!/bin/sh

killall polybar

while pgrep -u $UID -x polybar > /dev/null; do sleep 0.5; done

if type "xrandr" &>/dev/null; then
  for m in $(xrandr -q | grep -w "connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top &
  done
else
  polybar --reload top &
fi

disown
