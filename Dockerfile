FROM debian:bullseye

LABEL maintainer="Kirk Parfitt"

ARG DEBIAN_FRONTEND=noninteractive
ARG BINUTILS_VERSION=2.31.1
ARG GCC_VERSION=10.2.0
ARG GRUB_VERSION=2.06

# Install additional dependencies for GRUB
RUN apt-get update && apt-get install -y \
    grub-common \
    grub2-common \
    bison \
    flex \
    libdevmapper-dev \
    liblzma-dev \
    help2man \
    python3-dev \
    autoconf \
    automake \
    autotools-dev\
    texinfo\
    wget \
    build-essential \
    libgmp-dev \
    libmpfr-dev \
    libmpc-dev \
    nasm  \
    xorriso \
    mtools && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

# Download and extract binutils
RUN wget https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz && \
    tar xf binutils-$BINUTILS_VERSION.tar.gz && \
    rm binutils-$BINUTILS_VERSION.tar.gz

# Download and extract gcc
RUN wget https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz && \
    tar xf gcc-$GCC_VERSION.tar.gz && \
    rm gcc-$GCC_VERSION.tar.gz

# Download and extract GRUB
RUN wget https://ftp.gnu.org/gnu/grub/grub-$GRUB_VERSION.tar.xz && \
    tar xf grub-$GRUB_VERSION.tar.xz && \
    rm grub-$GRUB_VERSION.tar.xz

# Build binutils
RUN mkdir binutils-build && cd binutils-build && \
    ../binutils-$BINUTILS_VERSION/configure --target=x86_64-elf --disable-nls --disable-werror && \
    make && make install && cd .. && rm -rf binutils-build

# Build gcc
RUN mkdir gcc-build && cd gcc-build && \
    ../gcc-$GCC_VERSION/configure --target=x86_64-elf --disable-nls --enable-languages=c,c++ --without-headers && \
    make all-gcc && make all-target-libgcc && make install-gcc && make install-target-libgcc && cd .. && rm -rf gcc-build

# Build GRUB
RUN cd grub-$GRUB_VERSION && \
    ./configure --with-platform=pc --target=x86_64-elf && \
    make && make install

RUN ln -s /usr/local/lib/grub/i386-pc /usr/lib/grub/i386-pc

WORKDIR /tmp

CMD ["/bin/bash"]
