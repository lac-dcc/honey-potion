#include <linux/if_link.h>
#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <net/if.h>
#include <unistd.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include "prog.h"

static __u32 XDPFLAGS = XDP_FLAGS_SKB_MODE;
static char PROGNAME[] = "matchPayload";
static char MAPSTRINGS[] = "strings";
static char MAPPORT[] = "config";
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
 * @brief Fill the map with the port that will be explored
 * @param obj Program eBPF
 */
int fillMapPort(struct bpf_object *obj, int port) {
    struct bpf_map *map = bpf_object__find_map_by_name(obj, MAPPORT);
    int map_fd = bpf_map__fd(map);

    char key = 'p';
    int value = port;    
    if (bpf_map_update_elem(map_fd, &key, &value, BPF_NOEXIST) < 0) {
        printf("Error to update port map.");
        return -1;
    }

    return 0;
}

/**
 * @brief Fill the map with the strings that will be explored
 * @param obj Program eBPF
 */
int fillMapStrings(struct bpf_object *obj, char filename[]) {
    struct bpf_map *map = bpf_object__find_map_by_name(obj, MAPSTRINGS);
    int map_fd = bpf_map__fd(map);

    FILE *file;
    char fileRow[10];
    char *line = NULL;
    size_t len = 0;

    if((file = fopen(filename, "r")) == NULL) {
        printf("Error open the file %s", filename);
        return -1;
    }

    int key = 0;
    while (getline(&line, &len, file) != -1 && key < MAPSTRINGSSIZE) {
        struct data value;
        value.number = 5;
        strcpy(value.text, line);
        if (bpf_map_update_elem(map_fd, &key, &value, BPF_ANY) < 0) {
            printf("Error to update strings map.");
            return -1;
        }
        key++;
    }

    fclose(file);
    if (line)
        free(line);

    return 0;
}

/**
 * @brief Load the eBPF program
 */
int main(int argc, char **argv) {
    int prog_fd;
    struct bpf_object *obj;
    struct bpf_prog_load_attr prog_load_attr = {
        .prog_type = BPF_PROG_TYPE_XDP,
        .file = "prog.bpf.o"
    };

    signal(SIGINT, _unloadProg);
    signal(SIGTERM, _unloadProg);

    // Load the program
    if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd) < 0) {
        printf("The kernel didn't load the BPF program\n");
        return -1;
    }

    // Check the file descriptor
    if (prog_fd < 1) {
        printf("Error creating prog_fd\n");
        return -2;
    }
    struct bpf_program *prog;

    // Fill the map
    prog = bpf_object__find_program_by_name(obj, PROGNAME);
    prog_fd = bpf_program__fd(prog);
    if (fillMapPort(obj, 3000) < 0)
        return -1;
    if (fillMapStrings(obj, "strings.txt") < 0)
        return -1;
    
    // Attach program to network interface
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