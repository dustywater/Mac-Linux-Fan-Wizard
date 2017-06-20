#!/bin/bash

install_dir="/usr/local/bin"

function help () {
    echo -e "Version: 1.0\n\nUsage: macfan OPTION [FAN] [SPEED]\n\nOptions:\nhelp = Show this help screen\nspeed = Change speed of your chosen fan\nlist = List Mac fans\ninstall = Install this script to your system\n\nThanks for using Mac Linux Fan Wizard!\n"
    exit 0
}

function checkperm () {
    if [ "$EUID" -ne 0 ]
        then echo "You need to run me with root permissions :("
        exit 1
    fi
}

if [ "$1" = "speed" ]; then
    if [ -f "/sys/devices/platform/applesmc.768/$2_min" ]; then
        checkperm
        echo 1 > /sys/devices/platform/applesmc.768/$2_manual
        echo $3 > /sys/devices/platform/applesmc.768/$2_output
        echo "I think I changed $2's speed! :)"
        exit 0
    else
        echo "I cannot find that fan :( Run 'macfan list' to see what fans are available."
        exit 1
    fi
fi
    

if [ "$1" = "list" ]; then
    echo Here are the fans I found:
    ls /sys/devices/platform/applesmc.768/ | grep -Eo 'fan[1-9]' | sort -u | while read -r fan; do
      echo $fan ($(cat /sys/devices/platform/applesmc.768/$fan"_label")) min: $(cat /sys/devices/platform/applesmc.768/$fan"_min") max: $(cat /sys/devices/platform/applesmc.768/$fan"_max") output:$(cat /sys/devices/platform/applesmc.768/$fan"_output")
    done
    exit 0
fi

if [ "$1" = "install" ]; then
    checkperm
    pushd `dirname $0` > /dev/null
    SCRIPTPATH=`pwd -P`
    popd > /dev/null
    cd $SCRIPTPATH
    if [ -f macfan.sh ]; then
        if [ "$SCRIPTPATH" = "$install_dir" ]; then
            echo "You cannot install me on top of myself... Dummy"
            exit 1
        fi
        echo -e "I am installing myself to your Macintosh...\nInstall dir: $install_dir"
        cp macfan.sh $install_dir/macfan
        # Only root can edit this file.
        sudo chown root:root $install_dir/macfan
        chmod 755 $install_dir/macfan
        if [ -f "$install_dir/macfan" ]; then
            echo -e "Installation success! SHA1: "$(sha1sum "$install_dir/macfan")
            exit 0
        else
            echo "Installation failed! ;_;"
            exit 1
        fi
    else
        if [ $SCRIPTPATH == 
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
