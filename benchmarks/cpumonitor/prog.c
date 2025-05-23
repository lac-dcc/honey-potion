#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <errno.h>
#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <string.h> 
#include "prog.skel.h"


static volatile sig_atomic_t exiting = 0;

void handle_sigint(int sig) {
    exiting = 1;
}

struct pid_entry {
    __u32 pid;
    double total;
    double kernel;
    double user;
    struct pid_entry *next;
};

struct pid_entry* read_pid_file(const char *filename) {
    FILE *fp = fopen(filename, "r");
    if (!fp) {
        if (errno == ENOENT)
            return NULL;
        perror("Failed to open pid file for reading");
        return NULL;
    }

    struct pid_entry *head = NULL;
    char line[256];
    while (fgets(line, sizeof(line), fp)) {
        struct pid_entry *node = malloc(sizeof(struct pid_entry));
        if (!node) {
            perror("malloc failed");
            fclose(fp);
            while (head) {
                struct pid_entry *tmp = head;
                head = head->next;
                free(tmp);
            }
            return NULL;
        }

        int scanned = sscanf(line, "%u %lf %lf %lf",
                             &node->pid, &node->total, &node->kernel, &node->user);
        if (scanned != 4) {
            free(node);
            continue;
        }
        node->next = head;
        head = node;
    }

    fclose(fp);
    return head;
}

void write_pid_file(const char *filename, struct pid_entry *list) {
    FILE *fp = fopen(filename, "w");
    if (!fp) {
        perror("Failed to open pid file for writing");
        return;
    }

    struct pid_entry *cur = list;
    while (cur) {
        fprintf(fp, "%-10u %-15.2f %-15.2f %-15.2f\n",
                cur->pid, cur->total, cur->kernel, cur->user);
        cur = cur->next;
    }

    fclose(fp);
}

void free_pid_list(struct pid_entry *list) {
    while (list) {
        struct pid_entry *tmp = list;
        list = list->next;
        free(tmp);
    }
}


void update_pid_list(struct pid_entry **list, __u32 pid, double total, double kernel, double user) {
    struct pid_entry *cur = *list;
    while (cur) {
        if (cur->pid == pid) {
            cur->total = total;
            cur->kernel = kernel;
            cur->user = user;
            return;
        }
        cur = cur->next;
    }
    struct pid_entry *new_node = malloc(sizeof(struct pid_entry));
    new_node->pid = pid;
    new_node->total = total;
    new_node->kernel = kernel;
    new_node->user = user;
    new_node->next = *list;
    *list = new_node;
}

int get_map_fd_by_name(struct bpf_object *obj, const char *name) {
    struct bpf_map *map = bpf_object__find_map_by_name(obj, name);
    if (!map) {
        fprintf(stderr, "Failed to find map: %s\n", name);
        return -1;
    }
    return bpf_map__fd(map);
}

int main() {
    struct bpf_object *obj;
    int err;

    obj = bpf_object__open_file("prog.bpf.o", NULL);
    if (!obj) {
        fprintf(stderr, "Failed to open BPF object\n");
        return 1;
    }

    err = bpf_object__load(obj);
    if (err) {
        fprintf(stderr, "Failed to load BPF object: %d\n", err);
        return 1;
    }
    struct bpf_program *prog_switch = bpf_object__find_program_by_name(obj, "on_sched_switch");
    if (!prog_switch) {
        fprintf(stderr, "Failed to find program on_sched_switch\n");
        return 1;
    }
    struct bpf_link *link_switch = bpf_program__attach_tracepoint(prog_switch, "sched", "sched_switch");
    if (!link_switch) {
        fprintf(stderr, "Failed to attach to sched_switch\n");
        return 1;
    }
    struct bpf_program *prog_enter = bpf_object__find_program_by_name(obj, "on_sys_enter");
    if (!prog_enter) {
        fprintf(stderr, "Failed to find program on_sys_enter\n");
        return 1;
    }
    struct bpf_link *link_enter = bpf_program__attach_tracepoint(prog_enter, "raw_syscalls", "sys_enter");
    if (!link_enter) {
        fprintf(stderr, "Failed to attach to sys_enter\n");
        return 1;
    }

    struct bpf_program *prog_exit = bpf_object__find_program_by_name(obj, "on_sys_exit");
    if (!prog_exit) {
        fprintf(stderr, "Failed to find program on_sys_exit\n");
        return 1;
    }
    struct bpf_link *link_exit = bpf_program__attach_tracepoint(prog_exit, "raw_syscalls", "sys_exit");
    if (!link_exit) {
        fprintf(stderr, "Failed to attach to sys_exit\n");
        return 1;
    }

    

    printf("Tracking CPU usage... Ctrl+C to exit\n");
    printf("CPU usage (PID, Total time, Kernel time, User time):\n");
    int kernel_fd = get_map_fd_by_name(obj, "kernel_time");
    int user_fd = get_map_fd_by_name(obj, "user_time");

    if (user_fd < 0 || kernel_fd < 0)
        return 1;

    signal(SIGINT, handle_sigint);

    while (!exiting) {
        sleep(3);
        printf("\e[1;1H\e[2J");
        printf("Tracking CPU usage... Ctrl+C to exit\n");
        printf("CPU usage (PID, Total time, Kernel time, User time):\n");
        fflush(0);

        
        struct pid_entry *pid_list = read_pid_file("pid_data.txt");
        if (!pid_list) pid_list = NULL;

        __u32 key = 0, next_key;
        __u64 total = 0, kernel = 0, user = 0;

        if (bpf_map_get_next_key(kernel_fd, NULL, &key) != 0)
                continue;


        do {
            if (bpf_map_lookup_elem(kernel_fd, &key, &kernel) == 0 &&
                bpf_map_lookup_elem(user_fd, &key, &user) == 0) {

                double total = (kernel + user) / 1e6;
                update_pid_list(&pid_list, key, total, kernel / 1e6, user / 1e6);
            }
        } while (bpf_map_get_next_key(kernel_fd, &key, &next_key) == 0 && (key = next_key, 1));


        write_pid_file("pid_data.txt", pid_list);

        FILE *fp = fopen("pid_data.txt", "r");
        if (fp) {
            char line[256];
            printf("\n%-10s %-15s %-15s %-15s\n", "PID", "Total (ms)", "Kernel (ms)", "User (ms)");
            while (fgets(line, sizeof(line), fp)) {
                printf("%s", line);
            }
            fclose(fp);
        }

        free_pid_list(pid_list);
    }

    bpf_link__destroy(link_switch);
    bpf_link__destroy(link_enter);
    bpf_link__destroy(link_exit);
    bpf_object__close(obj);

    return 0;
}
