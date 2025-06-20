#!/bin/bash

echo " "
echo "### ### ### ### ###"
echo " Starting up ... "
echo "### ### ### ### ###"
echo " "

if [[ -z "$EARNAPP_UUID" ]]; then
    echo " "
    echo "Error: EARNAPP_UUID is missing or empty."
    echo "Run the following command to generate one:"
    echo " "
    echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
    echo ' echo -n "sdk-node-" && head -c 1024 /dev/urandom | md5sum | tr -d " -" '
    echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
    echo " "
    exit 255
fi

echo " "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
echo " Setting up lsb_release and hostnamectl ... "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
bash /custom.sh 
echo " "
echo "Container Info:"
echo " "
echo "lsb_release"
/usr/bin/lsb_release
echo " "
echo "hostnamectl"
/usr/bin/hostnamectl

echo " "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
echo " Setting up directory, status file, UUID and permissions ... "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
echo " "
printf $EARNAPP_UUID > /etc/earnapp/uuid
echo "Found UUID : $EARNAPP_UUID"
touch /etc/earnapp/status
chmod a+wr /etc/earnapp/
chmod a+wr /etc/earnapp/status

echo " "
echo "### ### ### ### ### ### ### ### ### ### ### ###"
echo " Start EarnApp service and register instance "
echo "### ### ### ### ### ### ### ### ### ### ### ###"
echo " "
sleep 5
earnapp start &
sleep 5
earnapp register &
sleep 5
earnapp status &
sleep 5
earnapp run &

echo " "
echo "### ### ### ### ### ### ###"
echo " Running Indefinitely ... "
echo "### ### ### ### ### ### ###"
tail -f /dev/null
echo " "
