#!/bin/bash

# Pretty colours!
DEF="\x1b[0m"
WHITE="\e[0;37m"
BLUE="\x1b[34;01m"
CYAN="\x1b[36;01m"
GREEN="\x1b[32;01m"
RED="\x1b[31;01m"
GRAY="\x1b[37;01m"
YELLOW="\x1b[33;01m"

gfx ()
{
	# This function provides "[  OK  ]" and "[FAILED]" text output (followed by a line break)
	# SYNTAX: gfx [element] [element text, if applicable]
	# Valid elements:
	#	Feedback gfx:
	#			"ok" - Prints "[  OK  ]" with green text
	#			"failed" - Prints "[FAILED]" with red text
	#	Design gfx:
	#			"splash_nensync" - The nensync splashscreen, logo made possible by http://www.network-science.de/ascii/
	#			"line" - Draws a red line (-----)
	#			"header" - adds a yellow line, echos param $2, adds a yellow line again
	#	Error gfx:
	#			
	# "gfx ok" will print "[  OK  ]", while "gfx failed" will print "[FAILED]"
	# 
	# Actions performed by gfx() are also logged depending on $LOGLEVEL
	local FUNCTIONNAME="gfx()"

	case "$1" in

		ok)
			echo -e "                         "$WHITE"[  "$GREEN"OK"$WHITE"  ]$DEF"
				if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Rendered: ok" ; fi
				echo
				;;	
			
		failed)
		        echo -e "                         "$WHITE"["$RED"FAILED"$WHITE"]$DEF"
		        if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Rendered: failed" ; fi
				echo
			;;
		
		splash_nensync)
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
			echo -e "$GREEN""          nensync version $APPVERSION"$DEF" - " $BLUE"Nordic Encryption Net"$DEF" (C) "$BLUE"2011-2012"$DEF
			if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Rendered: splash_nensync" ; fi
			sleep 2
			clear
			
			;;
		
		line)
			echo -e "$RED------------------------------$DEF"
			if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Rendered: line" ; fi
			;;

		header)
			clear
			echo -e "$BLUE""///"$GREEN" $APPNAME "$BLUE"/// "$GREEN"$HOSTNAME"
			if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Rendered: header" ; fi
			echo
			;;
		arrow)
			echo -e "$RED""--""$YELLOW""> ""$DEF""$2"

			log_engine NewEntry "$2"
			if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Rendered: arrow" ; fi
			echo
			;;
		subarrow)
			echo -e "$RED""----""$YELLOW""> ""$DEF""$2"
			log_engine NewSubEntry "$2"
			if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Rendered: subarrow" ; fi
			;;
		
		subspace)
			echo -e "     $2"
			if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Rendered: subspace" ; fi
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
	
	# Declare logfile depending on what app calls this function
	LOGFILE=$NENDIR/sys/logs/$APPNAME.log

	case "$1" in

		Start)
			echo >>$LOGFILE
			echo >>$LOGFILE
			echo "----------------------------------------------------------" >>$LOGFILE
			echo "$APPNAME version $APPVERSION - Nordic Encryption Net (C) 2011" >>$LOGFILE
			echo >>$LOGFILE
			echo "This session was invoked  at: `/bin/date`" >>$LOGFILE
			echo >>$LOGFILE
			;;

		NewEntry)
			if [ -z "$2" ]
				then
					echo "LOGENGINE ERROR, NewEntry must be followed by text!" >>$LOGFILE
				else
					#Replace any color codes found in $2 with test
					local 2=${2/\x1b[0m/test}
					local 2=${2/\e[0;37m/test}
					local 2=${2/\x1b[34;01m/test}
					local 2=${2/\x1b[36;01m/test}
					local 2=${2/\x1b[32;01m/test}
					local 2=${2/\x1b[31;01m/test}
					local 2=${2/\x1b[37;01m/test}
					local 2=${2/\x1b[33;01m/test}
					echo "[`/bin/date`] $2" >>$LOGFILE
				fi
			;;

		NewSubEntry)
        	if [ -z "$2" ]
        		then
               		echo "LOGENGINE ERROR, NewSubEntry must be followed by text!" >>$LOGFILE
               	else
					#Replace any color codes found in $2 with test
					local 2=${2/\x1b[0m/test}
					local 2=${2/\e[0;37m/test}
					local 2=${2/\x1b[34;01m/test}
					local 2=${2/\x1b[36;01m/test}
					local 2=${2/\x1b[32;01m/test}
					local 2=${2/\x1b[31;01m/test}
					local 2=${2/\x1b[37;01m/test}
					local 2=${2/\x1b[33;01m/test}

					echo "[`/bin/date`] --> $2" >>$LOGFILE
				fi
			;;

		FunctionLog)
        	        	if [ -z "$2" ]
               	 		then
               	 		echo "LOGENGINE ERROR, FunctionLog must be followed by text!" >>$LOGFILE
               	 		else
				echo "[`/bin/date`][$FUNCTIONNAME] $2" >>$LOGFILE
			fi
			;;

		End)
				echo "[`/bin/date`] * * * $APPNAME is terminating... * * *" >>$LOGFILE
			;;
	
		*)
				echo "THE LOG ENGINE RECIEVED AN UNKNOWN PARAMETER: $1" >>$LOGFILE
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
	local FUNCTIONNAME="filecheck()"
	
		# Checking file

		if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Checking file "$1"... " ; fi
		if [ -f $1 ];
			then
				if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "File "$1" exists!" ; fi
			else
				gfx failed
				log_engine NewSubEntry "FATAL: File "$1" was not found!"
				echo "FATAL ERROR: Requested file "$1" not found!"
				echo "Terminated script"
			exit
		fi
}

timer()
{
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
	local FUNCTIONNAME="timer()"
	if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "invoked!" ; fi

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

nensetup ()
{
	# This function contains an install wizard/setup
	
	gfx header
	gfx arrow "nensync setup wizard"
	echo "Welcome to the nensync setup wizard."
	echo "Select the operation you wish to perform:"
	gfx subarrow "1. Run first time setup"
	gfx subarrow "2. Adjust nensync configuration"
	gfx subarrow "3. Display current nensync server/client settings"
	gfx subarrow "X. Abort nensync setup wizard"
	echo
	echo -n "Select one of the options above and press [ENTER]:"
	read selection
	
		case "$selection" in
		
			1)
				gfx header
				gfx arrow "nensync setup wizard: First time setup"
				echo "(Please note that this setup will overwrite any existing nensync config!)"
				echo
				gfx subarrow "Checking if required software is installed.."
				if [ -f /usr/bin/rsync ]
					then
						echo rsync:
						gfx ok
					else
						errorsdetected="yes"
						gfx failed
				fi

				if [ -f /usr/sbin/sshd ]
					then
						echo sshd:
						gfx ok
					else
						errorsdetected="yes"
						gfx failed
					gfx subarrow "1. .. a nensync client"
					gfx subarrow "2. .. a nensync server"
					gfx subarrow "3. .. both a nensync client and server"
					gfx subarrow "X. Abort nensync setup wizard"
				fi
				;;
			2)
				echo $selection
				;;
			3)
				echo $selection
				;;
			4)
				echo $selection
				;;
			X)
				nensetup
		esac	
}

nenget()
{
	# Function that fetches a single file or directory from a node
	# Uses variables $NODE $SYNCUSER $PORT and $NENDIR
	#
	# SYNTAX: nenget <file> <savelocation>
	#
	# <file> is relative to the node's basedir
	# e.g "nenget node.cfg $NENDIR/tmp/node.cfg" would download 
	# the file node.cfg in the homedir of $NODE and save it locally to the tmp directory
	local FUNCTIONNAME="nenget()"

	echo -e "Downloading file "$BLUE"$1"$DEF" from "$GREEN"$NODE"$DEF"..."
	if [ $LOGLEVEL > 2 ] ; then log_engine FunctionLog "Downloading file "$1" from $NODE" ; fi

	scp -P $PORT $SYNCUSER@$NODE:$1 $2
}

cfgkeystore ()
{
	# This function is used to interact with the cfg file keystore located in $NENDIR/keystore/
	# The keystore directory contains three sub directories, "trusted", "untrusted" and "pending"
	# cfgkeystore is used to download and verify node.cfg files from nodes before the actual file transfer takes place.
	# node.cfg files are "cleaned" (described below) and stored in the different sub-folders depending on their status.
	#
	# No options are specified when calling the function, as cfgkeystore uses the current values in $NODE, $PORT, $NENDIR
	# IMPORTANT: If $TRUSTPOLICY is set to 0, cfgkeystore will always trust the node specified and allow the parent script to continue regardless of what the node.cfg file contained.
	#
	# SYNTAX: 	cfgkeystore add
	#			cfgkeystore remove
	#			cfgkeystore check
	# 
	#		
	# Modes:
	#		All modes uses nenget() to download the node.cfg file from the current $NODE and then saves it as $NODE_node.cfg to $NENDIR/sys/keystore/pending.
	#		A "cleaning filter" (described below) is applied to the file and then a sha512 checksum is generated and stored as $NODE_node.cfg.sum
	#		Afterwards, the different modes determine further actions:
	#
	#		add - The cfg file gets injected with a "#" at the begining of each line and the file is displayed in console.
	#			  A prompt asks the end-user on the basis of the node.cfg whether this node should be trusted
	#			  If the user accepts the cfg file, both the cfg file and checksum file is moved from ../pending to ../trusted.
	#			  If the user declines the cfg file, both the cfg file and checksum file is moved from ../pending to ../untrusted
	#			  In cases where a host is already stored as trusted/untrusted, cfgkeystore will display both files, and ask to trust/untrust the new file
	#
	#		remove - cfgkeystore removes node.cfg/node.cfg.sum for the $NODE from ../trusted and ../untrusted
	#		
	#		check - cfgkeystore checks if the current $NODE's node.cfg is stored in the keystore.
	#				If it is found in ../untrusted, $CFGVALID is set to 0 and information is sent to console.
	#				If it is found in ../trusted, the file is checksummed and compared to the stored checksum.
	#				In the case of a perfect checksum match, $CFGVALID is set to 1 and a message is sent to console
	#				Otherwise a warning will be displayed and $CFGVALID is set to 0.
	#				The host must be added again via cfgkeystore add.
	#
	# A "clean" version, means that the cfg file is passed trough a filter which aims to remove command execution attempts
	# that could be added to node.cfg with malicious intentions. The filter is described here: http://wiki.bash-hackers.org/howto/conffile
	# cfgkeystore and it's filters are by no means bulletproof, and there are ways to pass "rouge commands" by modifying a cfg file that is sourced.
	# In other words, you should never connect to nodes you don't trust no matter what!
	local FUNCTIONNAME="cfgkeystore()"

	PENDINGFILE='$NENDIR/sys/keystore/pending/$NODE_node.cfg'
	PENDINGSUM='$NENDIR/sys/keystore/pending/$NODE_node.cfg.sum'
	CLEANEDFILE='$NENDIR/sys/keystore/pending/$NODE_node.cfg_cleaned'


		#Display information in console
	gfx subarrow "Fetching node configuration..."
	log_engine NewSubEntry "Fetching node configuration..."
	# Download node.cfg from $NODE and save as set in $PENDINGFILE
	nenget node.cfg $PENDINGFILE

	# Check/Clean $PENDINGFILE

	if egrep -q -v '^#|^[^ ]*=[^;]*' "$PENDINGFILE"; then
		gfx subarrow "Node configuration file seems dirty, cleaning it..."
		log_engine NewSubEntry "Node configuration file seems dirty, cleaning it..." >&2
	  # filter the original to a new file
	  egrep '^#|^[^ ]*=[^;&]*'  "$PENDINGFILE" > "$CLEANEDFILE"
	  # remove unclean file and rename cleaned file to original name
	  rm "$PENDINGFILE"
	  mv "$CLEANEDFILE" "$PENDINGFILE"
	fi

	# Checksum node.cfg
	sha512sum "$PENDINGFILE" >> "$PENDINGSUM"
	gfx subarrow "Generating checksum..."

	# Now cfgvalidator enters selected mode

	case "$1" in
			add)
				#Display information in console


				


}
echo Functions "gfx", "log_engine", "filecheck", "timer", "nensetup", "nenget", and "cfgkeystore" loaded
