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
echo " Downloading EarnApp installation script to get the latest version of the binary ... "
echo "### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ### ###"

wget --verbose --output-document=/app/setup.sh https://brightdata.com/static/earnapp/install.sh
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to download EarnApp installation script."
    exit 1
fi

ARCH=$(uname -m)
VERSION=$(grep VERSION= /app/setup.sh | cut -d'"' -f2)

if [[ -z "$VERSION" ]]; then
    echo "Error: VERSION could not be determined."
    exit 1
fi

if [[ -z "$ARCH" ]]; then
    echo "Error: ARCH could not be determined."
    exit 1
fi

echo "Found version $VERSION"
echo " "
case $ARCH in
    x86_64|amd64) filename="earnapp-x64-$VERSION" ;;
    armv7l|armv6l) filename="earnapp-arm7l-$VERSION" ;;
    aarch64|arm64) filename="earnapp-aarch64-$VERSION" ;;
    *) filename="$PRODUCT-arm7l-$VERSION" ;;  # Default fallback
esac

echo "### ### ### ### ### ### ###"
echo " Download EarnApp binary "
echo "### ### ### ### ### ### ###"
echo " "

wget --verbose --output-document=/usr/bin/earnapp "https://cdn-earnapp.b-cdn.net/static/$filename"
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to download EarnApp binary."
    exit 1
fi

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

echo "### ### ### ### ### ###"
echo " Running Indefinitely "
echo "### ### ### ### ### ###"

tail -f /dev/null
