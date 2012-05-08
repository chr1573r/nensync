#!/bin/bash

# Declare variables

VERSION="0.6.8"
LOCALPATH="/home/nen/data"
#REMOTEPATH="/home/nen/data/"
REMOTEUSER="nen"
LOGFILE="sync.log"

# Pretty colours!
DEF="\x1b[0m"
WHITE="\e[0;37m"
BLUE="\x1b[34;01m"
CYAN="\x1b[36;01m"
GREEN="\x1b[32;01m"
RED="\x1b[31;01m"
GRAY="\x1b[37;01m"
YELLOW="\x1b[33;01m"

clear

echo nensync loading..
echo Declaring functions...


gfx ()
{
	# This function provides "[  OK  ]" and "[FAILED]" text output (followed by a line break)
	# SYNTAX: gfx [element] [element text, if applicable]
	# Valid elements:
	#	Feedback gfx:
	#			"ok" - Prints "[  OK  ]" with green text
	#			"failed" - Prints "[FAILED]" with red text
	#	Design gfx:
	#			"splash" - The splashscreen, logo made possible by http://www.network-science.de/ascii/
	#			"line" - Draws a red line (-----)
	#			"header" - adds a yellow line, echos param $2, adds a yellow line again
	#	Error gfx:
	#			
	# "gfx ok" will print "[  OK  ]", while "gfx failed" will print "[FAILED]"
	
	case "$1" in

		ok)
			echo -e "                         "$WHITE"[  "$GREEN"OK"$WHITE"  ]$DEF"
				echo
				;;	
	
		failed)
		        echo -e "                         "$WHITE"["$RED"FAILED"$WHITE"]$DEF"
			echo
			;;
		
		splash)
			clear
			echo
			echo
			echo
			echo          
			echo
			echo
			echo
			echo
			echo -e "$GREEN""         88d888b. .d8888b. 88d888b. .d8888b. dP    dP 88d888b. .d8888b. "
			echo -e "         88'   88 88ooood8 88'   88 Y8ooooo. 88    88 88'   88 88'   "" "
			echo -e "         88    88 88.  ... 88    88       88 88.  .88 88    88 88.  ... "
			echo -e "         dP    dP '88888P' dP    dP '88888P' '8888P88 dP    dP '88888P' "
			echo -e "$BLUE""         ooooooooooooooooooooooooooooooooooooo~~~~"$GREEN".88"$BLUE"~ooooooooooooooooo         "
			echo -e "$GREEN""                                             d8888P      "
			echo
			echo
			echo
			echo -e "$GREEN""          nensync version $VERSION"$DEF" - " $BLUE"Nordic Encryption Net"$DEF" (C) "$BLUE"2011-2012"$DEF
			sleep 2
			clear
			
			;;
		
		line)
			echo -e "$RED------------------------------$DEF"
			;;

		header)
			clear
			echo -e "$BLUE""///"$GREEN" nensync "$BLUE"/// "$GREEN"$HOSTNAME"
			echo
			;;
		arrow)
			echo -e "$RED""--""$YELLOW""> ""$DEF""$2"
			echo
			;;
		subarrow)
			echo -e "$RED""----""$YELLOW""> ""$DEF""$2"
			;;
		
		subspace)
			echo -e "     $2"
			;;
		
		*)
			
	esac
}

log_engine ()
{
	# This function aims to provide easy and standarized template-based logging
	# SYNTAX: log_engine [entrytype] "<text>"
	# 
	# Validentry types: Start, NewEntry, NewSubEntry, Error, End
	# Write more documentation here!
	
	case "$1" in

		Start)
			echo >>$LOGFILE
			echo >>$LOGFILE
			echo "----------------------------------------------------------" >>$LOGFILE
			echo "nensync version $VERSION - Nordic Encryption Net (C) 2011" >>$LOGFILE
			echo >>$LOGFILE
			echo "This session was invoked  at: `/bin/date`" >>$LOGFILE
			echo >>$LOGFILE
			;;

		NewEntry)
				if [ -z "$2" ]
				then
				echo "LOGENGINE ERROR, NewEntry must be followed by text!" >>$LOGFILE
				else
				echo "[`/bin/date`] $2" >>$LOGFILE
				fi
			;;

		NewSubEntry)
        	        	if [ -z "$2" ]
               	 		then
               	 		echo "LOGENGINE ERROR, NewSubEntry must be followed by text!" >>$LOGFILE
               	 		else
				echo "[`/bin/date`] --> $2" >>$LOGFILE
			fi
			;;

		End)
				echo "[`/bin/date`] * * * nensync is exiting... * * *" >>$LOGFILE
			;;
	
		*)
				echo "THE LOGENGINE RECIEVED AN UNKNOWN PARAMETER: $1" >>$LOGFILE
			;;
	esac
}


filecheck ()
{
	# This function check if the file, param#1, exists or not
	# If file does not exist, it will display an error message and halt
	# If file does exist, the nensync continues
	# Regardless, it will log the outcome
	# SYNTAX filecheck [FILE]
	
		# Checking file

		log_engine NewEntry "Checking if file "$1" exists.."
		if [ -f $1 ];
			then
				log_engine NewSubEntry "File "$1" exists!"
			else
				gfx failed
				log_engine NewSubEntry "FATAL: File "$1" does not found!"
				echo "FATAL ERROR: Requested file "$1" not found!"
				echo "NENsync aborted!"
			exit
		fi
}

gfx splash
log_engine Start

gfx header
gfx arrow "Initializing Nordic Encrytion Net node sync..."
log_engine NewEntry "Initalizing Nordic Encryption Net node sync"

# --- Filecheck
# We need to make sure necessary files are present
gfx arrow "Verifying cfg files..."
log_engine NewSubEntry "Verifying cfg files..."
gfx subarrow "node.lst"
filecheck node.lst
gfx subarrow "server.cfg"
filecheck server.cfg
gfx subarrow "client.cfg"
filecheck client.cfg
log_engine NewSubEntry "Files verified!"
# --- Filecheck finished



##############################################
# - Read and sync with nodes in index file - #
##############################################

for NODECFG in `cat /home/nen/node.lst`;
do
	# We want to read NODECFG, which consists of the hostname and the port, seperated by a ":"
	# and split it into two variables, NODE and PORT
	NODE=`echo $NODECFG | cut -d: -f1`
	PORT=`echo $NODECFG | cut -d: -f2`
	
	# If PORT is empty, we will set it to the default NEN port (14514)
	if [ $PORT = $NODE ] ; then
		log_engine NewSubEntry "Custom port not specified, setting port to default (14514)"
		PORT=14514			
	fi

	gfx header
	gfx arrow "Starting sync with node $GREEN$NODE$DEF:"
	
	log_engine NewEntry "Starting sync with node $NODE"

	gfx subarrow "Reading node configuration..."
	log_engine NewSubEntry "Fetching and checking node configuration via SSH"
	for i in `ssh -p $PORT nen@$NODE cat server.cfg`; do export "$i"; done 2>/dev/null

# Debug
#	echo "SPEEDLIMIT:"$SPEEDLIMIT""
#	echo "REMOTEPATH: "$REMOTEPATH""
#	echo "NODECFG: "$NODECFG""
#	echo "NODE: "$NODE""
#	echo "PORT: "$PORT""
#	sleep 10
	
		gfx subarrow "Verifying node configuration..."
		if [ -z "$REMOTEPATH" ]; then 	# -n tests to see if the argument is non empty
				log_engine NewSubEntry "SYNC ABORTED: Remotepath not set in remote server.cfg"
				gfx failed
				echo
				gfx subspace "$RED""SYNC ABORTED:$DEF Remote directory not set, aborting"
				gfx subspace "Please make sure the node $GREEN$NODE$DEF is valid"
				gfx subspace "and that the node is compatible with nensync $VERSION"
				echo	
		
		else 
			case "$ENABLED" in
					N)
					gfx subarrow "$RED""SYNC ABORTED:$DEF Node online, but is not configured to allow sync."
					log_engine NewSubEntry "SYNC ABORTED: Node online, but is configured to not accept incoming connections."
					;;
				*)
					log_engine NewSubEntry "Displaying MOTD"
					gfx subarrow "Displaying message from node"
					ssh -p $PORT nen@$NODE cat motd.txt 2>/dev/null
					
					echo
					gfx subarrow "Syncing..."
					echo "Sync started `/bin/date`"
					log_engine NewSubEntry "Initiating rsync: rsync -avz --progress --bwlimit=$SPEEDLIMIT -e "ssh -p $PORT" $REMOTEUSER@$NODE:$REMOTEPATH $LOCALPATH"
				
					rsync -avz --progress --bwlimit=$SPEEDLIMIT -e "ssh -p $PORT" $REMOTEUSER@$NODE:$REMOTEPATH $LOCALPATH
				
					echo
					gfx arrow "$BLUE""Finished sync with node $NODE.$DEF (`/bin/date`)"
					gfx line
					log_engine NewSubEntry "Finished sync with node $NODE."
					;;
			esac
		fi	

	echo
	echo Proceeding to next node...
	sleep 3
	clear

done
gfx line
echo
log_engine NewEntry "Reached end of node.lst"

echo Reached end of node.lst.
echo Please review sync.log and rsync.log for details

log_engine End
