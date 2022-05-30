# 👋 HELLO WORLD

This program prints a *hello world message* for each new *syscall* made by a process.

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
To test the program, try running the following command line while the eBPF program is running:
```bash
sudo cat /sys/kernel/debug/tracing/trace_pipe
```

[⬆ Back to top](#hello-world)<br>