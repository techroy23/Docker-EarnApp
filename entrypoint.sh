#!/bin/bash

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
    echo " echo -n "sdk-node-" && head -c 1024 /dev/urandom | md5sum | tr -d ' -' "
    echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
    echo " "
    exit 255
fi

echo "### ### ### ### ### ### ### ### ###"
echo " Starting custom.sh ... "
echo "### ### ### ### ### ### ### ### ###"
if [ -f "/custom.sh" ]; then
    chmod -R a+rwx /custom.sh
    bash /custom.sh
else
    echo "Skipping custom.sh as it is not present."
fi
echo " "

GETINFO="
##### lsb_release #####
$(lsb_release -a 2>/dev/null)

##### hostnamectl #####
$(hostnamectl 2>/dev/null)
"

echo "$GETINFO"
echo " "

echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
echo " Downloading  EarnApp installation script to get the latest version of the binary ... "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
wget -qO- https://brightdata.com/static/earnapp/install.sh > /app/setup.sh
ARCH=$(uname -m)
VERSION=$(grep VERSION= /app/setup.sh | cut -d'"' -f2)
echo " "
echo "Found version $VERSION"
echo " "
case $ARCH in
    x86_64|amd64) filename="earnapp-x64-$VERSION" ;;
    armv7l|armv6l) filename="earnapp-arm7l-$VERSION" ;;
    aarch64|arm64) filename="earnapp-aarch64-$VERSION" ;;
    *) filename="$PRODUCT-arm7l-$VERSION" ;;  # Default fallback
esac
echo " "

echo "### ### ### ### ### ### ###"
echo " Download EarnApp binary "
echo "### ### ### ### ### ### ###"
echo " "
wget --no-check-certificate --progress=bar:force:noscroll "https://cdn-earnapp.b-cdn.net/static/$filename" -O /usr/bin/earnapp
echo " "

echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
echo " Setting up directory, status file, UUID and permissions ... "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"
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

echo " "
sleep 3
echo "### ### ### ### ### ###"
echo " Running Indefinitely "
echo "### ### ### ### ### ###"

# echo " "
# echo "### ### ###"
# echo " TCP DUMP "
# echo "### ### ###"
# tcpdump -l -i "$(ls /sys/class/net | grep -E '^eth[0-9]+|^ens')" -nn -q 'tcp and tcp[4:2] > 0 or udp and udp[4:2] > 0' &
# tshark -i eth0 -Y "not ssh and frame.len > 1000" -T fields -e ip.src -e ip.dst -e frame.len &
# echo " "

tail -f /dev/null
echo " "
