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

echo "### ### ### ### ### ### ### ### ###"
echo " Running custom.sh (if present) ... "
echo "### ### ### ### ### ### ### ### ###"
if [ -f "/custom.sh" ]; then
    chmod -R a+rwx /custom.sh
    bash /custom.sh
    GETINFO="
    ##### lsb_release #####
    $(lsb_release -a 2>/dev/null)

    ##### hostnamectl #####
    $(hostnamectl 2>/dev/null)
    "

    echo "$GETINFO"
    echo " "
else
    echo "Skipping custom.sh as it is not present."
fi
echo " "

echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
echo " Setting up directory, status file, UUID and permissions ... "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
echo " "
mkdir -p /etc/earnapp
touch /etc/earnapp/status
echo "$EARNAPP_UUID" > /etc/earnapp/uuid
chmod -R a+rwx /etc/earnapp
chmod -R a+rwx /usr/bin/earnapp
echo " "

echo "### ### ### ### ### ### ### ### ### ### ### ###"
echo " Start EarnApp service and register instance "
echo "### ### ### ### ### ### ### ### ### ### ### ###"
echo " "
sleep 3
/usr/bin/earnapp start
echo " "
sleep 3
/usr/bin/earnapp status
echo " "
sleep 3
/usr/bin/earnapp register

echo "### ### ### ### ### ###"
echo " Running Indefinitely "
echo "### ### ### ### ### ###"

tail -f /dev/null
