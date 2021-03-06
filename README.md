# Installing CERN's FLUKA and Flair on Windows 10 using WSL

It is recommended to use the Windows Subsystem for Linux (WSL) for running CERN's FLUKA and Flair on Windows 10.
The Windows Subsystem for Linux lets developers run GNU/Linux environment - including most command-line tools, utilities,
and applications - directly on Windows, unmodified, without the overhead of a virtual machine.

## 1. Required software

### 1.1. Windows Subsystem for Linux

Windows Subsystem for Linux requires Windows 10 (build: 16299 [2017 Fall update] or greater) and admin rights during installation.

#### 1.1.1. Enable Windows Subsystem for Linux

Start a *PowerShell* as *Administrator* and run the following command:

> `Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux`

When the command asks, reboot the PC to finalize the installation.

#### 1.1.2. Get Ubuntu Linux from the Microsoft Store

In the *Microsoft Store*, search for *Ubuntu 20.04 LTS* and click on the *Get* button, then on *Install*.

#### 1.1.3. Initialize Ubuntu

To initialize simply click *Launch* in the *Microsoft Store*, or find *Ubuntu 20.04 LTS* in the *Start Menu*.

After a couple minutes it will ask for a new Linux username and password. They can be anything, as they are not related
to your Windows credentials.

After the initialization, Ubuntu works just like a native Ubuntu 20.04 system.

#### 1.1.4. Legacy console error

Sometimes you can't enter the new Linux username and password, and the following error message is appearing:

> Unsupported console settings. In order to use this feature the legacy console must be disabled.

To solve this, right click on the *Title bar* of the windows of *Ubuntu*, and select *Properties*. On the *Options* tab
disable the *Use Legacy Console* option, and click *OK*. To apply the change you have to close *Ubuntu 20.04 LTS*.

To restart the initialization, *Ubuntu* has to be reset. See 5. for instructions. When it is finished, start *Ubuntu 20.04 LTS* again, to start the initialization again.

#### 1.1.5. Accessing files in WSL

The windows drives (C:\\, D:\\, etc.) are automatically mounted at: `/mnt/<drive_letter>/...`

### 1.2. Install an X Server

An X Server for Windows is necessary to visualize the Flair's graphical interface. The following two X servers are recommended. Only one has to be installed.

#### 1.1.1. Xming

Download and install the *Public Domain Release* version from http://www.straightrunning.com/XmingNotes/

#### 1.1.2. MobaXTerm

Download and install the *Home* edition from https://mobaxterm.mobatek.net/

## 2. Installing FLUKA and Flair

### 2.1. Setting up Ubuntu and install Flair

Download the *setup_wsl.sh* script from [here](https://raw.githubusercontent.com/horvathd/cern_fluka_wsl/master/setup_wsl.sh) (Right click, save link as ...).
In the *Ubuntu* terminal change the directory to the downloaded script and run the following command:

> `sudo ./setup_wsl.sh`

The script will install the necessary packages and Flair. 

### 2.2. Download and install FLUKA

Download the GNU/Linux *\*gfor9_amd64.deb* package of FLUKA from [fluka.cern](https://fluka.cern/download/latest-fluka-release).

The steps of the installation can be found [here](https://fluka.cern/documentation/installation/fluka-linux-rpm-deb). See section: *Installing FLUKA using .deb files*.

### 2.3. Restarting Ubuntu

To finalize the installation the terminal window of *Ubuntu 20.04 LTS* must be closed and reopened.

## 3. Running FLUKA and Flair

### 3.1. Running the X Server

Start the Xming or MobaXTerm app from the start menu.

If you are using Xming with WSL2, then the XLaunch app must be used with *No Access Control* enabled, instead of Xming.

### 3.2. Running Ubuntu

Launch *Ubuntu 20.04 LTS* from the Start menu

### 3.3. Running FLUKA and Flair

See the instructions on [fluka.cern](https://fluka.cern/documentation/running)

## 4. Updating FLUKA and Flair

### 4.1. Update Flair

To update Flair run the following commands:

> `sudo apt-get update`

> `sudo apt-get install flair flair-geoviewer`

To update the whole Ubuntu system (including Flair) use:

> `sudo apt-get update`

> `sudo apt-get upgrade`

### 4.2. Update FLUKA

Manually install the latest package of FLUKA as described in section 2.2.

## 5. Resetting WSL

If there is an issue with WSL, you can always reset it to a clean state. To do so search for *Ubuntu 20.04 LTS* in the
*Start Menu*, right click on its icon, and select (*More*) *App settings*. In the new window click the *Reset*
button. When the reset is complete close the settings window and restart *Ubuntu 20.04 LTS*.

## 6. Known issues

### 6.1 Flair couldn't connect to display

If Flair shows the Following error message `couldn't connect to display`. Make sure that the X Server is running before launching Flair.

If Flair still can't connect and the error message contains an IP addess then you have WSL2 installed. See section 3.1.
