# 🐝 EBPF BENCHMARK 🐝

There are many eBPF programs here ready to run! The programs are stored into the *programs* folder and each one has a front-end named `prog.c` that loads the eBPF program into the kernel and a back-end program which is the eBPF program named `prog.bpf.c`. The front-end and
back-end require the `libbpf` project which is stored into the *libs* folder.

You can read more about each program by visiting its folder and reading its README.