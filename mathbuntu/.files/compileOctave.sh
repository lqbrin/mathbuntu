#!/bin/bash

octaveFile=$1
octaveDir=$2
nobody=$3

# Make
su $nobody -c "cd /tmp && tar -xzf $octaveFile"
su $nobody -c "cd /tmp/$octaveDir && ./configure"
su $nobody -c "cd /tmp/$octaveDir && make"

# Install
cd /tmp/$octaveDir
make install

# Clean
su $nobody -c "cd /tmp/$octaveDir && make clean"
