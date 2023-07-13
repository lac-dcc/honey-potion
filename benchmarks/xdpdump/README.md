# 📜 XDP DUMP

This program demonstrates how a eBPF program may communicate with userspace
using the kernel's perf tracing events.

The demo's userspace program creates a perf ring buffer for each of the host's
CPUs. This ring buffer is assigned a File Descriptor, this is subsequently
written to the eBPF map, denoted by the CPU index.

When an ingress packet enters the XDP program, packet metadata is extracted and
stored into a data structure. The XDP program sends this metadata, along with
the packet contents to the ring buffer denoted in the eBPF perf event map using
the current CPU index as the key.

The userspace program polls the perf rings for events from the XDP program.
When an event is received, it prints the event's metadata to the terminal.
The user can also specify if the packet contents should be dumped in hexadecimal
format.

This demo program can currently only analyze IPv4 and IPv6 packets containing
TCP/UDP data, but could easily be expanded to cover a wider range of protocols.

## 💻 Requirements

This program requires the `libbpf` and:
- Linux kernel 4.18
- clang / LLVM 4.0
- If using NIC offloading: Agilio® eBPF firmware for HW offload (available from [Netronome's support website](https://help.netronome.com/))

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

To check your availble network interfaces, you can run:
```bash
ifconfig
```

Then, to start xdpdump, use:
```bash
sudo ./prog -i <NETWORK_INTERFACE>
```

>28228.714182 IP 10.0.0.2:9203 > 10.0.0.1:0 TCP seq 437136853, length 6 <br>
28233.714510 IP6 fe80::268a:7ff:fe3b:46:9 > 2001:db8:85a3::370:7334:9 UDP, length 16 <br>
28234.040118 IP 10.0.0.2:1709 > 10.0.0.1:0 TCP seq 1723695364, length 30

Payload information can also be displayed with the payload option:
```bash
sudo ./prog -i <NETWORK_INTERFACE> -x
```
>28298.719497 IP 10.0.0.2:1697 > 10.0.0.1:0 TCP seq 1017625101, length 6 <br>
       0015 4d13 0880 248a 073b 0046 0800 4500 <br>
       0028 18fa 0000 4006 4dd4 0a00 0002 0a00 <br>
       0001 06a1 0000 3ca7 ba0d 558d d5a8 5000 <br>
       0200 7156 0000 0000 0000 0000

The program may be offloaded to a SmartNIC using the HW offload option:
```bash
./xdpdump -i <NETWORK_INTERFACE> -x -H
```
>28357.729517 IP 10.0.0.2:54013 > 10.0.0.1:53 UDP, length 51 <br>
       0015 4d13 0880 248a 073b 0046 0800 4500 <br>
       004f cf83 0000 4011 9718 0a00 0002 0a00 <br>
       0001 d2fd 0035 003b bd51 cd62 0120 0001 <br>
       0000 0000 0001 0667 6f6f 676c 6503 636f <br>
       6d00 0001 0001 0000 2910 0000 0000 0000 <br>
       0c00 0a00 08ce 1722 411e 4e95 8b

To check all options in xdpdump, you can run.
```bash
sudo ./xdpdump -h
```

## ©️ Copyright

SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
Copyright (c) 2018 Netronome Systems, Inc.

[⬆ Back to top](#XDP-DUMP)<br>