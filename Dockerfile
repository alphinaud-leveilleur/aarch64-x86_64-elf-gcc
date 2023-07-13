FROM debian:bullseye-slim

LABEL maintainer="Kirk Parfitt"

ARG DEBIAN_FRONTEND=noninteractive
ARG BINUTILS_VERSION=2.36.1
ARG GCC_VERSION=10.2.0

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    build-essential \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Download and extract binutils and gcc
RUN wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz && \
    tar xf binutils-$BINUTILS_VERSION.tar.gz && \
    wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz && \
    tar xf gcc-$GCC_VERSION.tar.gz && \
    rm -rf binutils-$BINUTILS_VERSION.tar.gz gcc-$GCC_VERSION.tar.gz

# Build binutils
RUN mkdir binutils-build && cd binutils-build && \
    ../binutils-$BINUTILS_VERSION/configure --target=x86_64-elf --disable-nls --disable-werror && \
    make && make install && cd .. && rm -rf binutils-build

# Build gcc
RUN mkdir gcc-build && cd gcc-build && \
    ../gcc-$GCC_VERSION/configure --target=x86_64-elf --disable-nls --enable-languages=c,c++ --without-headers && \
    make all-gcc && make all-target-libgcc && make install-gcc && make install-target-libgcc && cd .. && rm -rf gcc-build

WORKDIR /

CMD ["/bin/bash"]
