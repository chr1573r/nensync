#!/bin/bash

# nendex.sh
# Creates a file index and calculates the SHA512 of each file in the nen data directory
APPVERSION="1.1.1"

# Load nenlib
source nenlib.sh


# Start timer, set start time, read settings from server.cfg
t=$(timer)
STARTTIME=`date '+%d.%m.%Y, %H:%M'`
for i in `cat server.cfg`; do export "$i"; done 2>/dev/null

# Erase existing nendex.db content
#
# Hopefully, nendex will be capable of incremential updates to the db, so it won't need to be rebuilt all the time from scratch
echo "#nendex.db made with nendex $APPVERSION">./nendex.db
echo >>./nendex.db

# GUI init
clear
# Header
			echo -e "$RED""///"$YELLOW" nendex.sh v.$APPVERSION "$RED"/// "$DEF""
echo
echo "Updating nendex...(datadir: $REMOTEPATH)"
echo
echo -e "["$YELLOW"nendex"$DEF"] initialized at `date '+%d.%m.%Y, %H:%M'`"
# for each file found in .data that is not empty or a directory, do:
find $REMOTEPATH -not -empty -type f -print0 | xargs -0 ls | while read CURRENTFILE;
do
	# Tell which file is currently being hashed to console (STDOUT)
	echo -e "["$YELLOW"nendex "$GREEN"#"$DEF" `date '+%H:%M'`] Currently processing file "$CYAN"$CURRENTFILE"$DEF"..."
	# Generate SHA512 hash of $CURRENTFILE and write to file nendex.db
	sha512sum "$CURRENTFILE" >>./nendex.db
done

# Add timestamp to .db
echo >>./nendex.db
echo Last updated: `date '+%d.%m.%Y, %H:%M'`>>./nendex.db

# Report to gui, quit
echo "nendex update finished at `date '+%d.%m.%Y, %H:%M'`"
printf 'Elapsed time: %s\n' $(timer $t)

