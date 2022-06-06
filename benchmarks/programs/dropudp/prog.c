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
    bpf_set_link_xdp_fd(IFINDEX, -1, XDPFLAGS);
    printf("Unloading the eBPF program...");
    exit(0);
}

/**
 * @brief Load the eBPF program    
 */
int main(int argc, char **argv) {
    int prog_fd;
    struct bpf_object *obj;
    struct bpf_prog_load_attr prog_load_attr = {
        .prog_type = BPF_PROG_TYPE_XDP,
        .file = "prog.bpf.o",
    };

    signal(SIGINT, _unloadProg);
    signal(SIGTERM, _unloadProg);

    if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd) < 0) {
        printf("Error loading the eBPF program\n");
        return -1;
    }
    
    struct bpf_program *prog;

    prog = bpf_object__find_program_by_name(obj, PROGNAME);
    prog_fd = bpf_program__fd(prog);
    IFINDEX = if_nametoindex("lo");
    if (bpf_set_link_xdp_fd(IFINDEX, prog_fd, XDPFLAGS) < 0) {
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