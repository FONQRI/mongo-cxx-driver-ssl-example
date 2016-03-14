FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install -y --no-install-recommends \
    autoconf \
    automake \
    ca-certificates \
    libtool \
    g++ \
    gcc \
    gdb \
    git \
    make \
    pkg-config

RUN apt-get install -y --no-install-recommends \
    libssl-dev

RUN echo 'deb http://httpredir.debian.org/debian stretch main' > /etc/apt/sources.list.d/stretch.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends cmake

RUN git clone -b r1.3 https://github.com/mongodb/mongo-c-driver
RUN cd mongo-c-driver && \
    ./autogen.sh --enable-ssl=yes && \
    make -j8 && \
    make install

RUN echo ----
#RUN git clone -b master https://github.com/mongodb/mongo-cxx-driver
RUN git clone -b messa_ssl_cstr_fix https://github.com/messa/mongo-cxx-driver
RUN cd mongo-cxx-driver/build && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local \
        -DCMAKE_CXX_FLAGS=-DMONGOC_HAVE_SSL=1 \
        .. && \
    make -j8 MONGOC_HAVE_SSL=true && \
    make install

COPY hellomongo.cpp /
RUN c++ --std=c++11 hellomongo.cpp -o hellomongo $(pkg-config --cflags --libs libmongocxx)

RUN echo ---
RUN ldconfig
RUN ldd ./hellomongo
RUN ./hellomongo
