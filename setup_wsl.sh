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
else
    echo "[ERROR] The installation script requires Ubuntu 18.04 or 20.04"
    exit 1
fi

# Packages to install
packages="make gawk gfortran tk gnuplot-x11 python3 python3-tk python3-pil python3-pil.imagetk python3-numpy python3-scipy python3-matplotlib python3-dicom ttf-ancient-fonts"

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
    wget -q -O - https://cern.ch/flair/download/ubuntu/KEY.gpg | apt-key add -
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

echo "Installing Flair ..."
apt-get install -y -qq flair > /dev/null
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't install Flair. Try again later."
    exit 1
fi

# Set up necessary envionment variables
echo "Setting up DISPLAY environmental variable ..."
scriptname="/etc/profile.d/flair_wsl.sh"

# Trying to determine WSL version
uname=$(uname -r)

if [ $(echo ${uname} | grep "Microsoft") ]; then
    WSL_version="1"
    echo "WSL version 1 has been detected"
elif [ $(echo ${uname} | grep "microsoft-standard") ]; then
    WSL_version="2"
    echo "WSL version 2 has been detected"
else
    echo "[WARNING] WSL version could not be determined."
    echo "Please set WSL version manually (1 or 2):"
    read WSL_version

    if [ $WSL_version != "1" ] && [ $WSL_version != "2" ]; then
        echo "[ERROR] Unsupported WSL version."
        exit 1
    fi
fi

# Writing script for DISPLAY
if [ $WSL_version == "1" ]; then
    echo "export DISPLAY=:0" > $scriptname
elif [ $WSL_version == "2" ]; then
    echo "export DISPLAY=`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0" > $scriptname
fi

echo "Install complete - Please close Ubuntu to finialaze installation."
