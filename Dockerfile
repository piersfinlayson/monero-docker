FROM ubuntu:23.10
RUN DEBIAN_FRONTEND=noninteractive apt -y update && \
    DEBIAN_FRONTEND=noninteractive apt -y install \
        git \
        build-essential \
        cmake \
        pkg-config \
        libboost-all-dev \
        libssl-dev \
        libzmq3-dev \
        libpgm-dev \
        libnorm-dev \
        libunbound-dev \
        libsodium-dev \
        libunwind8-dev \
        liblzma-dev \
        libreadline6-dev \
        libexpat1-dev \
        libgtest-dev \
        ccache \
        doxygen \
        graphviz \
        qttools5-dev-tools \
        libhidapi-dev \
        libusb-1.0-0-dev \
        libprotobuf-dev \
        protobuf-compiler \
        libudev-dev && \
    rm -fr /var/lib/apt/lists/*

RUN cd /usr/src/gtest && \
    cmake . && \
    make && \
    mv lib/libg* /usr/lib/

RUN mkdir /builds && \
    cd /builds && \
    git clone https://github.com/monero-project/monero && \
    cd /builds/monero
ARG MONERO_VER
RUN cd /builds/monero && \
    git checkout release-v$MONERO_VER && \
    git submodule update --init --force
ARG PARALLEL_MAKE=1
RUN cd /builds/monero && \
    make -j $PARALLEL_MAKE
#RUN cd /builds/monero && \
#    make -j $PARALLEL_MAKE release-test

VOLUME ['/monero']
ENV MONERO_PATH="/builds/monero/build/Linux/release-v$MONERO_VER/release/bin"
ENV MONERO_BINARY="monerod"
ENV PATH=$PATH:$MONERO_PATH
CMD $MONERO_PATH/$MONERO_BINARY --no-igd --log-level 0 --data-dir /monero --non-interactive --confirm-external-bind --rpc-bind-ip 0.0.0.0 --p2p-bind-ip 0.0.0.0 --p2p-use-ipv6 --start-mining $WALLET_ADDR --mining-threads 4

