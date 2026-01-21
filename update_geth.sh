#!/bin/bash

# Define the URL of the downloads page
url="https://geth.ethereum.org/downloads"

# Define the download destination
destination_dir="$HOME/Downloads"

# Ensure the Downloads directory exists
if [ ! -d "$destination_dir" ]; then
  echo "Downloads directory does not exist, creating it."
  mkdir -p "$destination_dir"
fi

# Use curl to fetch the page content and grep to find the Linux link
download_link=$(curl -s $url | grep -oP 'https://gethstore.blob.core.windows.net/builds/geth-linux-amd64-\d+\.\d+\.\d+-\w+\.tar\.gz' | head -1)

# Check if we found a download link
if [ -z "$download_link" ]; then
  echo "Download link for Linux version not found."
  exit 1
fi

# Extract filename from the download link for later use
filename=$(basename "$download_link" .tar.gz)

# Download the file using wget
echo "Downloading Geth from $download_link"
wget -O "$destination_dir/$filename.tar.gz" "$download_link"

# Extract the tar.gz file into the Downloads folder
echo "Extracting the Geth tarball..."
tar -xzf "$destination_dir/$filename.tar.gz" -C "$destination_dir"

# Navigate into the extracted folder
cd "$destination_dir/$filename"

# Stop the geth service
echo "Stopping Geth service..."
sudo systemctl stop geth

# Copy the Geth binary to /usr/local/bin
echo "Copying Geth binary to /usr/local/bin..."
sudo cp geth /usr/local/bin

# Start the geth service again
echo "Starting Geth service..."
sudo systemctl start geth

# Navigate back to the Downloads folder
cd ..

# Clean up by removing the tarball and the extracted folder
echo "Cleaning up downloaded files..."
rm -f "$destination_dir/$filename.tar.gz"
rm -rf "$destination_dir/$filename"

# Return to home directory
cd ~

echo "Geth update complete!"
