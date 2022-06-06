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
    bpf_set_link_xdp_fd(IFINDEX, -1, XDPFLAGS);
    printf("Unloading the eBPF program...\n");
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
    IFINDEX = if_nametoindex("wlp3s0");
    if (bpf_set_link_xdp_fd(IFINDEX, prog_fd, XDPFLAGS) < 0) {
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