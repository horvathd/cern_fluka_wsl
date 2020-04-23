#!/bin/bash

# Check if the script run as root
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] The installation script requires root privileges"
    echo "        Please use: sudo ./setup_wsl.sh"
    exit 1
fi

# Check Ubuntu version
ubuntu_codename=$(lsb_release -c | awk '{print $2}')

# Set Flair repository
if [ "$ubuntu_codename" = "bionic" ]; then
    REPO="https://cern.ch/flair/download/ubuntu/18.04"
elif [ "$ubuntu_codename" = "focal" ]; then
    REPO="https://cern.ch/flair/download/ubuntu/20.04"

    echo "[ERROR] The support for Ubuntu 20.04 is not yet implemented"
    exit 1
else
    echo "[ERROR] The installation script requires Ubuntu 18.04 or 20.04"
    exit 1
fi

# Packages to install
packages="make gawk gfortran tk gnuplot-x11 python3 python3-tk python3-pil python3-pil.imagetk python3-numpy python3-scipy python3-dicom"

# Install required packages
echo "Updating package list"
apt-get update -qq
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't update pacakge list. Try again later."
    exit 1
fi

echo "Installing necessary packages"
apt-get install -y -qq $packages
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't install the necessary packages. Try again later."
    exit 1
fi

# If repository is not present
if ! grep -q "$REPO" /etc/apt/sources.list; then
    echo "Adding Flair repository"

    # Add GPG key
    wget -q -O - https://cern.ch/flair/download/ubuntu/KEY.gpg | sudo apt-key add -
    if [ ! "$?" -eq 0 ]; then
        echo "[ERROR] Couldn't add repository GPG key. Try again later."
        exit 1
    fi

    # Add repository
    add-apt-repository "deb [arch=all,amd64] $REPO  ./"
    if [ ! "$?" -eq 0 ]; then
        echo "[ERROR] Couldn't add repository. Try again later."
        exit 1
    fi
fi

echo "Installing Flair"
apt-get install -y -qq flair
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't install Flair. Try again later."
    exit 1
fi

# Set up necessary envionment variables
if [[ -z "${DISPLAY}" ]]; then
    echo "Setting up DISPLAY environmental variable"
    echo "export DISPLAY=:0" > /etc/profile.d/wsl.sh
fi

echo "Install complete"
