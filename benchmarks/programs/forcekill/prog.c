#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <stdio.h>
#include <unistd.h>

static char PROGNAME[] = "sysEnterKill";
static char MAPNAME[] = "map";

/**
 * @brief Load the eBPF program
 */
int main(int argc, char **argv) {
    int success;
    struct bpf_object *obj;

    obj = bpf_object__open("prog.bpf.o");
    success = bpf_object__load(obj);

    if (success == 0) {
        struct bpf_program *prog;

        prog = bpf_object__find_program_by_name(obj, PROGNAME);
        bpf_program__attach(prog);

        printf("eBPF will listen to force kills for the next 30 seconds!\n");
        sleep(30);

        struct bpf_map *map = bpf_object__find_map_by_name(obj, MAPNAME);
        int map_fd = bpf_map__fd(map);
        long key = -1, prev_key;

        while (bpf_map_get_next_key(map_fd, &prev_key, &key) == 0) {
            printf("~> %ld was forcefully killed!\n", key);
            prev_key = key;
        }
    }
    else {
        printf("The kernel didn't load the BPF program\n");
        return -1;
    }

    return 0;
}
