#!/bin/bash

wxmaximaFile=$1
wxmaximaDir=$2
nobody=$3

# Make
su $nobody -c "cd /tmp && tar -xzf $wxmaximaFile"
su $nobody -c "cd /tmp/$wxmaximaDir && ./bootstrap"
su $nobody -c "cd /tmp/$wxmaximaDir && ./configure"
su $nobody -c "cd /tmp/$wxmaximaDir && make"
su $nobody -c "cd /tmp/$wxmaximaDir && make allmo"

# Install
cd /tmp/$wxmaximaDir
make install

# Clean
su $nobody -c "cd /tmp/$wxmaximaDir && make clean"
