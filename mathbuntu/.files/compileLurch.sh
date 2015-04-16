#!/bin/bash

installDir=$1
ARCHITECTURE=$2
nobody=$3

# Try to avoid disaster
if [ -z "$installDir" ];then
  echo "Install Directory not set. Cannot continue."
  exit 2000
fi

arch="64"
gcc="gcc_64"
if [ "$ARCHITECTURE" == "i386" ]; then
  arch="86"
  gcc="gcc"
fi

# Install Qt if needed
if [ "$AUTOMATIC"="no" ] && [ ! -f "/opt/Qt5.3.1/5.3/$gcc/bin/qmake" ]; then
  wget -P /tmp http://download.qt-project.org/official_releases/qt/5.3/5.3.1/qt-opensource-linux-x${arch}-5.3.1.run
  chmod +x /tmp/qt-opensource-linux-x${arch}-5.3.1.run
  /tmp/qt-opensource-linux-x${arch}-5.3.1.run
fi

# Get source
su $nobody -c "cd /tmp && git clone git://git.code.sf.net/p/lurch/git lurch"
su $nobody -c "cd /tmp/lurch && git submodule update --init --recursive"
su $nobody -c "cd /tmp/lurch && git submodule update --recursive"

# Make
su $nobody -c "cd /tmp/lurch/utils/Lurch && /opt/Qt5.3.1/5.3/$gcc/bin/qmake"
su $nobody -c "cd /tmp/lurch/utils/Lurch && make"

rm -rf $installDir/lurch
mv /tmp/lurch $installDir
chown -RH root:root $installDir/lurch
rm -f /usr/local/bin/lurch
ln -s $installDir/lurch/utils/Lurch/Lurch /usr/local/bin/lurch
