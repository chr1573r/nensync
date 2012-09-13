#!/bin/bash

# Declare variables
nenlib_version=0.1

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
	
	case "$1" in

		ok)
			echo -e "                         "$WHITE"[  "$GREEN"OK"$WHITE"  ]$DEF"
				echo
				;;	
	
		failed)
		        echo -e "                         "$WHITE"["$RED"FAILED"$WHITE"]$DEF"
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
			sleep 2
			clear
			
			;;
		
		line)
			echo -e "$RED------------------------------$DEF"
			;;

		header)
			clear
			echo -e "$BLUE""///"$GREEN" $APPNAME "$BLUE"/// "$GREEN"$HOSTNAME"
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
				echo "If this is the first time you are running nensync,"
				echo "please run "nensync.sh --setup" to configure nensync"
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

cfgvalidator ()
{
	# This function is used whenever we want to validate a cfg file.
	# After validation, the cfg file is sourced.
	# 
	# SYNTAX: 	cfgvalidator <interactive OR clean> <file>
	#			cfgvalidator compare <new and untrusted cfgfile> <old and trusted cfgfile>
	#			cfgvalidator add <file>
	# 
	# Modes:
	#		interactive - cfgvalidator displays a cleaned(look below) and secured version of the cfg file (where every line is injected with "#" first)
	#		clean - cfgvalidator cleans the cfg file in conjunction with what is described here: http://wiki.bash-hackers.org/howto/conffile
	#		compare - compares a cfgfile against a trusted cfgfile using sha512sum
	#		add - 
	#
	# cfgvalidator is by no means bulletproof, and there are ways to pass "rouge commands" by modifying a cfg file that is sourced
	# The most safe option is interactive, as it requires that the user confirms that the cfg file looks alright
	# The trusted cfg files checksums are stored in /sys/trustedcfg and should be stored with the namestandard nodehostname_filename.sum

}
echo Functions "gfx", "log_engine", "filecheck", "timer", "nensetup" , "cfgvalidator" loaded
