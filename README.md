# Installing FLUKA.CERN and Flair on Windows using WSL

It is recommended to use the Windows Subsystem for Linux (WSL) for running CERN's FLUKA and Flair on Windows.
The Windows Subsystem for Linux lets developers run GNU/Linux environment - including most command-line tools, utilities,
and applications - directly on Windows, unmodified, without the overhead of a virtual machine.


## 1. Enable Windows Subsystem for Linux

### 1.1. For Windows 10 version 2004 (build number 19041, released in May 2020) or newer and for Windows 11:

Start a *PowerShell* as *Administrator* and run the following command:

> `wsl --install`

*Ubuntu* will be automatically installed as well.

When the command asks, reboot the PC to finalize the installation.

### 1.2. For older Windows 10 versions

Follow the instructions from [here](https://learn.microsoft.com/en-us/windows/wsl/install-manual).

You may skip Steps 2 through 5, if you don't want to update to WSL version 2.

In Step 6, install *Ubuntu 20.04* or *Ubuntu 22.04*.


## 2. Initialize Ubuntu

After the installation start *Ubuntu* from the start menu, or click the *Open* button in the *Microsoft Store*.

After a couple minutes it will ask for a new Linux username and password. They can be anything, as they are not related
to your Windows credentials.

After the initialization, *Ubuntu* works just like a native Linux system.

### 2.1. Accessing files in WSL

The windows drives (C:\\, D:\\, etc.) are automatically mounted at: `/mnt/<drive_letter>/...`


## 3. Setting up for FLUKA and installing Flair

### 3.1. Running the setup script

Download the zip file containing the setup script from [here](https://github.com/horvathd/cern_fluka_wsl/archive/refs/heads/master.zip),
and extract its content.

In the *Ubuntu* terminal change the directory to the location of the downloaded script and run the following command:

> `sudo ./setup_wsl.sh`

The script will install Flair and the necessary packages FLUKA. The setup process will take a few minutes.

Restart *Ubuntu* after the script finished.

### 3.2. Install an X Server

An X Server for Windows is necessary to visualize the Flair's graphical interface.

#### 3.2.1. WSLg

If you are using a WSL release with an included X Server you don't need to install any third-party X Server.
Run the following command in *PowerShell* or *Ubuntu* to check if WSL's X Server is available:

> `wsl.exe --version`

If you get a valid version number for WSLg then the X Server is working. Otherwise, a third-party X Server needs to be installed.
The following two free X servers are recommended. Only one has to be installed.

#### 3.2.2. Xming

Download and install the *Public Domain Release* version from http://www.straightrunning.com/XmingNotes/

#### 3.2.3. MobaXTerm

Download and install the *Home* edition from https://mobaxterm.mobatek.net/


## 4. Download and install FLUKA

Download the GNU/Linux *\*gfor9_amd64.deb* package of FLUKA from [fluka.cern](https://fluka.cern/download/latest-fluka-release).

The steps of the installation can be found [here](https://fluka.cern/documentation/installation/fluka-linux-rpm-deb).
See section: *Installing FLUKA using .deb files*.

To finalize the installation *Ubuntu* must be closed and reopened.


## 5. Running FLUKA and Flair

### 5.1. Running the X Server

If you installed a third-party X Server (Xming or MobaXTerm), you need to start it first.

If you are using Xming with WSL2, then the XLaunch app must be used with *No Access Control* enabled, instead of Xming.

### 5.2. Running Ubuntu

Launch *Ubuntu* from the Start Menu.

### 5.3. Running FLUKA and Flair

See the instructions on [fluka.cern](https://fluka.cern/documentation/running)


## 6. Updating FLUKA and Flair

### 6.1. Update Flair

To update Flair run the following commands:

> `sudo apt-get update`

> `sudo apt-get install flair flair-geoviewer`

To update the whole Ubuntu system (including Flair) use:

> `sudo apt-get update`

> `sudo apt-get upgrade`

### 6.2. Update FLUKA

Manually install the latest package of FLUKA as described in section 4.


## 7. Resetting WSL

If there is an issue with WSL, you can always reset it to a clean state. To do right lick on *Ubuntu* in the
Start Menu, right click on its icon, and select (*More*) *App settings*. In the new window click the *Reset*
button. When the reset is complete close the settings window and restart *Ubuntu*.


## 8. Troubleshooting

### 6.1 Flair couldn't connect to display

If Flair shows the following error message `couldn't connect to display`. Make sure that the X Server is running before launching Flair.

If Flair still can't connect and the error message contains an IP address then you have WSL2 installed. See section 5.1.
