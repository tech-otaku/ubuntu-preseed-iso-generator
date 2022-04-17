#!/bin/bash

#############################################################################
# NAME          : example.sh
# DESCRIPTION	: Post-installation configuration script for Ubuntu Desktop
# USAGE         : [bash] ./example.sh
# AUTHOR        : A N Other
# EMAIL         : another at example dot com
#############################################################################



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# KEYBOARD LAYOUT
#

# Set keyboard layouts for English (UK, Macintosh) and English (UK)...
# ...using Gsettings
#gsettings set org.gnome.desktop.input-sources sources  "[('xkb', 'gb+mac'), ('xkb', 'gb')]"
# ...using Dconf
#dconf write /org/gnome/desktop/input-sources/sources "[('xkb', 'gb+mac'), ('xkb', 'gb')]"



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# RESTART
#

clear
read -p "Press enter to restart"
systemctl reboot