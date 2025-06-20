FROM ubuntu:24.04

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt update -y && \
    apt install -y wget tar htop net-tools && \
	apt autoclean && \
	apt autoremove -y && \
	rm -rf /var/lib/apt/lists/* && \
	rm -rf /tmp/* && \
	rm -rf /var/tmp/*

RUN printf "#\\!/bin/bash\necho \"\"\n" > /usr/bin/lsb_release && \
    printf "#\\!/bin/bash\necho \"\"\n" > /usr/bin/hostnamectl && \
    chmod a+x /usr/bin/lsb_release /usr/bin/hostnamectl

RUN wget -cq "https://brightdata.com/static/earnapp/install.sh" --output-document=/app/setup.sh && \
    VERSION=$(grep VERSION= /app/setup.sh | cut -d'"' -f2) && \
    mkdir /download && \
    wget -cq "https://cdn-earnapp.b-cdn.net/static/earnapp-x64-$VERSION" --output-document=/download/earnapp && \ 
    echo | md5sum /download/earnapp && \
    chmod a+x /download/earnapp

COPY _start.sh /_start.sh
# RUN cp _start.sh /_start.sh
RUN chmod a+x /_start.sh

VOLUME [ "/etc/earnapp" ]

CMD ["/_start.sh"]