#!/bin/bash

# Capture the current Teku version from systemctl status
current_version=$(sudo systemctl status teku | grep -oP 'teku-\K[0-9.]+' | head -n 1)

echo "Current Teku Version: $current_version"
config_file="/etc/systemd/system/teku.service"

sed -i "s/--validators-graffiti=\"teku\/v$current_version\"/--validators-graffiti=\"teku\/v$1\"/g" "$config_file"

# Print a message to confirm the update
echo "Replaced Teku version $current_version with $1 in the config file."

echo "Downloading Teku Version $1"
wget https://artifacts.consensys.net/public/teku/raw/names/teku.tar.gz/versions/$1/teku-$1.tar.gz -O $HOME/Downloads/teku-$1.tar.gz

echo "Unpacking..."
cd Downloads/
tar xvf teku-$1.tar.gz

echo "Stop teku..."
sudo systemctl stop teku

echo "Remove old files in local directory..."
sudo rm -r /usr/local/bin/teku

echo "Copy new files in local directory..."
sudo cp -a teku-$1 /usr/local/bin/teku

echo "Load new configurations and start teku..."
sudo systemctl daemon-reload
sudo systemctl start teku

echo "Clean up download files..."
sudo rm teku-$1.tar.gz
sudo rm -r teku-$1
cd ~

echo "Done!"
