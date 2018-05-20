#!/bin/bash
if [ -e test ]
then
  echo "Removing old 'test'"
  rm test
fi
valac --main=main test.vala *_tests.vala ../src/*.vala --pkg=gtk+-3.0 --pkg=gio-2.0 --pkg=gmodule-2.0 --pkg=gstreamer-1.0 --pkg=dbus-glib-1 --pkg=granite --pkg=unity --pkg=posix -o test
if [ -e test ]
then
  echo "####################################"
  echo "   Tests successfully complied!!    "
  echo "####################################"
  COLOR='\033[0;33m'
  NC='\033[0m' # No Color
  printf "${COLOR}Running all tests:${NC}\n"
  OUTPUT="$(./test)"
  printf "${COLOR}${OUTPUT}${NC}\n"
  rm test
else
  echo "------------------------------------"
  echo "    Tests compilation failed...     "
  echo "------------------------------------"
fi
