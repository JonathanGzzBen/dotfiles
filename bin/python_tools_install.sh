#!/bin/sh
sudo apt-get update
curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
python3 get-pip.py
rm get-pip.py
sudo apt-get install python3-venv

