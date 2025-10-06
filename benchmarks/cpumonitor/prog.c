#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <bpf/libbpf.h>
#include <bpf/bpf.h>
#include <string.h>
#include <time.h>
#include <ncurses.h>
#include <sys/types.h>
#include <sys/sysinfo.h>
#include "prog.skel.h"


static volatile sig_atomic_t exiting = 0;

void handle_sigint(int sig) {
    exiting = 1;
}

struct pid_entry {
    __u32 pid;
    char name[64];
    double total_ms;
    double kernel_ms;
    double user_ms;
    double pct_total;
    double pct_kernel;
    double pct_user;
    double smoothed_pct_total;
    double smoothed_pct_kernel;
    double smoothed_pct_user;
    // previous cumulative values for delta calculations (ns)
    unsigned long long prev_kernel_ns;
    unsigned long long prev_user_ns;
    struct pid_entry *next;
};

static long get_num_cpus(void) {
    long n = sysconf(_SC_NPROCESSORS_ONLN);
    return n > 0 ? n : 1;
}

static void free_pid_list(struct pid_entry *list) {
    while (list) {
        struct pid_entry *tmp = list;
        list = list->next;
        free(tmp);
    }
}

static struct pid_entry *find_or_add_pid(struct pid_entry **list, __u32 pid) {
    struct pid_entry *cur = *list;
    while (cur) {
        if (cur->pid == pid)
            return cur;
        cur = cur->next;
    }
    struct pid_entry *node = calloc(1, sizeof(struct pid_entry));
    if (!node) return NULL;
    node->pid = pid;
    node->next = *list;
    (*list) = node;
    return node;
}

static void get_comm_by_pid(__u32 pid, char *buf, size_t buflen) {
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

static int compare_pid_entries_desc_total(const void *va, const void *vb) {
    const struct pid_entry *const *a = (const struct pid_entry *const *)va;
    const struct pid_entry *const *b = (const struct pid_entry *const *)vb;
    if ((*b)->pct_total > (*a)->pct_total) return 1;
    if ((*b)->pct_total < (*a)->pct_total) return -1;
    if ((*b)->total_ms > (*a)->total_ms) return 1;
    if ((*b)->total_ms < (*a)->total_ms) return -1;
    if ((*a)->pid < (*b)->pid) return -1;
    if ((*a)->pid > (*b)->pid) return 1;
    return 0;
}

static int compare_pid_entries_name_asc(const void *va, const void *vb) {
    const struct pid_entry *const *a = (const struct pid_entry *const *)va;
    const struct pid_entry *const *b = (const struct pid_entry *const *)vb;
    const char *an = (*a)->name[0] ? (*a)->name : "";
    const char *bn = (*b)->name[0] ? (*b)->name : "";
    int c = strcmp(an, bn);
    if (c != 0) return c;
    if ((*a)->pid < (*b)->pid) return -1;
    if ((*a)->pid > (*b)->pid) return 1;
    return 0;
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

    // Prepare ncurses UI
    initscr();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    nodelay(stdscr, TRUE);
    curs_set(0);

    mvprintw(0, 0, "CPU Monitor - q: quit  up/down: scroll");
    refresh();
    int kernel_fd = get_map_fd_by_name(obj, "kernel_time");
    int user_fd = get_map_fd_by_name(obj, "user_time");

    if (user_fd < 0 || kernel_fd < 0)
        return 1;

    signal(SIGINT, handle_sigint);

    struct pid_entry *state = NULL; // persistent per-pid state
    long num_cpus = get_num_cpus();
    struct timespec ts_prev = {0}, ts_now = {0};
    clock_gettime(CLOCK_MONOTONIC, &ts_prev);
    int scroll = 0;
    const double update_interval_ns = 1e9; // 1s
    const double alpha = 0.3; // smoothing factor for EMA
    struct pid_entry **view_cached = NULL;
    int view_count_cached = 0;

    while (!exiting) {
        // Smooth, responsive input handling
        int ch;
        while ((ch = getch()) != ERR) {
            if (ch == 'q' || ch == 'Q') { exiting = 1; break; }
            else if (ch == KEY_UP) { if (scroll > 0) scroll--; }
            else if (ch == KEY_DOWN) { if (view_cached && scroll < (view_count_cached - 1)) scroll++; }
            else if (ch == KEY_NPAGE) { if (view_cached) scroll += (LINES - 4); }
            else if (ch == KEY_PPAGE) { if (view_cached) scroll -= (LINES - 4); }
            if (scroll < 0) scroll = 0;
            if (view_cached && scroll > view_count_cached - 1) scroll = view_count_cached - 1;
        }

        // Periodic data update (~1s)
        clock_gettime(CLOCK_MONOTONIC, &ts_now);
        double elapsed_ns = (ts_now.tv_sec - ts_prev.tv_sec) * 1e9 + (ts_now.tv_nsec - ts_prev.tv_nsec);
        if (elapsed_ns >= update_interval_ns) {
            double interval_ns = elapsed_ns;
            ts_prev = ts_now;
            if (interval_ns <= 0) interval_ns = update_interval_ns;

            __u32 key = 0, next_key;
            __u64 kernel = 0, user = 0;
            if (bpf_map_get_next_key(kernel_fd, NULL, &key) == 0) {
                do {
                    if (bpf_map_lookup_elem(kernel_fd, &key, &kernel) == 0 &&
                        bpf_map_lookup_elem(user_fd, &key, &user) == 0) {
                        struct pid_entry *e = find_or_add_pid(&state, key);
                        if (!e) continue;
                        if (e->name[0] == '\0' || e->name[0] == '-') {
                            get_comm_by_pid(key, e->name, sizeof(e->name));
                        }

                        double kernel_ms = (double)kernel / 1e6;
                        double user_ms = (double)user / 1e6;
                        double total_ms = kernel_ms + user_ms;

                        unsigned long long d_kernel = 0;
                        unsigned long long d_user = 0;
                        if (e->prev_kernel_ns > 0 || e->prev_user_ns > 0) {
                            if (kernel >= e->prev_kernel_ns) d_kernel = kernel - e->prev_kernel_ns;
                            if (user >= e->prev_user_ns) d_user = user - e->prev_user_ns;
                        }
                        unsigned long long d_total = d_kernel + d_user;

                        double denom = interval_ns * (double)num_cpus;
                        double inst_total = denom > 0 ? (100.0 * (double)d_total / denom) : 0.0;
                        double inst_kernel = denom > 0 ? (100.0 * (double)d_kernel / denom) : 0.0;
                        double inst_user = denom > 0 ? (100.0 * (double)d_user / denom) : 0.0;

                        if (e->smoothed_pct_total == 0 && e->smoothed_pct_kernel == 0 && e->smoothed_pct_user == 0) {
                            e->smoothed_pct_total = inst_total;
                            e->smoothed_pct_kernel = inst_kernel;
                            e->smoothed_pct_user = inst_user;
                        } else {
                            e->smoothed_pct_total = alpha * inst_total + (1.0 - alpha) * e->smoothed_pct_total;
                            e->smoothed_pct_kernel = alpha * inst_kernel + (1.0 - alpha) * e->smoothed_pct_kernel;
                            e->smoothed_pct_user = alpha * inst_user + (1.0 - alpha) * e->smoothed_pct_user;
                        }

                        e->kernel_ms = kernel_ms;
                        e->user_ms = user_ms;
                        e->total_ms = total_ms;
                        e->pct_total = e->smoothed_pct_total;
                        e->pct_kernel = e->smoothed_pct_kernel;
                        e->pct_user = e->smoothed_pct_user;
                        e->prev_kernel_ns = kernel;
                        e->prev_user_ns = user;
                    }
                } while (bpf_map_get_next_key(kernel_fd, &key, &next_key) == 0 && (key = next_key, 1));
            }

            // Rebuild cached view with filters/limits
            int count = 0;
            for (struct pid_entry *c = state; c; c = c->next) {
                if (c->name[0] && c->name[0] != '-') count++;
            }
            struct pid_entry **arr = count ? malloc(sizeof(*arr) * count) : NULL;
            struct pid_entry **view = NULL;
            int view_count = 0;
            if (arr) {
                int i = 0;
                for (struct pid_entry *c = state; c; c = c->next) {
                    if (c->name[0] && c->name[0] != '-') arr[i++] = c;
                }
                qsort(arr, count, sizeof(*arr), compare_pid_entries_desc_total);
                view_count = count > 100 ? 100 : count;
                if (view_count > 0) {
                    view = malloc(sizeof(*view) * view_count);
                    if (view) {
                        for (int j = 0; j < view_count; j++) view[j] = arr[j];
                        qsort(view, view_count, sizeof(*view), compare_pid_entries_name_asc);
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

        // Draw from cached view
        erase();
        mvprintw(0, 0, "CPU Monitor - q: quit  ↑/↓: scroll   CPUs:%ld", num_cpus);
        mvprintw(1, 0, "%-7s %-20s %8s %8s %8s   %10s %10s %10s",
                 "PID", "NAME", "%USR", "%SYS", "%TOT", "USER(ms)", "KERN(ms)", "TOTAL(ms)");
        int max_rows = LINES - 3;
        if (max_rows < 0) max_rows = 0;
        if (view_cached && view_count_cached > 0) {
            int start = scroll;
            int end = start + max_rows;
            if (end > view_count_cached) end = view_count_cached;
            int row = 2;
            for (int i = start; i < end; i++, row++) {
                struct pid_entry *e = view_cached[i];
                mvprintw(row, 0, "%-7u %-20.20s %8.2f %8.2f %8.2f   %10.0f %10.0f %10.0f",
                         e->pid, e->name,
                         e->pct_user, e->pct_kernel, e->pct_total,
                         e->user_ms, e->kernel_ms, e->total_ms);
            }
        } else {
            mvprintw(3, 0, "No data yet...");
        }
        refresh();

        // Render/input at ~100 FPS
        struct timespec tiny = { .tv_sec = 0, .tv_nsec = 10000000 };
        nanosleep(&tiny, NULL);
    }

    bpf_link__destroy(link_switch);
    bpf_link__destroy(link_enter);
    bpf_link__destroy(link_exit);
    if (view_cached) free(view_cached);
    endwin();
    bpf_object__close(obj);

    return 0;
}
