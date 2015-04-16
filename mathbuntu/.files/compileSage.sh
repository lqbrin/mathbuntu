#!/bin/bash

sageFile=$1
sageDir=$2
installDir=$3
nobody=$4

# Try to avoid disaster
if [ -z "$sageDir" ];then
  echo "Sage Directory not set. Cannot continue."
  exit 2000
fi

# Make
su $nobody -c "cd /tmp && tar -xzf $sageFile"
su $nobody -c "cd /tmp/$sageDir && make"
su -c "cd /tmp/$sageDir && make"

# Install
rm -rf $installDir/$sageDir
mv /tmp/$sageDir $installDir
chown -RH root:root $installDir/$sageDir
chmod a+rX -R $installDir/$sageDir
rm -f /usr/local/bin/sage
ln -s $installDir/$sageDir/sage /usr/local/bin

# Clean up
cd $installDir/$sageDir

# Update hard-coded directories
cd $installDir/$sageDir
su -c "./sage -c quit"

# Activate sagetex
texmflocal=`kpsewhich -var-value=TEXMFLOCAL`
rm -rf $texmflocal/sagetex
cp -R $installDir/$sageDir/local/share/texmf/tex/generic/sagetex $texmflocal
texhash
