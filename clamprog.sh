#!/bin/bash

# Default values and file locations
DESC="Files scanned"
SCAN_FILE="~/Programs/clamprog/scan_files"
OLD_DATE_FILE="~/Programs/clamprog/old_date"
LOG_FILE="~/Logs/clamprog.log"

# Calculates date since last scanned
OLD_DATE=$(cat ${OLD_DATE_FILE})
NEW_DATE=$(date +%s)
delta=$((1+($NEW_DATE - $OLD_DATE)/(24*60*60)))

# If no argument is passed scans predefined dirs
if [ $# -eq 0 ]
then
	sudo find / -mtime -${delta} -type f -print > ${SCAN_FILE}
	SCAN_LOC="-f ${SCAN_FILE}"
else
	SCAN_LOC="-r ${1}"
fi
	
# Gets the total count (for progress bar)
COUNT=$(cat ${SCAN_FILE} | wc -l)

# Scans the dirs and displays a progress bar
clamscan --max-filesize=4000M --remove=yes ${SCAN_LOC} -l ${LOG_FILE} | tqdm --total ${COUNT} --desc ${DESC} >/dev/null

# Updates files and deletes scan files
echo "${NEW_DATE}" > ${OLD_DATE_FILE}
rm ${SCAN_FILE}

# Displays summary
tail ${LOG_FILE}
