#!/bin/bash


echo "Downloading mevboost  Version $1"
wget https://github.com/flashbots/mev-boost/releases/download/v$1/mev-boost_$1_linux_amd64.tar.gz -O $HOME/Downloads/mev-boost_$1_linux_amd64.tar.gz


echo "Unpacking..."
cd $HOME/Downloads/
tar xvf mev-boost_$1_linux_amd64.tar.gz

sudo systemctl stop mevboost
sudo cp mev-boost /usr/local/bin

sudo chown mevboost:mevboost /usr/local/bin/mev-boost
sudo systemctl start mevboost

rm mev-boost LICENSE README.md mev-boost_$1_linux_amd64.tar.gz
cd ~

echo "Done!"
