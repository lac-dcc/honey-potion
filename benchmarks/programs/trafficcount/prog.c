#include <linux/if_link.h>
#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <signal.h>
#include <net/if.h>
#include <unistd.h>
#include <stdlib.h>
#include "prog.h"

static __u32 XDPFLAGS = XDP_FLAGS_SKB_MODE;
static char MAPTRAFFIC[] = "map";
static char PROGNAME[] = "trafficCount";
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
 * @brief Iterate over all keys in the map and print them
 * @param obj Program eBPF
 */
void printMap(struct bpf_object *obj) {
    struct bpf_map *map_traffic = bpf_object__find_map_by_name(obj, MAPTRAFFIC);
    int map_traffic_fd = bpf_map__fd(map_traffic);

    if (map_traffic_fd < 0)
        printf("Error, file descriptor not found.\n");

    unsigned char key[6] = {0}, prev_key[6] = {0};
    struct countentry value;
    while (bpf_map_get_next_key(map_traffic_fd, prev_key, key) == 0) {
        int success = bpf_map_lookup_elem(map_traffic_fd, key, &value);
        if (success == 0) {
            printf("Source: %02x:%02x:%02x:%02x:%02x:%02x",
                key[0], key[1], key[2], key[3], key[4],key[5]
            );
            printf(" | Num. Packets: %d\n", value.packets);
        }
        memcpy(prev_key, key, 6);
    }
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
    IFINDEX = if_nametoindex("wlp3s0");
    if (bpf_xdp_attach(IFINDEX, prog_fd, XDPFLAGS, NULL) < 0) {
        printf("link set xdp fd failed\n");
        return -1;
    }

    while(1){
        sleep(3);
        printf("\e[1;1H\e[2J");
        printMap(obj);
        fflush(0);
    }

    return 0;
}
