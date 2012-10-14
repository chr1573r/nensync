#!/bin/bash

# Pretty colours!
DEF="\x1b[0m"
WHITE="\e[0;37m"
BLACK="\x1b[30;01m"
LIGHTBLACK="\x1b[30;11m"
BLUE="\x1b[34;01m"
LIGHTBLUE="\x1b[34;11m"
CYAN="\x1b[36;01m"
LIGHTCYAN="\x1b[36;11m"
GRAY="\x1b[37;11m"
LIGHTGRAY="\x1b[37;01m"
GREEN="\x1b[32;01m"
LIGHTGREEN="\x1b[32;11m"
PURPLE="\x1b[35;01m"
LIGHTPURPLE="\x1b[35;11m"
RED="\x1b[31;01m"
LIGHTRED="\x1b[31;11m"
YELLOW="\x1b[33;01m"
LIGHTYELLOW="\x1b[33;11m"

# DialogRC support
DIALOGRC=$NENDIR/sys/dialogrc

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
				if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: ok" ; fi
				echo
				;;	
			
		failed)
		        echo -e "                         "$WHITE"["$RED"FAILED"$WHITE"]$DEF"
		        if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: failed" ; fi
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
			if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: splash_nensync" ; fi
			sleep 2
			clear
			
			;;
		
		line)
			echo -e "$RED------------------------------$DEF"
			if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: line" ; fi
			;;

		header)
			clear
			echo -e "$BLUE""///"$GREEN" $APPNAME "$BLUE"/// "$GREEN"$HOSTNAME"
			if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: header [$2]" ; fi
			echo
			;;
		arrow)
			echo -e "$RED""--""$YELLOW""> ""$DEF""$2"
			log_engine NewEntry "$2"
			if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: arrow [$2]" ; fi
			echo
			;;
		subarrow)
			echo -e "$RED""----""$YELLOW""> ""$DEF""$2"
			log_engine NewSubEntry "$2"
			if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: subarrow [$2]" ; fi
			;;
		fuarrow)
			echo -e "$APPNAME"":"$CYAN"$2"$YELLOW"> "$DEF"$3"
			log_engine NewSubEntry "$3"
			if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: fuarrow for $2 [$3]" ; fi
			;;
		subspace)
			echo -e "     $2"
			if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Rendered: subspace" ; fi
			;;
		colourtest)
			echo "#### Colour test"
			echo -e "$WHITE" WHITE
			echo -e "$BLACK" BLACK
			echo -e "$LIGHTBLACK" LIGHTBLACK
			echo -e "$BLUE" BLUE
			echo -e "$LIGHTBLUE" LIGHTBLUE
			echo -e "$CYAN" CYAN
			echo -e "$LIGHTCYAN" LIGHTCYAN
			echo -e "$GRAY" GRAY
			echo -e "$LIGHTGRAY" LIGHTGRAY
			echo -e "$GREEN" GREEN
			echo -e "$LIGHTGREEN" LIGHTGREEN
			echo -e "$PURPLE" PURPLE
			echo -e "$LIGHTPURPLE" LIGHTPURPLE
			echo -e "$RED" RED
			echo -e "$LIGHTRED" LIGHTRED
			echo -e "$YELLOW" YELLOW
			echo -e "$LIGHTYELLOW" LIGHTYELLOW
			echo -e "$DEF" DEFAULT
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
			echo "$APPNAME version $APPVERSION - Nordic Encryption Net (C) 2011-2012" >>$LOGFILE
			echo >>$LOGFILE
			echo "This session was invoked at: `/bin/date`" >>$LOGFILE
			echo >>$LOGFILE
			;;

		LogSize)
			# Set variable $LOGSIZE as the result of how many lines wc says the logfile contains
			LOGSIZE=$(wc -l < $LOGFILE)
			;;

		NewEntry)
			if [ -z "$2" ]; then
				echo "LOGENGINE ERROR, NewEntry must be followed by text!" >>$LOGFILE
			else
				echo "[`/bin/date`] $2" >>$LOGFILE
			fi
			;;

		NewSubEntry)
        		if [ -z "$2" ]; then
           	    	echo "LOGENGINE ERROR, NewSubEntry must be followed by text!" >>$LOGFILE
          	 	else
					echo "[`/bin/date`] --> $2" >>$LOGFILE
				fi
				;;

		FunctionLog)
        	        if [ -z "$2" ]; then
               	 		echo "LOGENGINE ERROR, FunctionLog must be followed by text!" >>$LOGFILE
               	 	else
						echo "[`/bin/date`][$FUNCTIONNAME] $2" >>$LOGFILE
					fi
					;;

		FunctionDebug)
				if [ $LOGLEVEL -gt 2 ] ; then
					if [ -z "$2" ]; then
               	 		echo "LOGENGINE ERROR, Debug must be followed by text!" >>$LOGFILE
               	 	else
						echo "[`/bin/date`][$FUNCTIONNAME-DEBUG] $2" >>$LOGFILE
					fi
				fi
				;;
		AppDebug)
				if [ $LOGLEVEL -gt 2 ] ; then
					if [ -z "$2" ]; then
               	 		echo "LOGENGINE ERROR, Debug must be followed by text!" >>$LOGFILE
               	 	else
						echo "[`/bin/date`][$APPNAME-DEBUG] $2" >>$LOGFILE
					fi
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

		if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Checking file "$1"... " ; fi

		if [ -f $1 ]; then
			if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "File "$1" exists!" ; fi
			else
				gfx failed
				log_engine NewSubEntry "FATAL: File "$1" was not found!"
				echo "FATAL ERROR: Requested file "$1" not found!"
				echo "Terminated script"
			exit
		fi
}

timer ()
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
				if [ -f /usr/bin/rsync ]; then
					echo rsync:
					gfx ok
				else
					errorsdetected="yes"
					gfx failed
				fi

				if [ -f /usr/sbin/sshd ]; then
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

syncgauge()
{
# Apply awk filter to get rsync output in numbers
awk -f $NENDIR/sys/rsync.awk $2 | \
# Apply sed filter to get rid of decimals
sed --unbuffered 's/\([0-9]*\).*/\1/' | \
dialog --backtitle $APPNAME --title "$SYNCTITLE" --gauge "$SYNCTEXT" 20 70 
# Display a gauge showing percentage
}



nenget ()
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
	if [ $LOGLEVEL -gt 2 ] ; then log_engine FunctionLog "Downloading file "$1" from $NODE" ; fi

	scp -P $PORT $SYNCUSER@$NODE:$1 $2
}

cfgkeystore ()
{
	# This function is used to interact with the cfg file keystore located in $NENDIR/keystore/
	# The keystore directory contains three sub directories, "trusted", "untrusted" and "pending"
	# cfgkeystore is used to download and verify node.cfg files from nodes before the actual file transfer takes place.
	# node.cfg files are cleaned* and stored in the different sub-folders depending on their status.
	#
	# No options are specified when calling the function, cfgkeystore uses the current values in $NODE, $PORT, $NENDIR
	# IMPORTANT: If $TRUSTPOLICY is set to 0, cfgkeystore will always trust the node specified
	# 			 and allow the parent script to continue regardless of what the node.cfg file contained.
	#
	# SYNTAX: 	cfgkeystore trust
	#			cfgkeystore untrust
	#			cfgkeystore remove
	#			cfgkeystore check
	#
	# NOT SUPPORTED:
	#			cfgkeystore wizard
	# Modes:
	#		All modes uses nenget() to download the node.cfg file from the current $NODE and then saves it as $NODE_node.cfg to $NENDIR/sys/keystore/pending.
	#		A "cleaning filter" (described below) is applied to the file and then a sha512 checksum is generated and stored as $NODE_node.cfg.sum
	#		Afterwards, the different modes determine further actions:
	#
	#		trust - cfgkeystore saves node.cfg to ../trusted and generates a new checksum for it
	#
	#		untrust - cfgkeystore saves node.cfg to ../untrusted and generates a new checksum for it.
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
	# Important!: If a node would be changed from trusted to untrusted or vice versa, you must use "cfgkeystore remove"
	# 			  and then re-add it using "cfgkeystore trust" or "cfgkeystore untrust"
	#
	# *A "clean" version, means that the cfg file is passed trough a filter which aims to remove command execution attempts
	# that could be added to node.cfg with malicious intentions. The filter is described here: http://wiki.bash-hackers.org/howto/conffile
	# cfgkeystore and it's filters are by no means bulletproof, and there are ways to pass "rouge commands" by modifying a cfg file that is sourced.
	# In other words, you should never connect to nodes you don't trust no matter what!
	
	local FUNCTIONNAME="cfgkeystore()"
	log_engine FunctionLog "Session started"
	KEYSTOREDIR=$NENDIR/sys/keystore

	# Pending/temp files
	PENDINGFILE=$KEYSTOREDIR/pending/$NODE.node.cfg
	PENDINGSUMFILE=$KEYSTOREDIR/pending/$NODE.node.cfg.sum
	CLEANEDFILE=$KEYSTOREDIR/$NODE.node.cfg_cleaned
	SAFEFILE=$NENDIR/tmp/$NODE.node.cfg_safe

	# Trusted files
	TRUSTEDFILE=$KEYSTOREDIR/trusted/$NODE.node.cfg
	TRUSTEDSUMFILE=$KEYSTOREDIR/trusted/$NODE.node.cfg.sum

	# Untrusted files
	UNTRUSTEDFILE=$KEYSTOREDIR/untrusted/$NODE.node.cfg
	UNTRUSTEDSUMFILE=$KEYSTOREDIR/untrusted/$NODE.node.cfg.sum

	#Display information in console
	log_engine FunctionLog "Fetching node configuration..."
	#Erasing any existing file with the same name
	if [ -e $PENDINGFILE ] ; then rm "$PENDINGFILE" ; fi
	# Download node.cfg from $NODE and save as set in $PENDINGFILE
	nenget node.cfg $PENDINGFILE

	# Check/Clean $PENDINGFILE

	if egrep -q -v '^#|^[^ ]*=[^;]*' "$PENDINGFILE"; then
		log_engine FunctionLog "Node configuration file seems dirty, cleaning it..."
	  # filter the original to a new file
	  egrep '^#|^[^ ]*=[^;&]*'  "$PENDINGFILE" > "$CLEANEDFILE"
	  # remove unclean file and rename cleaned file to original name
	  rm "$PENDINGFILE"
	  mv "$CLEANEDFILE" "$PENDINGFILE"
	fi

	# Create "safe" version, which basically involves a version injected with "#"
	# at the beginning of each line
	sed 's/^/#/' $PENDINGFILE > $SAFEFILE

	# Checksum node.cfg
	log_engine FunctionLog "Generating checksum..."
	sha512sum "$PENDINGFILE" > "$PENDINGSUMFILE"
	

	# Now cfgvalidator enters selected mode
	case "$1" in
			trust)
				log_engine FunctionLog "Adding $NODE to "trusted"..."
				mv $PENDINGFILE $TRUSTEDFILE
				log_engine FunctionLog "Generating checksum..."
				sha512sum "$TRUSTEDFILE" > "$TRUSTEDSUMFILE"
				log_engine FunctionLog "$NODE is now trusted."
				;;

			untrust)
				log_engine FunctionLog "Adding $NODE to "untrusted"..."
				mv $PENDINGFILE $UNTRUSTEDFILE
				log_engine FunctionLog "Generating checksum..."
				sha512sum "$UNTRUSTEDFILE" > "$UNTRUSTEDSUMFILE"
				log_engine FunctionLog  "$NODE is now untrusted."
				;;

			remove)
				log_engine FunctionLog "Removing $NODE..."
				rm $TRUSTEDFILE $TRUSTEDSUMFILE $UNTRUSTEDFILE $UNTRUSTEDSUMFILE
				log_engine FunctionLog "$NODE removed."
				;;

			check)
				log_engine FunctionLog "Checking $NODE..."
				if [ -e $TRUSTEDFILE ] ; then #Check if $TRUSTEDFILE EXISTS
					if [ -e $TRUSTEDSUMFILE ] ; then #Check if $TRUSTEDSUMFILE EXISTS
						sha512sum -c --status $TRUSTEDSUMFILE #Checksum the $TRUSTEDFILE against our stored $TRUSTEDSUMFILE
							if [ $? == 0 ] ; then #If the checksum matches, then..
								PENDINGSUM=($(sha512sum $PENDINGFILE)) # Get only the hash from $PENDINGFILE and store it in variable
								TRUSTEDSUM=($(sha512sum $TRUSTEDFILE)) # Get only the hash from $TRUSTEDFILE and store it in variable
									if [ "$PENDINGSUM" == "$TRUSTEDSUM" ] ; then # Compare the two hashes
										log_engine FunctionLog "Node cfg matches keystore" #Match!
										log_engine FunctionLog "Node is trusted for this session"
										CFGVALID=0
										CKSMSG="Node $NODE successfully verified"
									else
										log_engine FunctionLog "ERROR: Node cfg does NOT match keystore" #Mismatch!
										log_engine FunctionLog "Node $NODE can not be trusted for this session, cfg received does not match keystore"
										CFGVALID=1
										CKSMSG="Cfg recieved from $NODE has changed since the node was added.\nYou must re-confirm that you trust this node"
									fi
							
							else
								log_engine FunctionLog "ERROR: Checksum mismatch for $NODE cfg in trusted"
								log_engine FunctionLog "Node must be re-added to keystore"
								CFGVALID=1
								CKSMSG="Mismatch between stored cfg and stored checksum\nYou must re-confirm that you trust this node"
							fi

					else
						log_engine FunctionLog "ERROR: Checksum for $NODE cfg missing"
						log_engine FunctionLog "Node must be re-added to keystore"
						CFGVALID=1
						CKSMSG="Checksumfile missing in keystore, validation can not continue.\nYou must re-confirm that you trust this node"
					fi

				elif [ -e $UNTRUSTEDFILE ] ; then #Check if $UNTRUSTEDFILE EXISTS
						log_engine FunctionLog "Node found in keystore as untrusted"
						log_engine FunctionLog "Connection denied untill re-added as trusted"
						CFGVALID=1
						CKSMSG="Node flagged as untrustworthy in keystore.\nAccess denied until node is re-confirmed as trusted"
				else
					log_engine FunctionLog "$NODE not found in keystore"
					CFGVALID=1
					CKSMSG="Node not found in keystore.\nAccess denied until node is added as trusted to keystore"
				fi
				;;


			wizard)
				#Display information in console
				gfx subarrow "Node configuration unknown, displaying safe version.."
				gfx subarrow "node.cfg for $NODE - BEGIN"
				cat $SAFEFILE | more
				gfx subarrow "node.cfg for $NODE - END"
				echo "Do you trust this cfg received from $NODE? (Y/N)"
				echo "If yes, the cfg will trusted and you will be able to connect to this node"
				echo "If no, the cfg will be flagged as untrusted and node will be blocked"
				sleep 50
				;;
	esac

	# Cleaning up
	log_engine FunctionLog "Cleaning up temporary files..."
	
	if [ -e $PENDINGSUMFILE ] ; then rm "$PENDINGSUMFILE" ; fi
	if [ -e $CLEANEDFILE ] ; then rm "$CLEANEDFILE" ; fi
	if [ -e $SAFEFILE ] ; then rm "$SAFEFILE" ; fi
	
	# Bypass if TRUSTPOLICY is disabled:
	if [ "$TRUSTPOLICY" == 0 ]; then CFGVALID=0 ; CKSMSG="Trustpolicy disabled, keystore bypassed" ; TRUSTEDFILE=$PENDINGFILE ; else if [ -e $PENDINGFILE ] ; then rm "$PENDINGFILE" ; fi ; fi

	# Logging for debug purposes
	log_engine FunctionDebug "Variables used in this session:"
	log_engine FunctionDebug "CLEANEDFILE: $CLEANEDFILE"
	log_engine FunctionDebug "SAFEFILE: $SAFEFILE"
	log_engine FunctionDebug "PENDINGFILE: $PENDINGFILE"
	log_engine FunctionDebug "PENDINGSUMFILE: $PENDINGSUMFILE"
	log_engine FunctionDebug "PENDINGSUM: $PENDINGSUM"
	log_engine FunctionDebug "TRUSTEDFILE: $TRUSTEDFILE"
	log_engine FunctionDebug "TRUSTEDSUMFILE: $TRUSTEDSUMFILE"
	log_engine FunctionDebug "TRUSTEDSUM: $TRUSTEDSUM"
	log_engine FunctionDebug "UNTRUSTEDFILE: $UNTRUSTEDFILE"
	log_engine FunctionDebug "UNTRUSTEDSUMFILE: $UNTRUSTEDSUMFILE"
	log_engine FunctionDebug "TRUSTPOLICY: $TRUSTPOLICY"
	log_engine FunctionDebug "CFGVALID: $CFGVALID"
	log_engine FunctionDebug "CKSMSG: $CKSMSG"
	log_engine FunctionLog "Session ended"

}
echo Functions "gfx", "log_engine", "filecheck", "timer", "nensetup", "nenget", and "cfgkeystore" loaded
