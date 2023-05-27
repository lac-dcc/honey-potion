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
    int success;
    struct bpf_object *obj;
    obj = bpf_object__open("prog.bpf.o");
    success = bpf_object__load(obj);
    if (success == 0) {
    
        struct bpf_program *prog;

        prog = bpf_object__find_program_by_name(obj, PROGNAME);
        
        bpf_program__attach(prog);
        
        output();
    } else {
        printf("The kernel didn't load the BPF program\n");
        return -1;
    }

    return 0;
}
