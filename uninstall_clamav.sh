#!/usr/bin/env bash

SUDO=/usr/bin/sudo

uninstall_clamav(){

	# uninstall clamav
	brew uninstall clamav
	
	# remove freshclam and clamd configuration files
	${SUDO} -E rm -- /usr/local/etc/clamav/freshclam.conf
	${SUDO} -E rm -- /usr/local/etc/clamav/clamd.conf
	
	# remove quarantine location
	${SUDO} -E rm -Rv -- /Users/Shared/Quarantine
	
	# remove clamdscan plist
	${SUDO} -E rm -- /Library/LaunchDaemons/net.clamav.clamdscan.plist
}

# uninstall clamav
echo "Do you want to uninstall clamav (y/n)"
read -r answer
if [ "${answer}" == "y" ]
then
    uninstall_clamav
else
    exit 1
fi
