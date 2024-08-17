# Reproducing Research Question 3

Research question three compares the performance of hand-written C programs and programs produced via Honey Potion.
This is the only research question that we could not automatize in a reproducible artifact.
If you have already compiled the programs (e.g., just run [rq2.sh](../rq2.sh) to do it), then measuring the performance of the BPF programs involves three steps:

1. Activating the program, e.g.: `sudo honey-potion/examples/lib/bin/HelloWorld`
2. Discovering the program's ID, e.g.: `sudo bpftool prog list`
3. Profiling the program, e.g.: `sudo bpftool prog stats 63 --metric instructions` (assuming the ID is 63)

Figure 1 explains how to perform these steps.

![How to profile eBPF programs](../../assets/howToProfile.png "How to profile eBPF programs")