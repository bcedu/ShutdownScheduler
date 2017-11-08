# Shutdown Scheduler

## Installation

### Elementary App Store

Download Shutdown Scheduler through the elementary app store. It's always updated to lastest version.
Easy and fast.

### Manual Instalation

Download last release (zip file), extract files and enter to the folder where they where extracted.

Install your application with the following commands:
- mkdir build
- cd build
- cmake -DCMAKE_INSTALL_PREFIX=/usr ../
- make
- sudo make install

DO NOT DELETE FILES AFTER MANUAL INSTALLATION, THEY ARE NEEDED DURING UNINSTALL PROCESS

### Python Script

Download last release (zip file), extract files and enter to the folder where they where extracted. Then, run the script "cmake_installer.py" from its original location. It must be run as sudo:

- sudo python3 cmake_installer.py

This script simply does the same that you would have done in manual installation. So we give the same advice:

DO NOT DELETE FILES AFTER INSTALLATION, THEY ARE NEEDED DURING UNINSTALL PROCESS

## Uninstall

### Elementary App Store

Just go to store and click on uninstall :)

### Manual Uninstall

To uninstall your application, run the script "cmake_uninstaller.py" (in the folder where files where originally extracted for manual installation).

It must be run as sudo:
- sudo python3 cmake_uninstaller.py
