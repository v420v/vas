# syntax=docker/dockerfile:1
FROM --platform=linux/x86_64 debian:bookworm

# Pin gcc to a single version so the examples/ scripts (sqlite, lua, selfhost)
# always assemble the exact same .s output. Different gcc versions emit
# different directives/encodings, and vas has known gaps (branch relaxation,
# x87 at -O0, COMDAT groups, ...) that some versions trip and others don't.
# gcc-12 is what the examples are validated against; bump this deliberately.
RUN apt-get update && \
    apt-get -y install sudo build-essential git ca-certificates curl file gcc-12 g++-12 && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 100 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-12 100 && \
    rm -rf /var/lib/apt/lists/*

# V at the newest commit of V_REF, built from source. `ADD <git url>` resolves
# the ref on every `docker build`, so the layer cache is reused only while V
# master has not moved: a plain rebuild is enough to pick up a newer V. To pin
# (e.g. around a V master regression): --build-arg V_REF=<tag or commit sha>.
ARG V_REF=master
ADD --keep-git-dir=true https://github.com/vlang/v.git#${V_REF} /opt/v
RUN make -C /opt/v && ln -s /opt/v/v /usr/local/bin/v && v version

VOLUME /root/env
WORKDIR /root/env
