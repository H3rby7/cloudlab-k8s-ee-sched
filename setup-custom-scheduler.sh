#!/bin/sh

set -x

# Grab our libs
. "`dirname $0`/setup-lib.sh"

if [ -f $OURDIR/setup-custom-scheduler-done ]; then
    echo "setup-custom-scheduler already ran; not running again"
    exit 0
fi

logtstart "custom-scheduler"

############################## SETUP SCRIPT FOR CUSTOM SCHEDULER - START ##############################

# add code to intall the custom scheduler here.
echo "No custom scheduler, using kubernetes default"


############################## SETUP SCRIPT FOR CUSTOM SCHEDULER - END ##############################

logtend "custom-scheduler"

touch $OURDIR/setup-custom-scheduler-done

exit 0
