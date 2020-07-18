#!/bin/sh
sudo apt install steam -y
sudo dpkg --add-architecture i386
sudo add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main'
sudo apt update
sudo apt install --install-recommends winehq-stable -y
sudo add-apt-repository ppa:lutris-steam/lutris --force-yes
sudo apt-get update
sudo apt-get install lutris -y
sudo apt install gamemode -y
sudo apt-get install appmenu-gtk2-module appmenu-gtk3-module -y

