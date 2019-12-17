#!/bin/bash

# Downloader function
download_from_flair_website() {
    # Download package
    wget -q http://cern.ch/flair/download/$1

    # Check if the download was successful
    if [ "$?" -eq 0 ]; then
        mv $1 ./downloads/
    else
        echo "[ERROR] Couldn't download $1. Please try again later."
        exit 1
    fi
}

install_flair() {
    # Install flair from deb package
    echo "Installing flair ${flair_latest}"
    apt-get install -qq --reinstall --allow-downgrades ./downloads/$flair
    if [ ! "$?" -eq 0 ]; then
        echo "[ERROR] Couldn't install $flair. Please conctact the Fluka forum for help."
        exit 1
    fi

    echo "Installing flair-geoviewer ${flair_latest}"
    mkdir -p ./tmp-geoviewer

    # Compile and install flair-geoviewer from source
    tar -zxf ./downloads/$geoviewer -C ./tmp-geoviewer
    cd ./tmp-geoviewer/flair-geoviewer-*

    make --silent -j4
    if [ ! "$?" -eq 0 ]; then
        echo "[ERROR] Couldn't install $geoviewer. Please conctact the Fluka forum for help."
        exit 1
    fi

    make --silent install
    if [ ! "$?" -eq 0 ]; then
        echo "[ERROR] Couldn't install $geoviewer. Please conctact the Fluka forum for help."
        exit 1
    fi

    cd ../..
    rm -rf ./tmp-geoviewer
}

force_reinstall_flag=false
flair_requested_flag=false

# Check command line arguments
while true; do
    case $1 in
        --force_reinstall)
            force_reinstall_flag=true
            ;;
        --flair)
            flair_requested_flag=true
            flair_requested="$2"
            shift
            ;;
        -h | --help)
            echo
            echo "Usage: sudo ./setup_wsl [--flair <version_number>]"
            echo "                        [--force_reinstall]"
            echo "                        [-h / --help]"
            echo
            exit 0
            ;;
    esac
    shift || break
done

# Check if the script run as root
if [ "$EUID" -ne 0 ]; then
    echo "[ERROR] The installation script requires root privileges"
    echo "        Please use: sudo ./setup_wsl.sh"
    exit 1
fi

if [ "$force_reinstall_flag" = true ]; then
    echo "[OPTION] Forced reinstall enabled"
fi

if [ "$flair_requested_flag" = true ]; then
    echo "[OPTION] Custom Flair version (${flair_requested}) requested"
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
    python3-scipy python3-dicom ed g++ tk-dev python3-dev
if [ ! "$?" -eq 0 ]; then
    echo "[ERROR] Couldn't install the necessary packages. Try again later."
    exit 1
fi

# Set gfortran-8 as default
echo "Setting up gfortran-8 as default compiler"
update-alternatives --quiet --remove-all gfortran
update-alternatives --quiet --install /usr/bin/gfortran gfortran /usr/bin/gfortran-7 10
update-alternatives --quiet --install /usr/bin/gfortran gfortran /usr/bin/gfortran-8 20

# Add FLUKA to path and set up necessary envionment variables
if ! grep --quiet "PATH=\$PATH:/usr/local/fluka/bin/" ~/.bashrc; then
    echo "Adding /usr/local/fluka to PATH"

    echo "# Add FLUKA's bin to PATH" >> ~/.bashrc
    echo "export PATH=\$PATH:/usr/local/fluka/bin/" >> ~/.bashrc
    echo "" >> ~/.bashrc

    echo "Setting up environmental variables"

    echo "# Set DISPLAY environment variable for the X server" >> ~/.bashrc
    echo "export DISPLAY=:0" >> ~/.bashrc
    echo "export XMING=True" >> ~/.bashrc
fi

# Create downloads folder if doesn't exists
mkdir -p ./downloads

# Get Flair version to install
if [ "$flair_requested_flag" = true ]; then
    flair_latest=$flair_requested
else
    # Check latest flair version from the flair website
    echo "Checking flair version"
    wget -q http://cern.ch/flair/download/version.tag

    if [ "$?" -eq 0 ]; then
        prefix=flair-
        suffix=.tgz

        flair_latest=$(cat version.tag | awk '{print $1}' | sed -e "s/^$prefix//" -e "s/$suffix$//")

        \rm -rf version.tag
    else
        flair_latest=0
    fi
fi

# Create directory for storing installed version numbers
mkdir -p ~/.fluka

# File storing the installed version number
flair_version_file=~/.fluka/flair.version

# Check installed Flair version
if [ "$force_reinstall_flag" = true ]; then
    flair_installed=0
elif [ -f "${flair_version_file}" ]; then
    flair_installed=$(cat ${flair_version_file})

    # If latest flair version is not available, assume installed one is up to date
    if [ "${flair_latest}" == "0" ]; then
        flair_latest=flair_installed
        echo "[WARNING] Couldn't determine latest Flair version, assuming installed version is up to date"
    fi
else
    flair_installed=0
fi

# INstall flair
if [ "${flair_latest}" == "0" ]; then
    echo "[WARNING] Couldn't determine latest Flair version, trying to install latest"

    flair=flair_latest_all.deb
    geoviewer=flair-geoviewer_latest.tgz

    # Download latest version of flair and flair-geoviewer
    download_from_flair_website $flair
    download_from_flair_website $geoviewer

    install_flair
elif [ ! "${flair_latest}" == "${flair_installed}" ]; then
    flair=flair_${flair_latest}_all.deb
    geoviewer=flair-geoviewer-${flair_latest}.tgz

    if [ "$force_reinstall_flag" = true ]; then
        \rm -rf  "./downloads/$flair"
        \rm -rf "./downloads/$geoviewer"
    fi

    if [ ! -f "./downloads/$flair" ]; then
        download_from_flair_website $flair
    fi

    if [ ! -f "./downloads/$geoviewer" ]; then
        download_from_flair_website $geoviewer
    fi

    install_flair
else
    echo "Flair (${flair_installed}) is up to date"
fi

touch "${flair_version_file}"
echo "${flair_latest}" > "${flair_version_file}"

echo "Install complete"
