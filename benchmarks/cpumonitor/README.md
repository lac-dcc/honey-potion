# 🤙 CPU Usage Monitoring with eBPF

This program utilizes eBPF (extended Berkeley Packet Filter) to monitor the CPU usage and syscall counts in both user and kernel modes, using a custom BPF program. It attaches to performance events and samples CPU activity across all CPU cores. The program tracks and outputs the number of events observed, allowing for a deeper understanding of system activity.

## 💻 Requirements

`libbpf`.

`A Linux-based system with eBPF support`

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
Amostrando uso de CPU... Pressione Ctrl+C para sair
PID    Modo    Amostras
1234   user    145
5678   kernel  321
```

[⬆ Back to top](#count-syscalls)<br>
