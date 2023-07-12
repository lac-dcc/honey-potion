#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <string.h> 
#include <stdlib.h>
#include <unistd.h>
#include "prog.h"

static char PROGNAME[] = "countSyscalls";
static char MAPTRAFFIC[] = "map";

/**
 * @brief Find the syscall name based on the id argument
 * @param id ID of the syscall
 * @return char* Name of the syscall
 */
char* findSyscallName(long int id) {
    for(int i = 0; i < NSYS; i++)
        if (SYSCALLSNAMES[i].id == id)
            return SYSCALLSNAMES[i].name;

    return NULL;
}

/**
 * @brief Iterate over all keys in the map and print them
 * @param obj Program eBPF
 */
void printMap(struct bpf_object *obj) {
    struct bpf_map *map_syscalls = bpf_object__find_map_by_name(obj, MAPTRAFFIC);
    int map_syscalls_fd = bpf_map__fd(map_syscalls);

    if (map_syscalls_fd < 0)
        printf("Error, file descriptor not found.\n");

    long int key = 0, prev_key = 0, value = 0;
    while (bpf_map_get_next_key(map_syscalls_fd, &prev_key, &key) == 0) {
        int success = bpf_map_lookup_elem(map_syscalls_fd, &key, &value);
        if (success == 0) {
            printf("Syscall: %ld (%s)", key, findSyscallName(key));
            printf(" | Qtd: %ld\n", value);
        }
        prev_key = key;
    }
}

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
    }
    else {
        printf("The kernel didn't load the BPF program\n");
        return -1;
    }

    while(1){
        printf("\e[1;1H\e[2J");
        printf("Syscalls invoked: \n");
        printMap(obj);
        sleep(3);
        fflush(0);
    }

    return 0;
}
