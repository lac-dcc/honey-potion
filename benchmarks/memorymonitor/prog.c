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
#include <dirent.h>

static volatile sig_atomic_t exiting = 0;

void handle_sigint(int sig) {
    exiting = 1;
}

struct pid_entry {
    __u32 pid;
    char name[64];
    __u64 total_allocated;
    __u64 total_freed;
    __u64 current_usage;
    __u64 peak_usage;
    __u64 alloc_count;
    __u64 free_count;
    __u64 mmap_count;
    __u64 munmap_count;
    __u64 last_update;
    // Real memory usage from /proc
    __u64 rss_kb;        // Current RSS from /proc/status
    __u64 virtual_kb;    // Virtual memory from /proc/status
    __u64 peak_rss_kb;   // Peak RSS from /proc/status
    struct pid_entry *next;
};

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

// Read real memory usage from /proc/[pid]/status
static void get_real_memory_usage(__u32 pid, __u64 *rss_kb, __u64 *virtual_kb, __u64 *peak_rss_kb) {
    char path[64];
    snprintf(path, sizeof(path), "/proc/%u/status", pid);
    FILE *f = fopen(path, "r");
    if (!f) {
        *rss_kb = 0;
        *virtual_kb = 0;
        *peak_rss_kb = 0;
        return;
    }
    
    char line[256];
    while (fgets(line, sizeof(line), f)) {
        if (strncmp(line, "VmRSS:", 6) == 0) {
            char *ptr = strtok(line, " \t");
            ptr = strtok(NULL, " \t"); // Get the number
            if (ptr) {
                char *newline = strchr(ptr, '\n');
                if (newline) *newline = '\0';
                *rss_kb = strtoul(ptr, NULL, 10);
            }
        } else if (strncmp(line, "VmSize:", 7) == 0) {
            char *ptr = strtok(line, " \t");
            ptr = strtok(NULL, " \t");
            if (ptr) {
                char *newline = strchr(ptr, '\n');
                if (newline) *newline = '\0';
                *virtual_kb = strtoul(ptr, NULL, 10);
            }
        } else if (strncmp(line, "VmHWM:", 6) == 0) {
            char *ptr = strtok(line, " \t");
            ptr = strtok(NULL, " \t");
            if (ptr) {
                char *newline = strchr(ptr, '\n');
                if (newline) *newline = '\0';
                *peak_rss_kb = strtoul(ptr, NULL, 10);
            }
        }
    }
    fclose(f);
}

static int compare_pid_entries_desc_memory(const void *va, const void *vb) {
    const struct pid_entry *const *a = (const struct pid_entry *const *)va;
    const struct pid_entry *const *b = (const struct pid_entry *const *)vb;
    // Sort by real RSS memory usage (from /proc)
    if ((*b)->rss_kb > (*a)->rss_kb) return 1;
    if ((*b)->rss_kb < (*a)->rss_kb) return -1;
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

static const char* format_bytes(__u64 bytes) {
    static char buf[32];
    const char* units[] = {"B", "KB", "MB", "GB", "TB"};
    int unit = 0;
    double size = (double)bytes;
    
    while (size >= 1024.0 && unit < 4) {
        size /= 1024.0;
        unit++;
    }
    
    if (unit == 0) {
        snprintf(buf, sizeof(buf), "%llu %s", bytes, units[unit]);
    } else {
        snprintf(buf, sizeof(buf), "%.1f %s", size, units[unit]);
    }
    
    return buf;
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

    // Attach to memory-related tracepoints
    struct bpf_program *prog_mmap = bpf_object__find_program_by_name(obj, "trace_mmap_enter");
    if (!prog_mmap) {
        fprintf(stderr, "Failed to find program trace_mmap_enter\n");
        return 1;
    }
    struct bpf_link *link_mmap = bpf_program__attach_tracepoint(prog_mmap, "syscalls", "sys_enter_mmap");
    if (!link_mmap) {
        fprintf(stderr, "Failed to attach to sys_enter_mmap\n");
        return 1;
    }

    struct bpf_program *prog_munmap = bpf_object__find_program_by_name(obj, "trace_munmap_enter");
    if (!prog_munmap) {
        fprintf(stderr, "Failed to find program trace_munmap_enter\n");
        return 1;
    }
    struct bpf_link *link_munmap = bpf_program__attach_tracepoint(prog_munmap, "syscalls", "sys_enter_munmap");
    if (!link_munmap) {
        fprintf(stderr, "Failed to attach to sys_enter_munmap\n");
        return 1;
    }

    struct bpf_program *prog_brk = bpf_object__find_program_by_name(obj, "trace_brk_enter");
    if (!prog_brk) {
        fprintf(stderr, "Failed to find program trace_brk_enter\n");
        return 1;
    }
    struct bpf_link *link_brk = bpf_program__attach_tracepoint(prog_brk, "syscalls", "sys_enter_brk");
    if (!link_brk) {
        fprintf(stderr, "Failed to attach to sys_enter_brk\n");
        return 1;
    }

    // Prepare ncurses UI
    initscr();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    nodelay(stdscr, TRUE);
    curs_set(0);

    mvprintw(0, 0, "Memory Monitor - q: quit  up/down: scroll");
    refresh();
    
    int mem_stats_fd = get_map_fd_by_name(obj, "mem_stats_map");
    if (mem_stats_fd < 0) {
        fprintf(stderr, "Failed to get mem_stats_map file descriptor\n");
        return 1;
    }

    signal(SIGINT, handle_sigint);

    struct pid_entry *state = NULL;
    struct timespec ts_prev = {0}, ts_now = {0};
    clock_gettime(CLOCK_MONOTONIC, &ts_prev);
    int scroll = 0;
    const double update_interval_ns = 3e9; // 3s
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

        // Periodic data update (~3s)
        clock_gettime(CLOCK_MONOTONIC, &ts_now);
        double elapsed_ns = (ts_now.tv_sec - ts_prev.tv_sec) * 1e9 + (ts_now.tv_nsec - ts_prev.tv_nsec);
        if (elapsed_ns >= update_interval_ns) {
            ts_prev = ts_now;

            // First, read eBPF statistics
            __u32 key = 0, next_key;
            struct mem_stats {
                __u64 total_allocated;
                __u64 total_freed;
                __u64 current_usage;
                __u64 peak_usage;
                __u64 alloc_count;
                __u64 free_count;
                __u64 mmap_count;
                __u64 munmap_count;
                __u64 last_update;
            } stats = {};
            
            if (bpf_map_get_next_key(mem_stats_fd, NULL, &key) == 0) {
                do {
                    if (bpf_map_lookup_elem(mem_stats_fd, &key, &stats) == 0) {
                        struct pid_entry *e = find_or_add_pid(&state, key);
                        if (!e) continue;
                        
                        if (e->name[0] == '\0' || e->name[0] == '-') {
                            get_comm_by_pid(key, e->name, sizeof(e->name));
                        }

                        e->total_allocated = stats.total_allocated;
                        e->total_freed = stats.total_freed;
                        e->current_usage = stats.current_usage;
                        e->peak_usage = stats.peak_usage;
                        e->alloc_count = stats.alloc_count;
                        e->free_count = stats.free_count;
                        e->mmap_count = stats.mmap_count;
                        e->munmap_count = stats.munmap_count;
                        e->last_update = stats.last_update;
                    }
                } while (bpf_map_get_next_key(mem_stats_fd, &key, &next_key) == 0 && (key = next_key, 1));
            }

            // Then, scan /proc for all processes and read real memory usage
            DIR *proc_dir = opendir("/proc");
            if (proc_dir) {
                struct dirent *entry;
                while ((entry = readdir(proc_dir)) != NULL) {
                    if (entry->d_type == DT_DIR && entry->d_name[0] >= '0' && entry->d_name[0] <= '9') {
                        __u32 pid = atoi(entry->d_name);
                        
                        struct pid_entry *e = find_or_add_pid(&state, pid);
                        if (!e) continue;
                        
                        // Get process name
                        if (e->name[0] == '\0' || e->name[0] == '-') {
                            get_comm_by_pid(pid, e->name, sizeof(e->name));
                        }
                        
                        // Get real memory usage from /proc
                        get_real_memory_usage(pid, &e->rss_kb, &e->virtual_kb, &e->peak_rss_kb);
                    }
                }
                closedir(proc_dir);
            }

            // Rebuild cached view
            int count = 0;
            for (struct pid_entry *c = state; c; c = c->next) {
                if (c->name[0] && c->name[0] != '-' && c->rss_kb > 0) count++;
            }
            struct pid_entry **arr = count ? malloc(sizeof(*arr) * count) : NULL;
            struct pid_entry **view = NULL;
            int view_count = 0;
            if (arr) {
                int i = 0;
                for (struct pid_entry *c = state; c; c = c->next) {
                    if (c->name[0] && c->name[0] != '-' && c->rss_kb > 0) {
                        arr[i++] = c;
                    }
                }
                qsort(arr, count, sizeof(*arr), compare_pid_entries_desc_memory);
                view_count = count > 100 ? 100 : count; // Limit to top 100 processes
                if (view_count > 0) {
                    view = malloc(sizeof(*view) * view_count);
                    if (view) {
                        for (int j = 0; j < view_count; j++) view[j] = arr[j];
                        // Keep sorted by memory usage (already sorted by compare_pid_entries_desc_memory)
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
        clear();
        mvprintw(0, 0, "Memory Monitor - q: quit  ↑/↓: scroll");
        mvprintw(1, 0, "%-7s %-20s %12s %12s %12s %8s %8s",
                 "PID", "NAME", "RSS(MB)", "VIRT(MB)", "PEAK(MB)", "MMAP#", "MUNMAP#");
        int max_rows = LINES - 3;
        if (max_rows < 0) max_rows = 0;
        if (view_cached && view_count_cached > 0) {
            int start = scroll;
            int end = start + max_rows;
            if (end > view_count_cached) end = view_count_cached;
            int row = 2;
            for (int i = start; i < end; i++, row++) {
                struct pid_entry *e = view_cached[i];
                mvprintw(row, 0, "%-7u %-20.20s %12.1f %12.1f %12.1f %8llu %8llu",
                         e->pid, e->name,
                         e->rss_kb / 1024.0,
                         e->virtual_kb / 1024.0,
                         e->peak_rss_kb / 1024.0,
                         e->mmap_count,
                         e->munmap_count);
            }
        } else {
            mvprintw(3, 0, "Waiting for memory data...");
        }
        refresh();

        // Render/input at ~100 FPS
        struct timespec tiny = { .tv_sec = 0, .tv_nsec = 10000000 };
        nanosleep(&tiny, NULL);
    }

    bpf_link__destroy(link_mmap);
    bpf_link__destroy(link_munmap);
    bpf_link__destroy(link_brk);
    if (view_cached) free(view_cached);
    free_pid_list(state);
    endwin();
    bpf_object__close(obj);

    return 0;
}