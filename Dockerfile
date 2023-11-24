
FROM --platform=linux/x86_64 thevlang/vlang:debian-dev

RUN apt-get update
RUN apt-get -y install sudo && \
    sudo apt-get -y install build-essential && \
    sudo apt-get -y install git

VOLUME /root/env
WORKDIR /root/env


