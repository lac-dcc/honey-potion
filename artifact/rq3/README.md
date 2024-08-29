# Reproducing Research Question 3

Research Question Three (RQ3) compares the performance of [hand-written C programs](../../benchmarks) and [Elixir programs](../../examples/lib/) compiled via Honey Potion.
This is the only research question that we could not automatize with a single script.

## Running eBPF programs within Docker

To run the eBPF programs within Docker, you should invoke Docker with sudo privileges, as follows:

```
docker run --rm -ti \
    -e BPF_IMAGE=docker-artifact \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ghcr.io/hemslo/docker-bpf:latest \
    bash
```

You can run the programs using the same commands you would use outside Docker.
For instance, to count system calls, you can use the commands below.
This program, in particular, is the subject of one of our [videos](https://youtu.be/Q5GO-FFapVw?feature=shared):

```
# Compile everything, e.g., using rq2.sh:
#
root@docker:/honey-potion/artifact# bash rq2.sh 
#
# Run any of the programs:
#
root@docker:/honey-potion/artifact# sudo ../examples/lib/bin/CountSysCalls 
```

## Profiling eBPF programs within Docker

Measuring the performance of the BPF programs involves opening two shell sessions within the same instance of docker:

1. To open the two sessions, let us use [tmux](https://www.redhat.com/sysadmin/introduction-tmux-linux):

```
root@docker:/honey-potion/artifact# tmux
```

To split the window into two sessions with vertical panes, you can press `ctrl+b` and then press `%` within your `tmux` session.
So, go ahead and create two panes.
You can move between panes by pressing `ctrl+b` and then pressing either the left or the right arrow key.

2. (Within window 1) Run the eBPF program. We are assuming that you've already compiled it, e.g., using `bash rq2.sh`, for instance. To run the program, as already mentioned, you can do:

```
root@docker:/honey-potion/artifact# sudo ../examples/lib/bin/HelloWorld
```

3. (Within shell session 2) We first need to discover the program's ID. You can find this ID with the command below:

```
root@docker:/honey-potion/artifact# sudo bpftool prog list
```

See Figure 1 to locate the ID. Most likely, the eBPF process that you want will be the last one in the list.

4. (Within shell session 2) Profile the program using the `bpftool` application. If we assume that the process that you want has ID 63, then you can do it as follows:

```
root@docker:/honey-potion/artifact# sudo bpftool prog profile id 63 duration 5 cycles instructions
```

This command will print the number of eBPF instructions and cycles executed by the program. See Figure 1 for an explanation of these reports.

![How to profile eBPF programs](../../assets/howToProfile.png "How to profile eBPF programs")

Three of the programs can be profiled using the three first steps of Figure 1: [HelloWorld](../../examples/lib/HelloWorld.ex), [CountSysCalls](../../examples/lib/CountSysCalls.ex) and [ForceKill](../../examples/lib/Forcekill.ex).
In this case, use `duration 10` when invoking `bpftool prog profile`.

The other two programs, [DropUDP](../../examples/lib/DropUdp.ex) and [TrafficCount](../../examples/lib/TrafficCount.ex) will require some interaction.

* [DropUdp](../../examples/lib/DropUdp.ex): send a packet to port 3000 using `netcat`, as follows: `echo "Your message" | nc -u -w1 127.0.0.1 3000`
* [TrafficCount](../../examples/lib/TrafficCount.ex): use the `ping` command to send an ICMP packet to a known IP address on your network. This packet will be processed by the network interface and should trigger the eBPF program.
For instance, `ping -c 1 <destination_ip>`