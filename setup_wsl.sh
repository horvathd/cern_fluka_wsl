#!/bin/bash

logfile="setup_wsl.out"

# Check if the script run as root
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] The installation script requires root privileges"
    echo "        Please use: sudo ./setup_wsl.sh"
    exit 1
else
    echo "Setting up the system for FLUKA.CERN and installing Flair"
    echo ""
fi

# Trying to determine WSL version
uname=$(uname -r)

if [ $(echo ${uname} | grep -i "microsoft") ]; then
    WSL="1"
else
    WSL="0"
    echo "   [WARNING] WSL version could not be determined. Assuming native Linux installation."
fi

# Check Ubuntu version
ubuntu_codename=$(lsb_release -sc 2> /dev/null)

# Set repositories
if [[ "$ubuntu_codename" != "jammy" && "$ubuntu_codename" != "noble" && "$ubuntu_codename" != "resolute" ]]; then
    echo "   [ERROR] The installation script requires Ubuntu 22.04, 24.04 and 26.04"
    exit 1
fi

# Setting up Flair repository
echo " - Adding Flair repository"

# Add GPG key
wget -O /etc/apt/trusted.gpg.d/flair.asc http://cern.ch/flair/download/ubuntu/flair.gpg 2>> $logfile
if [ ! "$?" -eq 0 ]; then
    echo "   [ERROR] Couldn't add GPG key for Flair repository. Try again later."
    exit 1
fi

# Add repository
ubuntu_number=$(lsb_release -sr 2> /dev/null)
REPO=https://cern.ch/flair/download/ubuntu/"$ubuntu_number"

add-apt-repository -y "deb [arch=all,amd64] $REPO ./" >> $logfile 2>&1
if [ ! "$?" -eq 0 ]; then
    echo "   [ERROR] Couldn't add Flair repository. Try again later."
    exit 1
fi

# Install package
echo " - Updating package list"
apt-get update >> $logfile 2>&1
if [ ! "$?" -eq 0 ]; then
    echo "   [ERROR] Couldn't update pacakge list. Try again later."
    exit 1
fi

echo " - Installing packages"
xargs -a package.list apt-get install -y >> $logfile 2>&1
if [ ! "$?" -eq 0 ]; then
    echo "   [ERROR] Couldn't install the necessary packages. Try again later."
    exit 1
fi
if [ $WSL != "0" ]; then
    mkdir -p /root/.config
    xdg-mime default /usr/share/applications/firefox.desktop text/html
fi

# Copying script for environment variables
echo " - Setting up environment variables"
cp "flair_wsl.sh" /etc/profile.d/
if [ ! "$?" -eq 0 ]; then
    echo "   [ERROR] Couldn't set up environment variables. Try again later."
    exit 1
fi

echo ""
echo "Setup complete. Please close and reopen Ubuntu to apply the changes."
