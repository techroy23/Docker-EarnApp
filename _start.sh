#!/bin/bash

echo "### ### ### ### ###"
echo " Starting up ... "
echo "### ### ### ### ###"
echo " "

if [[ -z "$EARNAPP_UUID" ]]; then
    echo "Error: EARNAPP_UUID is missing or empty."
    echo "Run the following command to generate one:"
    echo " "
    echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
    echo ' echo -n "sdk-node-" && head -c 1024 /dev/urandom | md5sum | tr -d " -" '
    echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
    echo " "
    exit 255
fi

echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
echo " Setting up directory, status file, UUID and permissions ... "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"

cp /download/earnapp /usr/bin/earnapp
chmod a+wr /etc/earnapp/
touch /etc/earnapp/status
chmod a+wr /etc/earnapp/status
printf $EARNAPP_UUID > /etc/earnapp/uuid

echo "### ### ### ### ### ### ### ### ### ### ### ###"
echo " Start EarnApp service and register instance "
echo "### ### ### ### ### ### ### ### ### ### ### ###"

sleep 5
echo " "
echo "[earnapp start]"
earnapp start

sleep 5
echo " "
echo "[earnapp run]"
earnapp run
