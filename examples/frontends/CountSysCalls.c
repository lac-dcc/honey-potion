#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <string.h> 
#include <stdlib.h>
#include <unistd.h>

#define NSYS 3
struct syscallNames { long id; char name[15]; };

/**
 * @brief If you want, you can list all the syscalls
 * using the following command line:
 * `ausyscall --dump`
 * You can add a new syscall in this struct if you want
 */
struct syscallNames SYSCALLSNAMES[NSYS] = {
    {62, "enter_kill"}, 
    {83, "enter_mkdir"},
    {318, "enter_getrandom"}
};

typedef struct Generic Generic;
typedef enum Type Type;
typedef struct Tuple Tuple;
typedef union ElixirValue ElixirValue;

typedef enum Type
{
  INVALID_TYPE,
  PATTERN_M,
  INTEGER,
  DOUBLE,
  STRING,
  ATOM,
  TUPLE,
  LIST,
  STRUCT,
  TYPE_Syscalls_enter_kill_arg
} Type;

typedef struct Tuple
{
  int start;
  int end;
} Tuple;

typedef struct String
{
  int start;
  int end;
} String;

typedef struct struct_Syscalls_enter_kill_args
{
  unsigned pos_pad;
  unsigned pos_syscall_nr;
  unsigned pos_pid;
  unsigned pos_sig;
} struct_Syscalls_enter_kill_args;

typedef union ElixirValue
{
  long integer;
  unsigned u_integer;
  double double_precision;
  Tuple tuple;
  String string;
  struct_Syscalls_enter_kill_args syscalls_enter_kill_args;
} ElixirValue;

typedef struct Generic
{
  Type type;
  ElixirValue value;
} Generic;


static char PROGNAME[] = "main_func";
static char MAPTRAFFIC[] = "map_traffic";

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

    int next_key = 0, key = 0;
    Generic value = (Generic){0};
    while (bpf_map_get_next_key(map_syscalls_fd, &key, &next_key) == 0) {
        int success = bpf_map_lookup_elem(map_syscalls_fd, &key, &value);
        if (success == 0 && findSyscallName(key)) {
            printf("Syscall: %d (%s)", key, findSyscallName(key));
            printf(" | Qtd: %ld\n", value.value.integer);
        }
        key = next_key;
        // printf("The key now is %d\n", key);
    }
    // printf("We got out of the loop.\n");
}

/**
 * @brief Load the eBPF program    
 */
int main(int argc, char **argv) {
    int prog_fd;
    struct bpf_object *obj;
    struct bpf_prog_load_attr prog_load_attr = {
        .prog_type = BPF_PROG_TYPE_TRACEPOINT,
        .file = "./../obj/CountSysCalls.bpf.o"
    };

    if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd) == 0) {
        if (prog_fd < 1) {
            printf("Error creating prog_fd\n");
            return -2;
        }
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
        // printf("\nLast inst of the while.\n");
        sleep(3);
        fflush(0);
    }

    return 0;
}
