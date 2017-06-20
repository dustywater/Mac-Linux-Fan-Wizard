#!/bin/bash

function help () {
    echo -e "Version: 1.0\n\nUsage: macfan OPTION [FAN] [SPEED]\n\nOptions:\nhelp = Show this help screen\nspeed = Change speed of your chosen fan\nlist = List Mac fans\ninstall = Install this script to your system\n\nThanks for using Mac Linux Fan Wizard!\n"
    exit 0
}

if [ "$1" = "speed" ]; then
    if [ -f "/sys/devices/platform/applesmc.768/$2_min" ]; then
        echo 1 > /sys/devices/platform/applesmc.768/$2_manual
        echo $3 > /sys/devices/platform/applesmc.768/$2_output
        echo "I think I changed $2's speed! :)"
        exit 0
    else
        echo "I cannot find that fan :( Run 'macfan list' to see what fans are available."
        exit 1
fi
    

if [ "$1" = "list" ]; then
    echo Here are the fans I found:
    ls /sys/devices/platform/applesmc.768/ | grep -Eo 'fan[1-9]' | sort -u | while read -r fan; do
      echo $fan ($(cat /sys/devices/platform/applesmc.768/$fan"_label")) min: $(cat /sys/devices/platform/applesmc.768/$fan"_min") max: $(cat /sys/devices/platform/applesmc.768/$fan"_max") output:$(cat /sys/devices/platform/applesmc.768/$fan"_output")
    done
    exit 0
fi

if [ "$1" = "install" ]; then
    echo I am installing myself to your Macintosh.
    pushd `dirname $0` > /dev/null
    SCRIPTPATH=`pwd -P`
    popd > /dev/null
    cd $SCRIPTPATH
    if [ -f macfan.sh ]; then
        cp macfan.sh /usr/local/bin/macfan
        # Only root can edit this file.
        sudo chown root:root /usr/local/bin/macfan
        chmod 755 /usr/local/bin/macfan
        exit 0
    else
        echo "I couldn't find macfan.sh! :( Did you rename it?" 
        exit 1
    fi
fi

if [ "$1" = "help" ]; then
help
fi

if [ "$1" = "" ]; then
help
fi
