# 💀 FORCE KILL

This program listens to *force kill commands* for 30 seconds and prints them.
There are many [types of kill signals](https://linux.die.net/Bash-Beginners-Guide/sect_12_01.html) in Linux, but it listens for the *kill -9* signal which means: *"Forced termination; cannot be trapped"*

## 💻 Requirements

This program only requires the `libbpf`.

## 🚀 How to Build

You can run the following command line:
```bash
make
```
It will generate the following files:
- `prog` → The program responsible for attaching the eBPF program into the kernel and handling the information stored
- `prog.bpf.ll` → The LLVM IR   
- `prog.bpf.o` → The eBPF object that will be attached to the kernel

## ☕ How to Run

You can run:
```bash
sudo ./prog
```
There are no flags, it just runs for 30 seconds, for now. To test the program, try running the following command line while the eBPF program is running:
```bash
top &
```
The output will be something like: *`[1] <pid>`*.

This command creates a new process with the `top` program running asynchronously in a subshell and returning the pid (the second field of the output) of this process. You can kill this process running:
```bash
kill -9 <pid>
```
When the eBPF program finishes, it will print that the program `<pid>` was forcefully killed.


## ©️ Copyright

This file is part of the [ebpf-kill-example](https://github.com/niclashedam/ebpf-kill-example) distribution.

Copyright (c) 2021 Niclas Hedam.

[⬆ Back to top](#force-kill)<br>