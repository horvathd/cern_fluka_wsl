#!/bin/bash

# Check if the script run as root
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] The installation script requires root privileges"
    echo "        Please use: sudo ./setup_wsl_ubuntu-18.04.sh"
    exit 1
fi

# Add Flair repository
REPO="https://cern.ch/flair/download/ubuntu/18.04"

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

# Install required packages
echo "Updating package list"
apt-get update -qq
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't update pacakge list. Try again later."
    exit 1
fi

echo "Installing necessary packages"
apt-get install -y -qq make gawk gfortran gfortran-8 tk gnuplot-x11 \
    python3 python3-tk python3-pil python3-pil.imagetk python3-numpy \
    python3-scipy python3-dicom
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't install the necessary packages. Try again later."
    exit 1
fi

# Set gfortran-8 as default
echo "Setting up gfortran-8 as default compiler"
update-alternatives --quiet --remove-all gfortran
update-alternatives --quiet --install /usr/bin/gfortran gfortran /usr/bin/gfortran-7 10
update-alternatives --quiet --install /usr/bin/gfortran gfortran /usr/bin/gfortran-8 20

echo "Installing Flair"
apt-get install -y -qq flair
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't install Flair. Try again later."
    exit 1
fi

# Set up necessary envionment variables
if ! grep --quiet "export DISPLAY=:0" ~/.bashrc; then
    echo "Setting up DISPLAY environmental variable"
    
    echo "" >> ~/.bashrc
    echo "# Set DISPLAY environment variable for the X server" >> ~/.bashrc
    echo "export DISPLAY=:0" >> ~/.bashrc
fi

echo "Install complete"
