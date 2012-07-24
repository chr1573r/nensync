#!/bin/bash

# nendex.sh
# Creates a file index and calculates the SHA512 of each file in the nen data directory
VERSION="1.0.0"

# Pretty colours!
DEF="\x1b[0m"
WHITE="\e[0;37m"
BLUE="\x1b[34;01m"
CYAN="\x1b[36;01m"
GREEN="\x1b[32;01m"
RED="\x1b[31;01m"
GRAY="\x1b[37;01m"
YELLOW="\x1b[33;01m"



function timer()
# timer function (http://www.linuxjournal.com/content/use-date-command-measure-elapsed-time)
# Elapsed time.  Usage:
#
#   t=$(timer)
#   ... # do something
#   printf 'Elapsed time: %s\n' $(timer $t)
#      ===> Elapsed time: 0:01:12
#
#
#####################################################################
# If called with no arguments a new timer is returned.
# If called with arguments the first is used as a timer
# value and the elapsed time is returned in the form HH:MM:SS.
#
{
    if [[ $# -eq 0 ]]; then
        echo $(date '+%s')
    else
        local  stime=$1
        etime=$(date '+%s')

        if [[ -z "$stime" ]]; then stime=$etime; fi

        dt=$((etime - stime))
        ds=$((dt % 60))
        dm=$(((dt / 60) % 60))
        dh=$((dt / 3600))
        printf '%d:%02d:%02d' $dh $dm $ds
    fi
}

# If invoked directly run test code.
if [[ $(basename $0 .sh) == 'timer' ]]; then
    t=$(timer)
    read -p 'Enter when ready...' p
    printf 'Elapsed time: %s\n' $(timer $t)
fi




# Start timer, set start time, read settings from server.cfg
t=$(timer)
STARTTIME=`date '+%d.%m.%Y, %H:%M'`
for i in `cat server.cfg`; do export "$i"; done 2>/dev/null

# Erase existing nendex.db content
#
# Hopefully, nendex will be capable of incremential updates to the db, so it won't need to be rebuilt all the time from scratch
echo "#nendex.db made with nendex $VERSION">./nendex.db
echo >>./nendex.db

# GUI init
clear
# Header
			echo -e "$RED""///"$YELLOW" nendex.sh v.$VERSION "$RED"/// "$DEF""
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
echo >./nendex.db
echo Last updated: `date '+%d.%m.%Y, %H:%M'`>>./nendex.db

# Report to gui, quit
echo "nendex update finished at `date '+%d.%m.%Y, %H:%M'`"
printf 'Elapsed time: %s\n' $(timer $t)

