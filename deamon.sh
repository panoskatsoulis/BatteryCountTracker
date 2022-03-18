#!/bin/bash

source batteryTools.sh

prettyEcho "Battery cycle count tracking started."

while true; do
    prettyEcho "Sleeping 30 sec"
    sleep 30
    status=`get_status`
    prettyEcho "Status is $status"
    [ $status != "Charging" ] && continue
    ##
    prettyEcho "Charging function starts now"
    startCharging
    [ "$?" == "0" ] || { prettyEcho "startCharging function returned error."; exit 1; }
    prettyEcho "Charging function finished now"
    ##
    prettyEcho "last-charge is $(get_last_charge) [full $(get_charge_full)]"
    if (( `get_last_charge` >= `get_charge_full` )); then
	update_charge_count
	prettyEcho "charge-count updated [new count $(get_charge_count)]"
    fi
done

exit 0
