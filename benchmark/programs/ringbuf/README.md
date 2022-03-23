# 💍 RING BUF

this program output data about programs running to `perf` event and print them on the terminal.

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
- `prog.skel.h` → eBPF skeleton used by prog.c (user space)

## ☕ How to Run

You can run:
```bash
sudo ./prog
```
The output will be something like:
```bash
TIME     EVENT PID     COMM             FILENAME
xx:xx:xx EXEC          <process>        <path/to/>
```


## ©️ Copyright

This program was adapted from [Anakryiko](https://github.com/anakryiko/bpf-ringbuf-examples).

[⬆ Back to top](#RING-BUF)<br>