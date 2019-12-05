SCAN_TARGETS="/tmp"
CLAMDSCAN_QUARANTINE=/Users/Shared/Quarantine;
CLAMDSCAN_LOG=/usr/local/var/log/clamav/clamdscan.log;

# Updating the database
( /bin/test -d ${CLAMDSCAN_LOG%/*} || /bin/mkdir -p ${CLAMDSCAN_LOG%/*} ) &&
echo "Freshclam database update started on `/bin/date` …" >> $CLAMDSCAN_LOG &&
/usr/local/bin/freshclam >> $CLAMDSCAN_LOG 

# Reloading it
/usr/local/bin/clamdscan --reload && 
( /bin/test -d $CLAMDSCAN_QUARANTINE || /bin/mkdir -p $CLAMDSCAN_QUARANTINE ) &&
( /bin/test -d ${CLAMDSCAN_LOG%/*} || /bin/mkdir -p ${CLAMDSCAN_LOG%/*} ) &&
echo "Launch daemon net.clamav.clamdscan started on `/bin/date` …" >> $CLAMDSCAN_LOG #&&
#( /usr/local/bin/clamdscan --multiscan --quiet --fdpass --move=$CLAMDSCAN_QUARANTINE --log=$CLAMDSCAN_LOG "${SCAN_TARGETS[@]}") #&&
( /usr/local/bin/clamdscan --multiscan --quiet --fdpass --move=$CLAMDSCAN_QUARANTINE "${SCAN_TARGETS[@]}") #&&
#echo "Launch daemon net.clamav.clamdscan completed on `/bin/date`." >> $CLAMDSCAN_LOG ||
# echo "Launch daemon net.clamav.clamdscan exited with error code $? on `/bin/date`." >> $CLAMDSCAN_LOG )
