#!/bin/bash

function get_charge_full() { cat /sys/class/power_supply/BAT0/charge_full; }
function get_charge_now() { cat /sys/class/power_supply/BAT0/charge_now; }
function get_status() { cat /sys/class/power_supply/BAT0/status; }

function get_last_charge() { cat /home/kpanos/Workspace/BatteryCountTracker/last_charge; }
function get_charge_count() { cat /home/kpanos/Workspace/BatteryCountTracker/charge_count; }

function update_last_charge() {
    echo $(( `get_last_charge` + $1 )) > /home/kpanos/Workspace/BatteryCountTracker/last_charge
}
function update_charge_count() {
    echo $(( `get_charge_count` + 1 )) > /home/kpanos/Workspace/BatteryCountTracker/charge_count
}

function prettyEcho() {
    echo "$(date) | $1"
}

function startCharging() {
    set -e
    full_charge=`get_charge_full`
    thisCharge=-1
    while [ `get_status` == "Charging" ]; do
	thisCharge=$(( `get_charge_now` - `get_last_charge` ))
	update_last_charge $thisCharge
	prettyEcho "Charge added in this iteration $thisCharge [last_cycle_charge $(get_last_charge)]"
	prettyEcho "Sleeping for 10 sec"
	sleep 10
    done
    prettyEcho "Charging stopped , last_cycle_charge=$(get_last_charge) , charge_full=$(get_charge_full)"
    set +e
    return 0
}
