# Installing FLUKA and Flair on Windows with the Windows Subsystem for Linux (WSL)

The Windows Subsystem for Linux (WSL) is a Microsoft technology that allows users to run a Linux environment
directly on Windows without the need for a separate virtual machine or dual-boot setup.

Since FLUKA, Flair, and many of its supporting tools are designed for Linux systems, WSL provides a convenient and
efficient way to install, configure, and run FLUKA and Flair on Windows while maintaining compatibility with standard
Linux-based workflows.

WSL offers a lightweight Linux environment with access to common Linux utilities, compilers, and package managers,
while remaining seamlessly integrated with the Windows desktop and file system.


## 1. Installing WSL on Windows 11

Start the *Terminal (Windows PowerShell)* as Administrator and run the following command:

```
wsl --install
```

This will install all the necessary system components and install the *Ubuntu* application. During the installation, you will be asked to
set a username and password for *Ubuntu*. They can be anything, as they are not related to your Windows credentials.

When *Ubuntu* is installed, close the *Terminal (Windows PowerShell)* running as Administrator.

**Note:** If your account doesn't have Administrator rights, then you need to repeat the installation in a *Terminal* which
is **not** running as Administrator.


## 2. System setup and installing Flair

Download the zip file containing the setup script from [here](https://github.com/horvathd/cern_fluka_wsl/archive/refs/heads/master.zip),
and extract it to your Downloads folder.

Now you can start *Ubuntu* in the *Terminal* by clicking the down-arrow next to the tabs on the top,
or in the standalone *Ubuntu* application in the Start menu.

Then change to the location of the extracted files with:

```
cd /mnt/c/Users/<YourUserName>/Downloads/cern_fluka_wsl-master/cern_fluka_wsl-master
```

**Note:** You need to replace `<YourUserName>` with your Windows user name.

To check the contents of the directory you can use the command:

```
ls
```

If the directory contains the `setup_wsl.sh` script, run it with:

```
sudo ./setup_wsl.sh
```

The script will install the necessary packages and Flair. The setup process will take a few minutes.

**Note:** The sudo command executes a command with administrator privileges and may prompt for the password created during Ubuntu setup.


## 3. Installing FLUKA

After registering, you can download FLUKA from the [fluka.cern](https://fluka.cern/download/latest-fluka-release) website.
Choose the following package for *Ubuntu*: `gfortran>=9, 64 bits (.deb)`.

The default neutron library shall be downloaded in the `.deb` format as well.

To install the packages, navigate to your Downloads directory in the *Ubuntu* window with:

```
cd /mnt/c/Users/<YourUserName>/Downloads
```

**Note:** You need to replace `<YourUserName>` with your Windows user name.

and use the following command:

```
sudo apt install ./fluka_4-?.?.x64-Linux-gfor9_amd64.deb ./fluka-pw*
```

After the installation, restart Windows or close *Ubuntu* and run in  *Terminal (Windows PowerShell)*:

```
wsl --shutdown
```

## 4. Running simulations

After starting *Ubuntu* you can launch Flair with the `falir` command, or you can run FLUKA from the command line.


## 5. Updating FLUKA and Flair

### 5.1. Updating Flair

To update the whole Ubuntu system (including Flair) use:

```
sudo apt update && sudo apt upgrade
```

In case you only want to update Flair use:

```
sudo apt update && sudo apt upgrade flair flair-geoviewer
```

### 5.2. Updating FLUKA

Manually install the latest package of FLUKA as described in section 3.


## 6. Resetting WSL

If you encounter problems with WSL, you can always reset it to a clean state. To do so, run the following command
in the *Terminal (Windows PowerShell)*:

```
wsl --unregister Ubuntu
```

**Note:** This will delete all files in your *Ubuntu* home directory.

To install *Ubuntu* again, run:

```
wsl --install
```
