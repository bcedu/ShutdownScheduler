# Shutdown Scheduler


<p>ShutdownSheduler is an extremely simple program used to shutdown the computer in a specific date time. It provides a simple and clear interface to shedule the shutdown.</p>
        <ul>
            <li>Choose the specific time when you want to shutdown your computer</li>
            <li>Fast access buttons to add time</li>
            <li>Customize the fast acces buttons with your own times</li>
            <li>Watch the remaining time at any time in the program, or just make a fast look to the progress bar of the icon</li>
            <li>Cancel the scheduled shutdown with just a button</li>
        </ul>
        
<p float="left">
  <img src="/data/init_window.png" width="49%" />
  <img src="/data/final_window.png" width="49%" /> 
</p>
     
        

## Installation

### Install .deb file

Check out the [last release](https://github.com/bcedu/ShutdownScheduler/releases/tag/v1.2.1) to download and install the .deb file with your favourite program or by typing:

`dpkg -i filename.deb`

### Get it on AppCenter

[![Get it on AppCenter](https://appcenter.elementary.io/badge.svg)](https://appcenter.elementary.io/com.github.bcedu.shutdownscheduler)

Download Shutdown Scheduler through the elementary AppCenter. It's always updated to lastest version.
Easy and fast.

### Manual Instalation

Download last release (zip file), extract files and enter to the folder where they where extracted.

Install your application with the following commands:
- `meson build --prefix=/usr`
- `cd build`
- `ninja install`

## Uninstall

### Uninstall with dpkg

If you installed the program with the .deb file or through the elementary os store you can uninstall it with the following command:

`dpkg -r com.github.bcedu.shutdownscheduler`

### Uninstall from the elementary AppCenter

Just go to AppCenter and click on uninstall :)