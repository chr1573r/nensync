#!/bin/bash

# Declare variables

APPNAME=nensync
APPVERSION="0.7.6"
# Get directory where nensync.sh is stored
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Read variables from cfg file
source $DIR/../cfg/nen.cfg

# Set additional variables that uses the one previously declared

clear

echo nensync loading..
echo Declaring functions...

# We need to load functions fron nenlib.sh:
source $NENDIR/bin/nenlib.sh

gfx splash_nensync
log_engine Start

gfx header
gfx arrow "Initializing Nordic Encrytion Net node sync..."
log_engine NewEntry "Initalizing Nordic Encryption Net node sync"
# --- Filecheck
# We need to make sure necessary files are present
gfx arrow "Verifying important nen files..."
log_engine NewSubEntry "Verifying important nen files..."
gfx subarrow "node.lst"
filecheck $NENDIR/cfg/node.lst
log_engine NewSubEntry "Files verified!"
# --- Filecheck finished



##############################################
# - Read and sync with nodes in index file - #
##############################################

for NODECFG in `cat $NENDIR/cfg/node.lst`;
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

	gfx subarrow "Fetching node configuration..."
	log_engine NewSubEntry "Fetching node configuration..."
	nenget node.cfg tmp/$NODE_node.cfg

# Debug
	echo "ENABLED: $ENABLED"
	echo "SPEEDLIMIT: $SPEEDLIMIT"
	echo "NODEDATADIR: $NODEDATADIR"
	echo "NODECFG: $NODECFG"
	echo "NODE: $NODE"
	echo "PORT: $PORT"
	sleep 5
	
		gfx subarrow "Verifying node configuration..."
		if [ -z "$NODEDATADIR" ]; then 	# -n tests to see if the argument is non empty
				log_engine NewSubEntry "SYNC ABORTED: NODEDATADIR not set in the node's node.cfg file"
				gfx failed
				echo
				gfx subspace "$RED""SYNC ABORTED:$DEF Remote data directory not set, aborting"
				gfx subspace "Please make sure the node $GREEN$NODE$DEF is a valid node"
				gfx subspace "and that the node is compatible with your nensync version ($APPVERSION)"
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
					ssh -p $PORT $SYNCUSER@$NODE cat motd.txt 2>/dev/null
					
					echo
					gfx subarrow "Syncing..."
					echo "Sync started `/bin/date`"
					log_engine NewSubEntry "Initiating rsync: rsync -avzh --progress --bwlimit=$SPEEDLIMIT -e "ssh -p $PORT" $SYNCUSER@$NODE:$NODEDATADIR/ $DATADIR"
				
					rsync -avz --progress --bwlimit=$SPEEDLIMIT -e "ssh -p $PORT" $SYNCUSER@$NODE:$NODEDATADIR $DATADIR
				
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
