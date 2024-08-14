# Honey Potion Compiler Setup Guide

This guide will help you set up your Linux Ubuntu system to run Honey Potion, a compiler that translates Elixir programs into eBPF executables. The guide assumes that `clang` or `gcc` is already installed on your system.

## Prerequisites

Ensure that your system is up to date and has `wget` installed:

```bash
sudo apt-get update
sudo apt-get install wget
```

## Step 1: Install Elixir

To install Elixir, follow these steps:

```
sudo apt-get update
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir
```

## Step 2: Install `libbpf`

`libbpf` is required for eBPF development. Install it by following these commands:

```
sudo apt install libelf-dev zlib1g-dev
cd /tmp
git clone https://github.com/libbpf/libbpf
cd libbpf/src/
mkdir build bpf
BUILT_STATIC_ONLY=y OBJDIR=build DESTDIR=bpf make install
sudo cp -r ./build/libbpf.a /usr/local/lib
sudo cp -r ./bpf/usr/include/bpf /usr/local/include
```

## Step 3: Update Hex

Hex is the package manager for Elixir. Update it using:

```
mix local.hex
```

## Step 4: Install `gcc-multilib` (Optional for GCC Users)

If you are compiling with `gcc`, you'll need to install the multilib package:

```
sudo apt install gcc-multilib
```

## Step 5: Install BPF Tools

To install the BPF tools, you need to identify the correct package to use. If you simply type `bpftool version`, and it is not installed on your system, you will get the right package to install in the error message. But you can simply try your luck with:

```
sudo apt-get install linux-tools-$(uname -r)
```

## Step 6: Clone and Use Honey Potion

Finally, clone the Honey Potion repository and navigate to the source directory:


```
git clone https://github.com/lac-dcc/honey-potion.git
cd honey-potion/artifact
```

## Step 7: Reproduce the experiments

For instance, if you want to reproduce the results in the first research question, simply do:

```
bash rq1.sh 
```

Each script contain some text explaining which research question it deals with.