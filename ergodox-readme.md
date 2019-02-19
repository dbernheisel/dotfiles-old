# Flashing Procedure

1. Install dfu-util `sudo apt install dfu-util`.
1. Make sure you have a configuration ready. Visit
   https://input.club/configurator-ergodox/ to download your configuration (lts
   is a good idea).
1. Download/extract into folder.
1. You will need another keyboard handy.
1. Press the flash button on one keyboard half.
1. run `sudo dfu-util -D left_kiibohd.dfu.bin`
1. Press the flash button on the other keyboard half.
1. run `sudo dfu-util -D right_kiibohd.dfu.bin`

# [Wiki](https://kiibohd.github.io/wiki/#/Quickstart)

The offline configurator (at this time 20190219) had a bug in it that made it
useless. Using the online configurator and the LTS release seemed to work
without issue.
