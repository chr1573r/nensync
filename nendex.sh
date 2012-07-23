#!/bin/bash

# nendex.sh
# Creates a file index and calculates the MD5 of each file
# v. 0.0.1

echo nendex - started `date '+%d.%m.%Y, %H:%M'`

	
echo "Updating nendex...(datadir: $REMOTEPATH)"
find ./data/* -type f -print0 | xargs -0 md5sum > ./nendex.md5 
echo Last updated: `date '+%d.%m.%Y, %H:%M'`>>./nendex.md5 
