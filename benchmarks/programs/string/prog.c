#include <linux/if_link.h>
#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <signal.h>
#include <net/if.h>
#include <unistd.h>
#include <stdlib.h>

static __u32 XDPFLAGS = XDP_FLAGS_SKB_MODE;
static char PROGNAME[] = "dropXDP";
static int IFINDEX;

/**
 * @brief Unload the eBPF program from the XDP and
 */
void _unloadProg() {
    bpf_xdp_attach(IFINDEX, -1, XDPFLAGS, NULL);
    printf("Unloading the eBPF program...");
    exit(0);
}

/**
 * @brief Load the eBPF program    
 */
int main(int argc, char **argv) {
    int prog_fd, success;
    struct bpf_object *obj;
    struct bpf_program *prog;    

    obj = bpf_object__open("prog.bpf.o");

    prog = bpf_object__next_program(obj, NULL);
    bpf_program__set_type(prog, BPF_PROG_TYPE_XDP);

    success = bpf_object__load(obj);

    // Load the program
    if (success != 0) {
        printf("The kernel didn't load the BPF program\n");
        return -1;
    }

    signal(SIGINT, _unloadProg);
    signal(SIGTERM, _unloadProg);
    

    prog_fd = bpf_program__fd(prog);
    IFINDEX = if_nametoindex("lo");
    if (bpf_xdp_attach(IFINDEX, prog_fd, XDPFLAGS, NULL) < 0) {
        printf("link set xdp fd failed\n");
        return -1;
    }

    printf("\nRunning");
    while(1){
        sleep(1);
        printf(".");
        fflush(0);
    }

    return 0;
}
