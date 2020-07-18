#!/bin/sh
sudo apt-update && sudo apt upgrade
sudo apt-get update
sudo apt install mlocate -y
sudo updatedb
sudo apt install curl ranger -y
sudo apt-get install taskwarrior -y

