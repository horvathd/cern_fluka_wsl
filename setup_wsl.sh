#!/bin/bash

# Check if the script run as root
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] The installation script requires root privileges"
    echo "        Please use: sudo ./setup_wsl.sh"
    exit 1
fi

# Trying to determine WSL version
uname=$(uname -r)

if [ $(echo ${uname} | grep "Microsoft") ]; then
    WSL_version="1"
    echo "WSL version 1 has been detected"
elif [ $(echo ${uname} | grep "microsoft-standard") ]; then
    WSL_version="2"
    echo "WSL version 2 has been detected"
else
    WSL_version="0"
    echo "[WARNING] WSL version could not be determined. Assuming native Linux installation."
fi

# Check Ubuntu version
ubuntu_codename=$(lsb_release -c | awk '{print $2}')

# Set Flair repository
if [ "$ubuntu_codename" = "focal" ]; then
    REPO="https://cern.ch/flair/download/ubuntu/20.04"
elif [ "$ubuntu_codename" = "jammy" ]; then
    REPO="https://cern.ch/flair/download/ubuntu/22.04"

    if [ $WSL_version != "0" ]; then
        sudo add-apt-repository ppa:mozillateam/ppa

        echo '
        Package: *
        Pin: release o=LP-PPA-mozillateam
        Pin-Priority: 1001
        ' | sudo tee /etc/apt/preferences.d/mozilla-firefox

        echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
    fi
fi
else
    echo "[ERROR] The installation script requires Ubuntu 20.04 or 22.04"
    exit 1
fi

# Packages to install
packages="make gawk gfortran tk gnuplot-x11 python3 python3-tk python3-pil python3-pil.imagetk python3-numpy python3-scipy python3-matplotlib python3-dicom ttf-ancient-fonts firefox"

# Install required packages
echo "Updating package list ..."
apt-get update -qq
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't update pacakge list. Try again later."
    exit 1
fi

echo "Installing necessary packages ..."
apt-get install -y -qq $packages > /dev/null
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't install the necessary packages. Try again later."
    exit 1
fi

# If repository is not present
if ! grep -q "$REPO" /etc/apt/sources.list; then
    echo "Adding Flair repository ..."

    # Add GPG key
    sudo wget -q -O /etc/apt/trusted.gpg.d/flair.asc https://cern.ch/flair/download/ubuntu/flair.gpg
    if [ ! "$?" -eq 0 ]; then
        echo "[ERROR] Couldn't add repository GPG key. Try again later."
        exit 1
    fi

    # Add repository
    add-apt-repository "deb [arch=all,amd64] $REPO ./"
    if [ ! "$?" -eq 0 ]; then
        echo "[ERROR] Couldn't add repository. Try again later."
        exit 1
    fi
fi

echo "Installing Flair ..."
apt-get install -y -qq flair > /dev/null
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't install Flair. Try again later."
    exit 1
fi

# Set up necessary envionment variables
scriptname="/etc/profile.d/flair_wsl.sh"

if [ $WSL_version == "1" ]; then
    echo "Setting up DISPLAY environmental variable ..."
    echo "export DISPLAY=:0" > $scriptname
elif [ $WSL_version == "2" ]; then
    echo "Setting up DISPLAY environmental variable ..."
    echo "export DISPLAY=\`\grep nameserver /etc/resolv.conf | sed 's/nameserver //'\`:0" > $scriptname
fi

echo "Install complete - Please close Ubuntu to finialaze installation."
