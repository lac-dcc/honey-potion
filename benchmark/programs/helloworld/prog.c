#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <stdio.h>
#include <unistd.h>

static char PROGNAME[] = "helloWorld";

void output() {
    int maxPoints = 3;
    int points = 0;
    while(1) {
        fflush(0);

        printf("eBPF program loaded and executing");
        for (int i = 0; i < (maxPoints + 1); i++) printf((i < points)? ".": " ");

        points = (points + 1) % (maxPoints + 1);
        printf("\r");

        sleep(1);
    }
}

/**
 * @brief Load the eBPF program
 */
int main(int argc, char **argv) {
    int prog_fd;
    struct bpf_object *obj;
    struct bpf_prog_load_attr prog_load_attr = {
        .prog_type = BPF_PROG_TYPE_TRACEPOINT,
        .file = "prog.bpf.o"
    };

    if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd) == 0) {
        if (prog_fd < 1) {
            printf("Error creating prog_fd\n");
            return -2;
        }
        struct bpf_program *prog;

        prog = bpf_object__find_program_by_name(obj, PROGNAME);
        bpf_program__attach(prog);
        
        output();
    }
    else {
        printf("The kernel didn't load the BPF program\n");
        return -1;
    }

    return 0;
}