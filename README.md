# Docker-EarnApp

## Overview
A Dockerized setup for automating EarnApp Provider deployment. It fetches the latest release, extracts binaries, manages authentication via environment variables, and runs the provider app in the background. Includes essential system tools for network diagnostics, ensuring efficiency and error-resistant execution in a Debian-based container.


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

# Option 2 : arm64 build
docker run -d --platform linux/arm64 \
  -e EARNAPP_UUID="sdk-node-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
  --shm-size=2gb \
  ghcr.io/techroy23/docker-earnapp:latest

# Option 3 : linux/arm/v6 build
docker run -d --platform linux/arm/v6 \
  -e EARNAPP_UUID="sdk-node-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
  --shm-size=2gb \
  ghcr.io/techroy23/docker-earnapp:latest

  # Option 4 : linux/arm/v7 build
docker run -d --platform linux/arm/v7 \
  -e EARNAPP_UUID="sdk-node-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" \
  --shm-size=2gb \
  ghcr.io/techroy23/docker-earnapp:latest

```