#!/usr/bin/env bash

SUDO=/usr/bin/sudo
BREW=/usr/local/bin/brew

# prerequisites
# install macos command line tools
CLT_DIR=`xcode-select -p`
RV=$?
if ! [ $RV -eq '0' ]
then
    $SUDO -E /usr/bin/xcode-select --install
    $SUDO -E /usr/bin/xcodebuild -license
fi

# install homebrew
if ! [ -x $BREW ]
then
    echo "Do you want to install Homebrew from https://brew.sh (y/n)"
    read answer
    if $answer == "y"
    then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        exit 1
    fi
fi

# simply brew with the install verb and clamav as the recipe to be brewed:
brew install clamav

# create your configuration files
#cp /usr/local/etc/clamav/freshclam.conf.sample /usr/local/etc/clamav/freshclam.conf && \
#sed -ie 's/^Example/#Example/g' /usr/local/etc/clamav/freshclam.conf
#sed -ie 's/^LocalSocket /tmp/clamd.socket/#LocalSocket /tmp/clamd.socket/g' /usr/local/etc/clamav/freshclam.conf
#cp /usr/local/etc/clamav/clamd.conf.sample /usr/local/etc/clamav/clamd.conf && \
#sed -ie 's/^Example/#Example/g' /usr/local/etc/clamav/clamd.conf
cp ./freshclam.conf /usr/local/etc/clamav/freshclam.conf
cp ./clamd.conf /usr/local/etc/clamav/clamd.conf
cp ./clamd.conf /usr/local/etc/clamav/clamd.conf

# update the virus definitions for clamav
freshclam -v

# setup to a quarantine location
sudo mkdir -p /Users/Shared/Quarantine
#sudo clamscan -r — scan-pdf=yes -l /Users/Shared/Quarantine/Quarantine.txt — move=/Users/Shared/Quarantine/ /

# use an Extension Attribute to read the Quarantine.txt file
#Read Quarantine
#result=$(cat /Users/Shared/Quarantine/Quarantine.txt)
#Echo Quarantine into EA
#echo "<result>$result</result>"

# create a plist that automatically runs on-demand clamdscan on a schedule
#sudo install -m 644 ./net.clamav.clamdscan.plist /Library/LaunchDaemons
#sudo launchctl load -w /Library/LaunchDaemons/net.clamav.clamdscan.plist

### Related sources
# https://github.com/essandess/macOS-clamAV
# https://trac.macports.org/ticket/50570
# https://krypted.com/mac-os-x/managing-virus-scans-clamav/
# http://redgreenrepeat.com/2019/08/09/setting-up-clamav-on-macos/
# https://github.com/Cisco-Talos/clamav-faq/blob/master/manual/UserManual/Installation-Unix/Steps-macOS.md
