
FROM --platform=linux/x86_64 thevlang/vlang:debian-dev

# Pin gcc to a single version so the examples/ scripts (sqlite, lua, selfhost)
# always assemble the exact same .s output. Different gcc versions emit
# different directives/encodings, and vas has known gaps (branch relaxation,
# x87 at -O0, COMDAT groups, ...) that some versions trip and others don't.
# gcc-12 is what the examples are validated against; bump this deliberately.
RUN apt-get update && \
    apt-get -y install sudo build-essential git gcc-12 g++-12 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 100 && \
    rm -rf /var/lib/apt/lists/*

VOLUME /root/env
WORKDIR /root/env


