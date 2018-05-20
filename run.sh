#!/bin/bash
if [ -e shutdownscheduler ]
then
  echo "Removing old 'shutdownscheduler'"
  rm shutdownscheduler
fi
valac src/*.vala --pkg=gtk+-3.0 --pkg=gio-2.0 --pkg=gmodule-2.0 --pkg=gstreamer-1.0 --pkg=dbus-glib-1 --pkg=granite --pkg=unity --pkg=posix -o shutdownscheduler
if [ -e shutdownscheduler ]
then
  echo "####################################"
  echo "      Successfully complied!!      "
  echo "####################################"
  ./shutdownscheduler
else
  echo "------------------------------------"
  echo "       Compilation failed...        "
  echo "------------------------------------"
fi
