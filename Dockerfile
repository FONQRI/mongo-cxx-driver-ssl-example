FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    ca-certificates \
    libtool \
    g++ \
    gcc \
    git \
    make

RUN apt-get install -y --no-install-recommends \
    libssl-dev

RUN git clone -b r1.3 https://github.com/mongodb/mongo-c-driver
RUN cd mongo-c-driver && \
    ./autogen.sh --enable-ssl=yes && \
    make -j8 && \
    make install
