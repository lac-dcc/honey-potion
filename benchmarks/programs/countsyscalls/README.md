# 🤙 COUNT SYSCALLS

This program counts the number of syscalls (*sys_enter*) made to the Linux Operational System.

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
The program's output will be something like:
```bash
Syscalls invoked: 
Syscall: 62 (enter_kill) | Qtd: 55
Syscall: 318 (enter_getrandom) | Qtd: 10
Syscall: 83 (enter_mkdir) | Qtd: 5
```

[⬆ Back to top](#count-syscalls)<br>