FROM debian:latest

RUN apt-get update -y && apt-get install -y \
    curl wget tar htop net-tools \
    && apt-get autoclean -y && apt-get autoremove -y && apt-get autopurge -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY custom.sh /custom.sh
RUN bash custom.sh

WORKDIR /app

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
