# Shutdown Scheduler

ShutdownSheduler is an extremely simple program used to shutdown the computer in a specific date time. It provides a simple and clear interface to shedule the shutdown.

- Choose the specific time when you want to shutdown your computer
- Fast access buttons to add time
- Customize the fast access buttons with your own times
- Watch the remaining time at any time in the program, or just make a fast look to the progress bar of the icon
- Cancel the scheduled shutdown with just a button

<p float="left">
  <img src="/data/init_window.png" width="49%"/>
  <img src="/data/final_window.png" width="49%"/>
</p>

## Installation

### elementary AppCenter

Install Shutdown Scheduler through the elementary AppCenter. It's always updated to lastest version. Easy and fast.

<p align="center">
  <a href="https://appcenter.elementary.io/com.github.bcedu.shutdownscheduler"><img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter" /></a>
</p>

### Manual Instalation

You will need the following packages, that can be installed through apt:
- gobject-2.0
- glib-2.0
- gtk+-3.0
- granite
- gee-0.8
- unity

Download last release (zip file), extract files and enter to the folder where they are extracted.

Install the application with the following commands:

    meson build --prefix=/usr
    cd build
    ninja
    sudo ninja install

DO NOT DELETE FILES AFTER MANUAL INSTALLATION, THEY ARE NEEDED DURING UNINSTALL PROCESS

To uninstall type from the build folder:

    sudo ninja uninstall
