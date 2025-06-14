# FROM debian:latest
# FROM ubuntu:latest

FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
    curl wget tar htop net-tools \
    && apt-get autoclean -y && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set up working directory
WORKDIR /app

# Download EarnApp installation script
RUN wget --verbose --output-document=/app/setup.sh https://brightdata.com/static/earnapp/install.sh

# Extract version from installation script
RUN VERSION=$(grep VERSION= /app/setup.sh | cut -d'"' -f2) && \
    wget --verbose --output-document=/usr/bin/earnapp "https://cdn-earnapp.b-cdn.net/static/earnapp-x64-$VERSION" && \
    chmod -R a+rwx /usr/bin/earnapp

# Copy custom script and entrypoint script
COPY custom.sh /custom.sh
RUN bash /custom.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME [ "/etc/earnapp" ]

ENTRYPOINT ["/entrypoint.sh"]
