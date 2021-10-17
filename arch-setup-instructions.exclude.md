# Instructions for Arch setup

- Create a file ~/.Xkbmap and add "-option caps:escape"

## LightDM configuration

- Install LightDM and lightdm-slick-greeter.

- To have custom image background in greeter:

  - Copy image to `/usr/share/backgrounds/`
  - Set the path to the image on `/etc/lightdm/slick-greeter.conf`

- To configure resolution:

  - Create script to set resolution and save it in `/usr/share/`
  - Give the script read/execute permissions with `chmod a+rx`
  - In `/etc/lightdm/lightdm.conf`, set `display-setup-script=/usr/share/lightdmrandr.sh`, substituting with the name of previously created script.
  - An example of display configuration script is on this repository: `bin/set_display_configuration.sh`
