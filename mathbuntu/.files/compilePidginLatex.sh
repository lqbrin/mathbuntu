#!/bin/bash

pidginLatexFile=$1
pidginLatexDir=$2
nobody=$3

# Make
su $nobody -c "tar -C /tmp -xzf /tmp/$pidginLatexFile"
su $nobody -c "cd /tmp/$pidginLatexDir && make"

# Install
mv -f /tmp/$pidginLatexDir/LaTeX.so /usr/lib/pidgin/
