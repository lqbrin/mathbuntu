#!/bin/bash

xppautFile=$1
xppautDir=$2
installDir=$3
nobody=$4

# Try to avoid disaster
if [ -z "$xppautDir" ];then
  echo "Xppaut Directory not set. Cannot continue."
  exit 2000
fi

# Make
su $nobody -c "mkdir /tmp/$xppautDir"
su $nobody -c "tar -C /tmp/$xppautDir -xzf /tmp/$xppautFile"
su $nobody -c "cd /tmp/$xppautDir && make"

# Install
rm -rf $installDir/$xppautDir
mv /tmp/$xppautDir $installDir
chown -RH root:root $installDir/$xppautDir
rm -f /usr/local/bin/xppaut
ln -sf $installDir/$xppautDir/xppaut /usr/local/bin
