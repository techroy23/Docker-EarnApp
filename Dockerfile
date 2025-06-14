# FROM debian:latest
# FROM ubuntu:latest

FROM ubuntu:24.04

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y \
    curl wget tar htop net-tools \
    && apt-get autoclean -y && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

RUN echo -e "#\!/bin/bash \n echo \"$(lsb_release -a)\"" > /usr/bin/lsb_release
RUN echo -e "#\!/bin/bash \n echo \"$(hostnamectl)\"" > /usr/bin/hostnamectl
RUN chmod a+x /usr/bin/hostnamectl /usr/bin/lsb_release


RUN wget --verbose --output-document=/app/setup.sh https://brightdata.com/static/earnapp/install.sh

RUN VERSION=$(grep VERSION= /app/setup.sh | cut -d'"' -f2) && \
    wget --verbose --output-document=/usr/bin/earnapp "https://cdn-earnapp.b-cdn.net/static/earnapp-x64-$VERSION" && \
    chmod -R a+rwx /usr/bin/earnapp

# COPY custom.sh /custom.sh
# RUN bash /custom.sh

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

VOLUME [ "/etc/earnapp" ]

ENTRYPOINT ["/entrypoint.sh"]
