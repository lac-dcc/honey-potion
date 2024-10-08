# Reproducing Honey Potion Results

Honey Potion is described in a [paper](../docs/HoneyPotion2024.pdf). The fourth section of that paper discusses five research questions. This folder contains scripts to reproduce the results related to those questions.
The preferred way to reproduce the experiments is through our [Docker](docker) setup.
However, if you want to run and profile the eBPF programs, then you will have to do it outside Docker.
This guide will help you set up your Linux Ubuntu system to reproduce those results.
This setup has been successfully reproduced in the following Linux distribution:
 
* **Operating System**: Ubuntu 22.04.4 LTS              
* **Kernel**: Linux 6.8.0-40-generic
* **Architecture**: x86-64
* **Hardware Vendor**: Acer
* **Hardware Model**: Aspire A515-54
* **Elixir**: Elixir 1.12.2 (compiled with Erlang/OTP 24)
* **clang**: clang 16.0.0

Notice that Honey Potion requires a new version of clang.
It will not run with clang 10.0, for instance.
The artifact consists of four scripts, each to reproduce a different research question. The expected outputs are:
[RQ1](expected_outputs/output_rq1.txt),
[RQ2](expected_outputs/output_rq2.txt),
[RQ4](expected_outputs/output_rq4.txt), and
[RQ5](expected_outputs/output_rq5.txt).

## Prerequisites

Ensure that your system is up to date and has `wget` and the `LLVM` tools installed:

```bash
sudo apt-get update
sudo apt-get install wget
```

## Step 1: Install clang and the LLVM tools

You might already have clang in your system (minimum clang 16).
But you will also need to use `llc`, from the LLVM tools, to produce eBPF code.

```
sudo apt-get install wget gnupg lsb-release software-properties-common
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 16
sudo apt-get update
sudo apt-get install clang-16
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-16 100
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-16 100
sudo apt-get install llvm-16
sudo update-alternatives --install /usr/bin/llc llc /usr/bin/llc-16 100
sudo update-alternatives --install /usr/bin/opt opt /usr/bin/opt-16 100
sudo update-alternatives --install /usr/bin/llvm-ar llvm-ar /usr/bin/llvm-ar-16 100
sudo update-alternatives --install /usr/bin/llvm-as llvm-as /usr/bin/llvm-as-16 100
```

## Step 2: Install Elixir

Honey Potion requires Elixir 1.9.x or superior.
If your Linux version already has an earlier distribution, you might consider removing it and updating it from the Erlang Solutions repository.
To uninstall your distribution of Elixir, simply do `sudo apt-get remove --purge elixir`. Then, to install Elixir from the Erlang Solutions repo, follow these steps:

```
sudo apt-get update
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir
```

Notice that installing `esl-erlang` is optional, given that you've installed `elixir` (which will come with `erlang`).
To fully benefit from Honey Potion, you should use the extra packages of `esl-erlang`, but that's not required for this experiment.
Also, `esl-erlang` [might not be available](https://elixirforum.com/t/install-fails-for-ubuntu-21-04/39596) for your kernel.

## Step 3: Install `libbpf`

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
cd -
```

## Step 4: Update Hex

This step is optional.
Hex is the package manager for Elixir. Update it using:

```
mix local.hex
```

## Step 5: Install `gcc-multilib` (Optional for GCC Users)

If you are compiling with `gcc`, you'll need to install the multilib package:

```
sudo apt install gcc-multilib
```

## Step 6: Install BPF Tools

To install the BPF tools, you need to identify the correct package to use. If you simply type `bpftool version` when BPF Tools are not installed on your system, you will get the right package to install in the error message. But you can simply try your luck with:

```
sudo apt-get install linux-tools-$(uname -r)
```

Notice that Linux Tools may not work if you are using [WSL](https://askubuntu.com/questions/1314136/installing-linux-perf-tools-on-ubuntu-20-04-lts-with-wsl2).
But you can still compile them from source, e.g.:

```
git clone --recurse-submodules https://github.com/libbpf/bpftool.git
cd bpftool/src
sudo make install
```

## Step 7: Clone and Use Honey Potion

Finally, clone the Honey Potion repository and navigate to the source directory:


```
git clone https://github.com/lac-dcc/honey-potion.git
cd honey-potion/artifact
```

## Step 8: Reproduce the experiments

For instance, if you want to reproduce the results in the first research question, simply do:

```
bash rq1.sh 
```

Each script contain some text explaining which research question it deals with.