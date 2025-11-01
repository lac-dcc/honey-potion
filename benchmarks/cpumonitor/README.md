# 🤙 CPU Usage Monitoring with eBPF

This eBPF benchmark monitors CPU scheduling and system call activity per process. It hooks into:
- `sched:sched_switch` to account per-slice runtime
- `raw_syscalls:sys_enter` and `raw_syscalls:sys_exit` to measure kernel-time inside syscalls

It maintains BPF maps to accumulate, per PID, total CPU time, kernel time (syscalls), and user time (total − kernel). The user-space program provides a curses-based, scrollable UI showing PID, process name, and smooth CPU percentages for user/kernel/total.

For deep dives into the eBPF internals and the UI/loader, see the files under `explain/`.

## Requirements
- Linux with eBPF and BTF available (check `/sys/kernel/btf/vmlinux`)
- libbpf, libelf, zlib, ncurses

Install on Ubuntu/Debian:
```bash
sudo apt update
sudo apt install -y clang llvm make pkg-config libbpf-dev libelf-dev zlib1g-dev libncurses-dev
```

## Build
From this directory:
```bash
make
```
This produces:
- `prog`          (user-space loader + UI)
- `prog.bpf.o`    (compiled eBPF object)
- `prog.bpf.ll`   (LLVM IR)
- `prog.skel.h`   (libbpf skeleton)

## Run
```bash
sudo ./prog
```
UI controls:
- Up/Down, PageUp/PageDown: scroll
- q: quit

Example output (abridged):
```
PID   NAME                 %USR   %SYS   %TOT     USER(ms)  KERN(ms)  TOTAL(ms)
1234  firefox              12.3    3.1   15.4        1200       300       1500
```

## Troubleshooting
- Permission/lockdown (Secure Boot): disable Secure Boot or use a kernel with lockdown disabled for eBPF.
- Missing BTF: install the matching kernel BTF package or update to a kernel with built-in BTF.
- Tracepoint attach failures: run with sudo and ensure `debugfs`/`tracefs` are mounted.

## Further reading (explain/)
- `explain/EBPF_IMPLEMENTATION.md`: eBPF architecture, maps, and timing logic
- `explain/USERSPACE_IMPLEMENTATION.md`: loader/UI details, smoothing, sorting and rendering
- `explain/SYSTEM_INTEGRATION.md`: How eBPF and user-space programs work together
