#!/bin/bash

# Default values and file locations
DESC="Files scanned"
dir_file="/home/al/Programs/clamprog/default_dirs.txt"
quarantine_dir="/home/al/.quarantine"

# If no argument is passed scans predefined dirs
if [ $# -eq 0 ]
then
	SCAN_DIR="$(cat ${dir_file} | tr '\n' ' ')"
else
	SCAN_DIR=${1}
fi
	
# Second argument (if passed) is the quarantine folder
if [ $# -gt 1 ]
then
	DIR=$2
else 
	DIR=${quarantine_dir}
fi

# Gets the total count (for progress bar)
COUNT=$(find ${SCAN_DIR} -type f -print | wc -l)

# Scans the dirs and displays a progress bar
clamscan -r --move=${DIR} ${SCAN_DIR} | tqdm --total ${COUNT} --desc ${DESC} >/dev/null
