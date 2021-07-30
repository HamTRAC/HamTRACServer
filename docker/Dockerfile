FROM ubuntu
LABEL org.opencontainers.image.source https://github.com/HamTRAC/HamTRACServer

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /temp

COPY install.sh install.sh
RUN /bin/bash install.sh

WORKDIR /root
