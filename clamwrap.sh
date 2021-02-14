#! /usr/bin/env sh

# Default values and file locations
DESC="Files scanned"
CLAM_DIR="${HOME}/.clamwrap"
SCAN_FILE="${CLAM_DIR}/scan_files"
OLD_DATE_FILE="${CLAM_DIR}/old_date"
LOG_FILE="${CLAM_DIR}/scan.log"

# Creates clamwrap dir if needed
if [ ! -d ${CLAM_DIR} ]
then
	mkdir ${CLAM_DIR}
fi
if [ ! -e ${OLD_DATE_FILE} ]
then
	echo "0" > ${OLD_DATE_FILE}
fi

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
