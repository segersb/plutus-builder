FROM haskell:8.10.4

RUN apt update -y && apt install -y \
    libsodium-dev \
    automake \
    build-essential \
    pkg-config \
    libffi-dev \
    libgmp-dev \
    libssl-dev \
    libtinfo-dev \
    libsystemd-dev \
    zlib1g-dev \
    make \
    g++ \
    tmux \
    git \
    jq \
    wget \
    libncursesw5 \
    libtool \
    autoconf

RUN git clone https://github.com/input-output-hk/libsodium
WORKDIR /libsodium
RUN git checkout 66f017f1 && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install
WORKDIR /

RUN mkdir /build
WORKDIR /build

COPY cabal.project /build
COPY placeholder.cabal /build
COPY Placeholder.hs /build
RUN cabal update && \
    cabal build && \
    cabal build cardano-api && \
    cabal build plutus-core && \
    cabal build plutus-tx && \
    cabal build plutus-ledger && \
    cabal build plutus-ledger-api && \
    cabal build plutus-tx-plugin
RUN rm cabal.project
RUN rm placeholder.cabal
RUN rm Placeholder.hs