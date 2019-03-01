if type "xrandr" &>/dev/null; then
  for m in $(xrandr -q | grep -w "connected" | cut -d" " -f1); do
    MONITOR=$m polybar --reload top &
  done
else
  polybar --reload top &
fi
