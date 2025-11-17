#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <time.h>
#include <ncurses.h>
#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <sys/types.h>
#include "prog.h"

static volatile sig_atomic_t exiting = 0;

void handle_sigint(int sig) {
    exiting = 1;
}

int get_map_fd_by_name(struct bpf_object *obj, const char *name) {
    struct bpf_map *map = bpf_object__find_map_by_name(obj, name);
    if (!map) {
        fprintf(stderr, "Failed to find map: %s\n", name);
        return -1;
    }
    return bpf_map__fd(map);
}

const char* get_operation_name(__u8 operation) {
    switch (operation) {
        case OP_READ: return "READ";
        case OP_WRITE: return "WRITE";
        default: return "UNKNOWN";
    }
}

void format_bytes(__u64 bytes, char *buf, size_t buflen) {
    const char *units[] = {"B", "KB", "MB", "GB", "TB"};
    int unit = 0;
    double size = (double)bytes;
    
    while (size >= 1024.0 && unit < 4) {
        size /= 1024.0;
        unit++;
    }
    
    snprintf(buf, buflen, "%.2f %s", size, units[unit]);
}

void format_time_ns(__u64 ns, char *buf, size_t buflen) {
    if (ns < 1000) {
        snprintf(buf, buflen, "%llu ns", (unsigned long long)ns);
    } else if (ns < 1000000) {
        snprintf(buf, buflen, "%.2f us", (double)ns / 1000.0);
    } else if (ns < 1000000000) {
        snprintf(buf, buflen, "%.2f ms", (double)ns / 1000000.0);
    } else {
        snprintf(buf, buflen, "%.2f s", (double)ns / 1000000000.0);
    }
}

void get_comm_by_pid(__u32 pid, char *buf, size_t buflen) {
    char path[64];
    snprintf(path, sizeof(path), "/proc/%u/comm", pid);
    FILE *f = fopen(path, "r");
    if (!f) {
        snprintf(buf, buflen, "-");
        return;
    }
    if (!fgets(buf, buflen, f)) {
        snprintf(buf, buflen, "-");
        fclose(f);
        return;
    }
    fclose(f);
    size_t len = strlen(buf);
    if (len > 0 && buf[len - 1] == '\n') buf[len - 1] = '\0';
}

static int is_kernel_thread(__u32 pid, const char *name) {
    if (!name || name[0] == '\0' || name[0] == '-') {
        return 0;
    }
    
    if (strncmp(name, "irq/", 4) == 0) return 1;
    if (strncmp(name, "kworker/", 8) == 0) return 1;
    if (strncmp(name, "ksoftirqd/", 10) == 0) return 1;
    if (strncmp(name, "rcu_", 4) == 0) return 1;
    if (strncmp(name, "migration/", 10) == 0) return 1;
    if (strncmp(name, "watchdog/", 9) == 0) return 1;
    
    if (pid < 10) return 1;
    
    return 0;
}

struct io_entry {
    struct io_key key;
    char name[64];
    __u64 bytes_read;
    __u64 bytes_written;
    __u64 ops_read;
    __u64 ops_write;
    __u64 total_latency_ns;
    __u64 max_latency_ns;
    __u64 min_latency_ns;
    __u64 last_update_ns;
    __u64 prev_bytes_read;
    __u64 prev_bytes_written;
    double io_rate_read;
    double io_rate_write;
    double io_rate_total;
    double avg_latency_us;
    struct io_entry *next;
};

static struct io_entry *find_or_add_io(struct io_entry **list, struct io_key *key) {
    struct io_entry *cur = *list;
    while (cur) {
        if (cur->key.pid == key->pid && cur->key.operation == key->operation) {
            return cur;
        }
        cur = cur->next;
    }
    struct io_entry *node = calloc(1, sizeof(struct io_entry));
    if (!node) return NULL;
    node->key = *key;
    if (key->pid > 0) {
        get_comm_by_pid(key->pid, node->name, sizeof(node->name));
    } else {
        snprintf(node->name, sizeof(node->name), "-");
    }
    node->next = *list;
    (*list) = node;
    return node;
}

static void free_io_list(struct io_entry *list) {
    while (list) {
        struct io_entry *tmp = list;
        list = list->next;
        free(tmp);
    }
}

static int compare_io_bandwidth(const void *va, const void *vb) {
    const struct io_entry *const *a = (const struct io_entry *const *)va;
    const struct io_entry *const *b = (const struct io_entry *const *)vb;
    
    if ((*b)->io_rate_total > (*a)->io_rate_total) return 1;
    if ((*b)->io_rate_total < (*a)->io_rate_total) return -1;
    
    __u64 total_a = (*a)->bytes_read + (*a)->bytes_written;
    __u64 total_b = (*b)->bytes_read + (*b)->bytes_written;
    if (total_b > total_a) return 1;
    if (total_b < total_a) return -1;
    
    return 0;
}

static struct bpf_link *attach_tracepoint(struct bpf_object *obj, const char *prog_name, 
                                          const char *category, const char *event) {
    struct bpf_program *prog = bpf_object__find_program_by_name(obj, prog_name);
    if (!prog) return NULL;
    
    struct bpf_link *link = bpf_program__attach_tracepoint(prog, category, event);
    if (link) {
        printf("Attached to %s:%s\n", category, event);
    }
    return link;
}

static void destroy_link(struct bpf_link *link) {
    if (link) {
        bpf_link__destroy(link);
    }
}

int main() {
    struct bpf_object *obj;
    int err;
    
    struct {
        const char *prog_name;
        const char *event;
        struct bpf_link *link;
    } tracepoints[] = {
        {"on_sys_enter_read", "sys_enter_read", NULL},
        {"on_sys_exit_read", "sys_exit_read", NULL},
        {"on_sys_enter_write", "sys_enter_write", NULL},
        {"on_sys_exit_write", "sys_exit_write", NULL},
        {"on_sys_enter_pread64", "sys_enter_pread64", NULL},
        {"on_sys_exit_pread64", "sys_exit_pread64", NULL},
        {"on_sys_enter_pwrite64", "sys_enter_pwrite64", NULL},
        {"on_sys_exit_pwrite64", "sys_exit_pwrite64", NULL},
        {"on_sys_enter_readv", "sys_enter_readv", NULL},
        {"on_sys_exit_readv", "sys_exit_readv", NULL},
        {"on_sys_enter_writev", "sys_enter_writev", NULL},
        {"on_sys_exit_writev", "sys_exit_writev", NULL},
    };
    const int num_tracepoints = sizeof(tracepoints) / sizeof(tracepoints[0]);
    
    signal(SIGINT, handle_sigint);
    
    obj = bpf_object__open_file("prog.bpf.o", NULL);
    if (!obj) {
        fprintf(stderr, "Failed to open BPF object\n");
        return 1;
    }
    
    err = bpf_object__load(obj);
    if (err) {
        fprintf(stderr, "Failed to load BPF object: %d\n", err);
        bpf_object__close(obj);
        return 1;
    }
    
    int attached_count = 0;
    for (int i = 0; i < num_tracepoints; i++) {
        tracepoints[i].link = attach_tracepoint(obj, tracepoints[i].prog_name, "syscalls", tracepoints[i].event);
        if (tracepoints[i].link) {
            attached_count++;
        }
    }
    
    if (attached_count == 0) {
        fprintf(stderr, "Error: Failed to attach any tracepoints\n");
        bpf_object__close(obj);
        return 1;
    }
    
    initscr();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    nodelay(stdscr, TRUE);
    curs_set(0);
    
    int io_stats_fd = get_map_fd_by_name(obj, "io_stats_map");
    int pid_stats_fd = get_map_fd_by_name(obj, "pid_stats");
    
    if (io_stats_fd < 0 || pid_stats_fd < 0) {
        endwin();
        for (int i = 0; i < num_tracepoints; i++) {
            destroy_link(tracepoints[i].link);
        }
        bpf_object__close(obj);
        return 1;
    }
    
    struct io_entry *state = NULL;
    struct timespec ts_prev = {0}, ts_now = {0};
    clock_gettime(CLOCK_MONOTONIC, &ts_prev);
    int scroll = 0;
    const double update_interval_ns = 1e9;
    const double alpha = 0.3;
    struct io_entry **view_cached = NULL;
    int view_count_cached = 0;
    
    while (!exiting) {
        int ch;
        while ((ch = getch()) != ERR) {
            if (ch == 'q' || ch == 'Q') { exiting = 1; break; }
            else if (ch == KEY_UP) { if (scroll > 0) scroll--; }
            else if (ch == KEY_DOWN) { if (view_cached && scroll < (view_count_cached - 1)) scroll++; }
            else if (ch == KEY_NPAGE) { if (view_cached) scroll += (LINES - 6); }
            else if (ch == KEY_PPAGE) { if (view_cached) scroll -= (LINES - 6); }
            if (scroll < 0) scroll = 0;
            if (view_cached && scroll > view_count_cached - 1) scroll = view_count_cached - 1;
        }
        
        clock_gettime(CLOCK_MONOTONIC, &ts_now);
        double elapsed_ns = (ts_now.tv_sec - ts_prev.tv_sec) * 1e9 + (ts_now.tv_nsec - ts_prev.tv_nsec);
        if (elapsed_ns >= update_interval_ns) {
            double interval_ns = elapsed_ns;
            ts_prev = ts_now;
            if (interval_ns <= 0) interval_ns = update_interval_ns;
            
            struct io_key key = {}, next_key;
            if (bpf_map_get_next_key(io_stats_fd, NULL, &key) == 0) {
                do {
                    struct io_stats stats;
                    if (bpf_map_lookup_elem(io_stats_fd, &key, &stats) == 0) {
                        struct io_entry *e = find_or_add_io(&state, &key);
                        if (!e) continue;
                        
                        __u64 d_read = 0, d_write = 0;
                        if (e->prev_bytes_read > 0 || e->prev_bytes_written > 0) {
                            if (stats.bytes_read >= e->prev_bytes_read) d_read = stats.bytes_read - e->prev_bytes_read;
                            if (stats.bytes_written >= e->prev_bytes_written) d_write = stats.bytes_written - e->prev_bytes_written;
                        }
                        
                        double elapsed_sec = interval_ns / 1e9;
                        if (elapsed_sec > 0) {
                            double inst_rate_read = (double)d_read / elapsed_sec;
                            double inst_rate_write = (double)d_write / elapsed_sec;
                            double inst_rate_total = inst_rate_read + inst_rate_write;
                            
                            if (e->io_rate_total == 0) {
                                e->io_rate_total = inst_rate_total;
                                e->io_rate_read = inst_rate_read;
                                e->io_rate_write = inst_rate_write;
                            } else {
                                e->io_rate_total = alpha * inst_rate_total + (1.0 - alpha) * e->io_rate_total;
                                e->io_rate_read = alpha * inst_rate_read + (1.0 - alpha) * e->io_rate_read;
                                e->io_rate_write = alpha * inst_rate_write + (1.0 - alpha) * e->io_rate_write;
                            }
                        }
                        
                        __u64 total_ops = stats.ops_read + stats.ops_write;
                        if (total_ops > 0) {
                            e->avg_latency_us = (double)stats.total_latency_ns / (double)total_ops / 1000.0;
                        }
                        
                        e->bytes_read = stats.bytes_read;
                        e->bytes_written = stats.bytes_written;
                        e->ops_read = stats.ops_read;
                        e->ops_write = stats.ops_write;
                        e->total_latency_ns = stats.total_latency_ns;
                        e->max_latency_ns = stats.max_latency_ns;
                        e->min_latency_ns = stats.min_latency_ns;
                        e->prev_bytes_read = stats.bytes_read;
                        e->prev_bytes_written = stats.bytes_written;
                        e->last_update_ns = stats.last_update_ns;
                        
                        if (e->name[0] == '\0' || e->name[0] == '-') {
                            if (key.pid > 0) {
                                get_comm_by_pid(key.pid, e->name, sizeof(e->name));
                            }
                        }
                    }
                } while (bpf_map_get_next_key(io_stats_fd, &key, &next_key) == 0 && (key = next_key, 1));
            }
            
            int count = 0;
            for (struct io_entry *c = state; c; c = c->next) {
                if ((c->bytes_read > 0 || c->bytes_written > 0 || c->io_rate_total > 0) &&
                    !is_kernel_thread(c->key.pid, c->name)) {
                    count++;
                }
            }
            struct io_entry **arr = count ? malloc(sizeof(*arr) * count) : NULL;
            struct io_entry **view = NULL;
            int view_count = 0;
            if (arr) {
                int i = 0;
                for (struct io_entry *c = state; c; c = c->next) {
                    if ((c->bytes_read > 0 || c->bytes_written > 0 || c->io_rate_total > 0) &&
                        !is_kernel_thread(c->key.pid, c->name)) {
                        arr[i++] = c;
                    }
                }
                qsort(arr, count, sizeof(*arr), compare_io_bandwidth);
                view_count = count > 50 ? 50 : count;
                if (view_count > 0) {
                    view = malloc(sizeof(*view) * view_count);
                    if (view) {
                        for (int j = 0; j < view_count; j++) view[j] = arr[j];
                    } else {
                        view_count = 0;
                    }
                }
            }
            if (arr) free(arr);
            if (view_cached) free(view_cached);
            view_cached = view;
            view_count_cached = view_count;
            if (scroll > 0 && view_count_cached > 0 && scroll > view_count_cached - 1) scroll = view_count_cached - 1;
            if (scroll < 0) scroll = 0;
        }
        
        erase();
        mvprintw(0, 0, "Disk Monitor - q: quit  up/down: scroll");
        mvprintw(1, 0, "%-7s %-20s %-6s %12s %12s %12s %12s %12s",
                 "PID", "PROCESS", "OP", "READ", "WRITE", "IO RATE", "OPS", "AVG LAT");
        
        int max_rows = LINES - 3;
        if (max_rows < 0) max_rows = 0;
        if (view_cached && view_count_cached > 0) {
            int start = scroll;
            int end = start + max_rows;
            if (end > view_count_cached) end = view_count_cached;
            int row = 2;
            for (int i = start; i < end; i++, row++) {
                struct io_entry *e = view_cached[i];
                
                if (is_kernel_thread(e->key.pid, e->name)) {
                    continue;
                }
                
                char read_str[32], write_str[32], rate_str[32], lat_str[32];
                format_bytes(e->bytes_read, read_str, sizeof(read_str));
                format_bytes(e->bytes_written, write_str, sizeof(write_str));
                format_bytes((__u64)e->io_rate_total, rate_str, sizeof(rate_str));
                format_time_ns((__u64)(e->avg_latency_us * 1000.0), lat_str, sizeof(lat_str));
                
                if (e->io_rate_total > 10 * 1024 * 1024) {
                    attron(A_REVERSE);
                }
                
                char rate_display[32];
                if (e->io_rate_total > 0) {
                    snprintf(rate_display, sizeof(rate_display), "%s/s", rate_str);
                } else {
                    __u64 total = e->bytes_read + e->bytes_written;
                    format_bytes(total, rate_display, sizeof(rate_display));
                }
                
                __u64 total_ops = e->ops_read + e->ops_write;
                
                mvprintw(row, 0, "%-7u %-20.20s %-6s %12s %12s %12s %12llu %12s",
                         e->key.pid, e->name,
                         get_operation_name(e->key.operation),
                         read_str, write_str, rate_display, total_ops, lat_str);
                
                if (e->io_rate_total > 10 * 1024 * 1024) {
                    attroff(A_REVERSE);
                }
            }
            
            int anomaly_count = 0;
            for (int i = 0; i < view_count_cached; i++) {
                if (view_cached[i]->io_rate_total > 10 * 1024 * 1024) {
                    anomaly_count++;
                }
            }
            if (anomaly_count > 0) {
                mvprintw(LINES - 1, 0, "ALERT: %d high I/O rate processes detected (>10 MB/s)", anomaly_count);
            } else {
                mvprintw(LINES - 1, 0, "No anomalies detected");
            }
        } else {
            mvprintw(3, 0, "No disk I/O data yet... (generate some I/O: cat, dd, etc.)");
        }
        refresh();
        
        struct timespec tiny = { .tv_sec = 0, .tv_nsec = 10000000 };
        nanosleep(&tiny, NULL);
    }
    
    if (view_cached) free(view_cached);
    free_io_list(state);
    endwin();
    for (int i = 0; i < num_tracepoints; i++) {
        destroy_link(tracepoints[i].link);
    }
    bpf_object__close(obj);
    
    return 0;
}

