# đ RING BUF

this program output data about programs running to `perf` event and print them on the terminal.

## đģ Requirements

This program only requires the `libbpf`.

## đ How to Build

You can run the following command line:
```bash
make
```
It will generate the following files:
- `prog` â The program responsible for attaching the eBPF program into the kernel and handling the information stored
- `prog.bpf.ll` â The LLVM IR   
- `prog.bpf.o` â The eBPF object that will be attached to the kernel
- `prog.skel.h` â eBPF skeleton used by prog.c (user space)

## â How to Run

You can run:
```bash
sudo ./prog
```
The output will be something like:
```bash
TIME     EVENT PID     COMM             FILENAME
xx:xx:xx EXEC          <process>        <path/to/>
```


## ÂŠī¸ Copyright

This program was adapted from [Anakryiko](https://github.com/anakryiko/bpf-ringbuf-examples).

[âŦ Back to top](#RING-BUF)<br>