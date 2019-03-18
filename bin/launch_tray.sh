#!/bin/sh

(
  killall nm-applet
  killall blueman-applet
  killall flameshot
  killall kalu

  unset GDK_SCALE
  unset GDK_DPI_SCALE

  nm-applet & disown
  blueman-applet & disown
  flameshot & disown
  sleep 20 && kalu & disown
)

disown
