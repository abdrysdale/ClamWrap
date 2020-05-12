#!/bin/bash

# Default values and file locations
DESC="Files scanned"
quarantine_dir="/home/al/.quarantine"
SCAN_FILE="/home/al/Programs/clamprog/scan_files"
OLD_DATE_FILE="/home/al/Programs/clamprog/old_date"

# Calculates date since last scanned
OLD_DATE=$(cat ${OLD_DATE_FILE})
NEW_DATE=$(date +%s)
delta=$((1+($NEW_DATE - $OLD_DATE)/(24*60*60)))

# If no argument is passed scans predefined dirs
if [ $# -eq 0 ]
then
	find / -ctime -${delta} -type f -print > ${SCAN_FILE}
	SCAN_LOC="-f ${SCAN_FILE}"
else
	SCAN_LOC="-r ${1}"
fi
	
# Second argument (if passed) is the quarantine folder
if [ $# -gt 1 ]
then
	DIR=$2
else 
	DIR=${quarantine_dir}
fi

# Gets the total count (for progress bar)
COUNT=$(cat ${SCAN_FILE} | wc -l)

# Scans the dirs and displays a progress bar
clamscan --move=${DIR} ${SCAN_LOC} | tqdm --total ${COUNT} --desc ${DESC} >/dev/null

# Updates files and deletes scan files
echo "${NEW_DATE}" > ${OLD_DATE_FILE}
rm ${SCAN_FILE}

echo "Virus found: $(ls ${DIR} | wc -l)"
rm ${DIR}/*
