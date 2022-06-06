# 🧮 TRAFFIC COUNT

This program counts the number of received packets by MAC ADDRESS and prints them on the terminal.

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
The output will be something like:
```bash
Source: <MAC ADDRESS> | Num. Packets: <int>
```


## ©️ Copyright

This program was adapted from [BPFFabric/Examples](https://github.com/UofG-netlab/BPFabric/blob/master/examples/trafficcount.c).

[⬆ Back to top](#TRAFFIC-COUNT)<br>