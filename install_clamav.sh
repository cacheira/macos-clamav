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
    $OPEN -a Safari https://brew.sh/
    $CAT <<HOMEBREW
Please download and install Homebrew from https://brew.sh/
then run this script again.
HOMEBREW
    exit 1
fi

# simply brew with the install verb and clamav as the recipe to be brewed:
brew install clamav

# create your configuration files
cp /usr/local/etc/clamav/freshclam.conf.sample /usr/local/etc/clamav/freshclam.conf && \
sed -ie 's/^Example/#Example/g' /usr/local/etc/clamav/freshclam.conf
cp /usr/local/etc/clamav/clamd.conf.sample /usr/local/etc/clamav/clamd.conf && \
sed -ie 's/^Example/#Example/g' /usr/local/etc/clamav/clamd.conf

# update the virus definitions for clamav
freshclam -v

# setup to a quarantine location
sudo mkdir /Users/Shared/Quarantine
sudo clamscan -r — scan-pdf=yes -l /Users/Shared/Quarantine/Quarantine.txt — move=/Users/Shared/Quarantine/ /

# use an Extension Attribute to read the Quarantine.txt file
#Read Quarantine
result=$(cat /Users/Shared/Quarantine/Quarantine.txt)
#Echo Quarantine into EA
echo "<result>$result</result>"

# create a plist that automatically runs on-demand clamdscan on a schedule
cd /tmp && curl https://raw.githubusercontent.com/essandess/macOS-clamAV/master/org.macports.clamdscan.plist
mv ./org.macports.clamdscan.plist ./org.hombrew.clamdscan.plist
sudo install -m 644 ./org.macports.clamdscan.plist /Library/LaunchDaemons
sudo launchctl load -w /Library/LaunchDaemons/org.hombrew.clamdscan.plist

### Related sources
# https://github.com/essandess/macOS-clamAV
# https://trac.macports.org/ticket/50570
# https://krypted.com/mac-os-x/managing-virus-scans-clamav/
# http://redgreenrepeat.com/2019/08/09/setting-up-clamav-on-macos/
# https://github.com/Cisco-Talos/clamav-faq/blob/master/manual/UserManual/Installation-Unix/Steps-macOS.md
