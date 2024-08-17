# Reproducing Research Question 3

Research Question Three (RA3) compares the performance of hand-written C programs and programs produced via Honey Potion.
This is the only research question that we could not automatize in a reproducible artifact.
It is possible to run the eBPF programs using Docker, but we could not find a way to profile them within the same Docker process.

Thus, if you have compiled the programs outside Docker (e.g., to compile them run [rq2.sh](../rq2.sh)), then measuring the performance of the BPF programs involves three steps:

1. Activating the program, e.g.: `sudo honey-potion/examples/lib/bin/HelloWorld`
2. Discovering the program's ID, e.g.: `sudo bpftool prog list`
3. Profiling the program, e.g.: `sudo bpftool prog profile id 63 duration 5 cycles instructions` (assuming the ID is 63)

Figure 1 explains how to perform these steps.

![How to profile eBPF programs](../../assets/howToProfile.png "How to profile eBPF programs")

Three of the programs can be profiled using the three first steps of Figure 1: [HelloWorld](../../examples/lib/HelloWorld.ex), [CountSysCalls](../../examples/lib/CountSysCalls.ex) and [ForceKill](../../examples/lib/Forcekill.ex).
In this case, use `duration 10` when invoking `bpftool prog profile`.

The other two programs, [DropUDP](../../examples/lib/DropUdp.ex) and [TrafficCount](../../examples/lib/TrafficCount.ex) will require some interaction.

* [DropUdp](../../examples/lib/DropUdp.ex): send a packet to port 3000 using `netcat`, as follows: `echo "Your message" | nc -u -w1 127.0.0.1 3000`
* [TrafficCount](../../examples/lib/TrafficCount.ex): use the `ping` command to send an ICMP packet to a known IP address on your network. This packet will be processed by the network interface and should trigger the eBPF program.
For instance, `ping -c 1 <destination_ip>`