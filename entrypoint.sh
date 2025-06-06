#!/bin/bash

# Check if EARNAPP_UUID is set and not empty
if [[ -z "$EARNAPP_UUID" ]]; then
    echo "Error: EARNAPP_UUID is missing or empty."
    echo "Run the following command to generate one:"
    echo "echo -n "sdk-node-" && head -c 1024 /dev/urandom | md5sum | tr -d ' -'"
    exit 255
fi

INFO="
##### lsb_release #####
$(lsb_release -a 2>/dev/null)

##### hostnamectl #####
$(hostnamectl 2>/dev/null)
"

echo "$INFO"

# Download EarnApp installation script
wget -qO- https://brightdata.com/static/earnapp/install.sh > /app/setup.sh

# Detect system architecture and extract version information
ARCH=$(uname -m)
VERSION=$(grep VERSION= /app/setup.sh | cut -d'"' -f2)

# Define filename based on architecture
case $ARCH in
    x86_64|amd64) filename="earnapp-x64-$VERSION" ;;
    armv7l|armv6l) filename="earnapp-arm7l-$VERSION" ;;
    aarch64|arm64) filename="earnapp-aarch64-$VERSION" ;;
    *) filename="$PRODUCT-arm7l-$VERSION" ;;  # Default fallback
esac

# Download EarnApp binary
wget --no-check-certificate https://cdn-earnapp.b-cdn.net/static/$filename -O /usr/bin/earnapp

# Prepare configuration directory and status file
mkdir -p /etc/earnapp
touch /etc/earnapp/status

# Store the EarnApp UUID
echo "$EARNAPP_UUID" > /etc/earnapp/uuid

# Set appropriate permissions
chmod -R a+rwx /etc/earnapp
chmod -R a+rwx /usr/bin/earnapp

# Start EarnApp service and register instance
sleep 3
/usr/bin/earnapp start &
sleep 3
/usr/bin/earnapp status &
sleep 3
/usr/bin/earnapp register &

# Keep the script running indefinitely
sleep 10
echo "##### Running Indefinitely #####"
tail -f /dev/null
