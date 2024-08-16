# This is the Docker file of the Honey Potion artifact.
# To run the different research questions, do:
#
# docker run --rm docker-artifact bash rq1.sh
# docker run --rm docker-artifact bash rq2.sh
# docker run --rm docker-artifact bash rq4.sh
# docker run --rm docker-artifact bash rq5.sh

# Use an official Ubuntu as a base image
FROM ubuntu:20.04

# Set non-interactive mode for apt
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    git \
    build-essential \
    libelf-dev \
    zlib1g-dev \
    gcc-multilib \
    python3 \
    python3-pip \
    python3-matplotlib \
    clang \
    llvm \
    && rm -rf /var/lib/apt/lists/*

# Install Elixir
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && \
    dpkg -i erlang-solutions_2.0_all.deb && \
    apt-get update && \
    apt-get install -y elixir && \
    rm erlang-solutions_2.0_all.deb

# Install Hex, the package manager for Elixir
RUN mix local.hex --force

# Install libbpf
RUN cd /tmp && \
    git clone https://github.com/libbpf/libbpf && \
    cd libbpf/src/ && \
    mkdir build bpf && \
    BUILT_STATIC_ONLY=y OBJDIR=build DESTDIR=bpf make install && \
    cp -r ./build/libbpf.a /usr/local/lib && \
    cp -r ./bpf/usr/include/bpf /usr/local/include && \
    rm -rf /tmp/libbpf

# Install BPF tools
RUN apt-get update && apt-get install -y linux-tools-$(uname -r) || \
    (cd /tmp && \
    git clone --recurse-submodules https://github.com/libbpf/bpftool.git && \
    cd bpftool/src && \
    make install && \
    rm -rf /tmp/bpftool)

# Clone the Honey Potion repository
RUN git clone https://github.com/lac-dcc/honey-potion.git /honey-potion

# Set the working directory
WORKDIR /honey-potion/artifact

# Run the scripts to reproduce the experiments
CMD ["bash", "-c", "bash rq1.sh && bash rq2.sh && bash rq4.sh && bash rq5.sh"]
