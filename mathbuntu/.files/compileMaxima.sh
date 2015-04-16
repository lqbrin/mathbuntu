#!/bin/bash

maximaFile=$1
maximaDir=$2
nobody=$3

# Make
su $nobody -c "cd /tmp && tar -xzf $maximaFile"
su $nobody -c "cd /tmp/$maximaDir && ./configure --enable-clisp"
su $nobody -c "cd /tmp/$maximaDir && make"

# Install
cd /tmp/$maximaDir && make install

# Clean
su $nobody -c "cd /tmp/$maximaDir && make clean"
