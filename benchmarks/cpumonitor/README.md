# 🤙 CPU Usage Monitoring with eBPF

This eBPF program monitors CPU scheduling and system call activity. It tracks how long each process spends running on the CPU and how much time is spent inside system calls (kernel time). Using tracepoints, it hooks into context switches (sched_switch) and syscall entry/exit points. It stores timestamps in BPF hash maps to calculate and accumulate durations per PID. The goal is to measure per-process CPU and syscall time for performance analysis.

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
Tracking CPU usage... Ctrl+C to exit
CPU usage (PID, Total time, Kernel time, User time):

PID        Total (ms)      Kernel (ms)     User (ms)      
19289      62.52           44.29           18.23          
19287      1.44            0.68            0.76           
19291      2.40            1.64            0.75        
```

[⬆ Back to top](#cpumonitor)<br>
