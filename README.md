# Clam Wrap

Clam Wrap is a shell script that wraps around clamscan.

It's main features are:

1. Scans all files that have been changed since the last scan.
2. A progress bar.
3. Outputs results to a log file.

# How it works?

Best way to understand that is probably just read the bash script.

Having said that, clamwrap essentially finds all file that have been modified since the last scan date.
It then scans only those files and uses a tqdm to provide a progress bar.
Logs and the last scan date (old_date) are stored in the .clamwrap directory.
A text file containing all the files to be scanned is created at the beginning of the scan and deleted at the end, hence if the scan is aborted it will not be deleted. 

# Notes

The first scan takes a very very very long time.
