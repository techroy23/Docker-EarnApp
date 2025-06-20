# Docker-EarnApp
 
## Overview
A Dockerized setup for automating EarnApp deployment. It fetches the latest release, extracts binaries, manages authentication via environment variables, and runs the EarnApp app in the background. Includes essential system tools for network diagnostics, ensuring efficiency and error-resistant execution in a Debian-based container.

## Features  
- **Automated EarnApp Deployment**: Fetches and extracts the latest binary from EarnApp CDN.  
- **Authentication Handling**: Uses environment variables `EARNAPP_UUID`.
- **Run** `echo -n "sdk-node-" && head -c 1024 /dev/urandom | md5sum | tr -d ' -'` to get your EARNAPP_UUID.
- **Minimal Manual Intervention**: Designed for efficiency and error-resistant execution.  
- **Network Diagnostics**: Includes tools like `netstat` for monitoring activity.  

## Run
```bash

# Option 1 : amd64 build
docker run -d --platform linux/amd64 \
  -e EARNAPP_UUID="sdk-node-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
  --shm-size=2gb \
  ghcr.io/techroy23/docker-earnapp:latest


```

## Note
```
⚠ You must register it for earnings to be added to your account.
⚠ Open the following URL in the browser:
  https://earnapp.com/r/sdk-node-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```
