#!/bin/bash

# nendex.sh

# For future reference:
# awk '{$1=""; print $0}'
# Can be used to get everything but the sum for a nendex line

# Creates a file index and calculates the SHA512 of each file in the nen data directory
APPVERSION="1.2.0"

# Get directory where nendex.sh is stored
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read variables from cfg file
source $DIR/../cfg/nen.cfg

# We need to load functions fron nenlib.sh:
source $NENDIR/bin/nenlib.sh

# Start timer, set start time, read settings from server.cfg
t=$(timer)
STARTTIME=`date '+%d.%m.%Y, %H:%M'`
for i in `cat server.cfg`; do export "$i"; done 2>/dev/null

# Erase existing nendex.db content
#
# Hopefully, nendex will be capable of incremential updates to the db, so it won't need to be rebuilt all the time from scratch
echo "#nendex.db made with nendex $APPVERSION">$NENDIR/sys/nendex.db
echo >>$NENDIR/sys/nendex.db

# GUI init
clear
# Header
			echo -e "$RED""///"$YELLOW" nendex.sh v.$APPVERSION "$RED"/// "$DEF""
echo
echo "Updating nendex...(datadir: $DATADIR)"
echo
echo -e "["$YELLOW"nendex"$DEF"] initialized at `date '+%d.%m.%Y, %H:%M'`"
# for each file found in .data that is not empty or a directory, do:
find $DATADIR -not -empty -type f -print0 | xargs -0 ls | while read CURRENTFILE;
do
	# Tell which file is currently being hashed to console (STDOUT)
	echo -e "["$YELLOW"nendex "$GREEN"#"$DEF" `date '+%H:%M'`] Currently processing file "$CYAN"$CURRENTFILE"$DEF"..."
	# Generate SHA512 hash of $CURRENTFILE and write to file nendex.db
	sha512sum "$CURRENTFILE" >>$NENDIR/sys/nendex.db
done

# Add timestamp to .db
echo >>$NENDIR/sys/nendex.db
echo Last updated: `date '+%d.%m.%Y, %H:%M'`>>$NENDIR/sys/nendex.db

# Report to gui, quit
echo "nendex update finished at `date '+%d.%m.%Y, %H:%M'`"
printf 'Elapsed time: %s\n' $(timer $t)

