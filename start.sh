#!/bin/bash

# This script monitors the .xcf and env.sh files for changes and triggers an export process when modifications are detected.
# The monitored files are defined in the MonitoredFileList array. When a change is detected, the script updates the
# environment variables and exports the necessary files for iRacing. It assumes iRacing is running and displaying 
# the car model. The exported files are then copied to the appropriate directories.

# MonitoredFileList: List of files to be monitored for changes.
# exportTargets(): Function to handle the export process when a monitored file is changed.
# loadModDateByFile(): Function to initialize the modification date map for monitored files.
# checkModifications(): Function to check for file modifications and trigger the export process if needed.
# The script runs indefinitely, checking for file modifications every 5 seconds.

MonitoredFileList=(
    [0]="*.xcf" 
    [1]="env.sh")

exportTargets() {
    env_file_name="env.sh"

    if [[ "$1" != "$env_file_name" ]];
    then
        ./export.sh
    fi

    source ./env.sh

    # the following part assumes that iRacing is running and displaying the car model

    cp ${ACTIVE_DRIVER_NAME}.tga ${I_RACING_PAINT_DIR}/car_${ACTIVE_DRIVER_ID}.tga
    cp ${ACTIVE_DRIVER_NAME}_spec.tga ${I_RACING_PAINT_DIR}/car_spec_${ACTIVE_DRIVER_ID}.tga

    # wait for the mip file
    sleep 5

    # copy back to the repo's export dir using Arturo's ID since it's already like that and it doesn't really matter
    cp ${I_RACING_PAINT_DIR}/car_${ACTIVE_DRIVER_ID}.tga ${ACTIVE_DRIVER_NAME}_exports/car_174470.tga
    cp ${I_RACING_PAINT_DIR}/car_spec_${ACTIVE_DRIVER_ID}.tga ${ACTIVE_DRIVER_NAME}_exports/car_spec_174470.tga
    cp ${I_RACING_PAINT_DIR}/car_spec_${ACTIVE_DRIVER_ID}.mip ${ACTIVE_DRIVER_NAME}_exports/car_spec_174470.mip

}

declare -A FileToDateMap

loadModDateByFile() {
    echo "Scanning Source Files for Monitoring:"
    for i in ${MonitoredFileList[*]}; do
        dt=$(date -r $i)
        echo $i "    -->>    " $dt
        FileToDateMap[$i]=$dt
    done

    echo
    echo "Making Fresh Copy:"

    exportTargets ""
}

checkModifications() {
    for i in ${MonitoredFileList[*]}; do
        dt=$(date -r $i)
        oldDt=${FileToDateMap[$i]}
        if [[ "$oldDt" != "$dt" ]];
        then
            echo
            echo $i " was modified"
            FileToDateMap[$i]=$dt
            exportTargets $i
        fi
    done
}

loadModDateByFile

echo
echo "Monitoring Active; Press [CTRL+C] to stop..."

while :
do
    checkModifications
	sleep 5
done

echo

