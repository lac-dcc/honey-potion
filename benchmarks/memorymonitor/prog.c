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
};

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
    __u64 rss_kb;
    __u64 virtual_kb;
    __u64 peak_rss_kb;
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
        if (cur->pid == pid) return cur;
        cur = cur->next;
    }
    
    struct pid_entry *new_entry = calloc(1, sizeof(*new_entry));
    if (!new_entry) return NULL;
    
    new_entry->pid = pid;
    new_entry->next = *list;
    *list = new_entry;
    return new_entry;
}

static void get_comm_by_pid(__u32 pid, char *buf, size_t size) {
    char path[64];
    snprintf(path, sizeof(path), "/proc/%u/comm", pid);
    FILE *f = fopen(path, "r");
    if (!f) {
        buf[0] = '\0';
        return;
    }
    
    if (fgets(buf, size, f)) {
        size_t len = strlen(buf);
        if (len > 0 && buf[len - 1] == '\n') buf[len - 1] = '\0';
    }
    fclose(f);
}

static void get_real_memory_usage(__u32 pid, __u64 *rss_kb, __u64 *virtual_kb, __u64 *peak_rss_kb) {
    char path[64];
    snprintf(path, sizeof(path), "/proc/%u/status", pid);
    FILE *f = fopen(path, "r");
    if (!f) {
        *rss_kb = *virtual_kb = *peak_rss_kb = 0;
        return;
    }
    
    *rss_kb = *virtual_kb = *peak_rss_kb = 0;
    
    char line[256];
    while (fgets(line, sizeof(line), f)) {
        char *newline = strchr(line, '\n');
        if (newline) *newline = '\0';
        
        if (strncmp(line, "VmRSS:", 6) == 0) {
            char *ptr = line + 6;
            while (*ptr && (*ptr == ' ' || *ptr == '\t')) ptr++;
            if (*ptr) *rss_kb = strtoul(ptr, NULL, 10);
        } else if (strncmp(line, "VmSize:", 7) == 0) {
            char *ptr = line + 7;
            while (*ptr && (*ptr == ' ' || *ptr == '\t')) ptr++;
            if (*ptr) *virtual_kb = strtoul(ptr, NULL, 10);
        } else if (strncmp(line, "VmHWM:", 6) == 0) {
            char *ptr = line + 6;
            while (*ptr && (*ptr == ' ' || *ptr == '\t')) ptr++;
            if (*ptr) *peak_rss_kb = strtoul(ptr, NULL, 10);
        }
    }
    fclose(f);
}

static int compare_pid_entries_desc_memory(const void *va, const void *vb) {
    const struct pid_entry *const *a = (const struct pid_entry *const *)va;
    const struct pid_entry *const *b = (const struct pid_entry *const *)vb;
    if ((*b)->rss_kb > (*a)->rss_kb) return 1;
    if ((*b)->rss_kb < (*a)->rss_kb) return -1;
    if ((*a)->pid < (*b)->pid) return -1;
    if ((*a)->pid > (*b)->pid) return 1;
    return 0;
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
        snprintf(buf, sizeof(buf), "%.0f %s", size, units[unit]);
    } else {
        snprintf(buf, sizeof(buf), "%.1f %s", size, units[unit]);
    }
    
    return buf;
}

int main() {
    signal(SIGINT, handle_sigint);
    
    struct bpf_object *obj = bpf_object__open_file("prog.bpf.o", NULL);
    if (!obj) {
        fprintf(stderr, "Failed to open BPF object\n");
        return 1;
    }

    if (bpf_object__load(obj)) {
        fprintf(stderr, "Failed to load BPF object\n");
        return 1;
    }

    struct bpf_map *mem_stats_fd = bpf_object__find_map_by_name(obj, "mem_stats_map");
    if (!mem_stats_fd) {
        fprintf(stderr, "Failed to find mem_stats map\n");
        return 1;
    }

    int mem_stats_map_fd = bpf_map__fd(mem_stats_fd);
    if (mem_stats_map_fd < 0) {
        fprintf(stderr, "Failed to get mem_stats map fd\n");
        return 1;
    }

    struct bpf_program *prog_mmap = bpf_object__find_program_by_name(obj, "trace_mmap_enter");
    if (!prog_mmap) {
        fprintf(stderr, "Failed to find program trace_mmap_enter\n");
        return 1;
    }

    struct bpf_program *prog_munmap = bpf_object__find_program_by_name(obj, "trace_munmap_enter");
    if (!prog_munmap) {
        fprintf(stderr, "Failed to find program trace_munmap_enter\n");
        return 1;
    }

    struct bpf_link *link_mmap = bpf_program__attach(prog_mmap);
    if (!link_mmap) {
        fprintf(stderr, "Failed to attach mmap program\n");
        return 1;
    }

    struct bpf_link *link_munmap = bpf_program__attach(prog_munmap);
    if (!link_munmap) {
        fprintf(stderr, "Failed to attach munmap program\n");
        return 1;
    }

    initscr();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    nodelay(stdscr, TRUE);

    struct pid_entry *state = NULL;
    struct pid_entry **view = NULL;
    int view_count = 0;
    int scroll = 0;
    time_t last_update = 0;

    while (!exiting) {
        time_t now = time(NULL);
        if (now - last_update >= 3) {
            last_update = now;
            
            if (view) {
                free(view);
                view = NULL;
                view_count = 0;
            }

            __u32 key = 0;
            __u32 next_key = 0;
            while (bpf_map_get_next_key(mem_stats_map_fd, &key, &next_key) == 0) {
                struct mem_stats stats;
                if (bpf_map_lookup_elem(mem_stats_map_fd, &key, &stats) == 0) {
                    struct pid_entry *e = find_or_add_pid(&state, key);
                    if (e) {
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
                }
                key = next_key;
            }

            DIR *proc_dir = opendir("/proc");
            if (proc_dir) {
                struct dirent *entry;
                while ((entry = readdir(proc_dir)) != NULL) {
                    if (entry->d_type == DT_DIR) {
                        __u32 pid = strtoul(entry->d_name, NULL, 10);
                        if (pid > 0) {
                            struct pid_entry *e = find_or_add_pid(&state, pid);
                            if (e) {
                                if (e->name[0] == '\0' || e->name[0] == '-') {
                                    get_comm_by_pid(pid, e->name, sizeof(e->name));
                                }
                                get_real_memory_usage(pid, &e->rss_kb, &e->virtual_kb, &e->peak_rss_kb);
                            }
                        }
                    }
                }
                closedir(proc_dir);
            }

            int count = 0;
            for (struct pid_entry *c = state; c; c = c->next) {
                if (c->name[0] && c->name[0] != '-' && c->rss_kb > 0) count++;
            }

            if (count > 0) {
                struct pid_entry **arr = malloc(sizeof(*arr) * count);
                if (arr) {
                    int i = 0;
                    for (struct pid_entry *c = state; c; c = c->next) {
                        if (c->name[0] && c->name[0] != '-' && c->rss_kb > 0) {
                            arr[i++] = c;
                        }
                    }
                    qsort(arr, count, sizeof(*arr), compare_pid_entries_desc_memory);
                    view_count = count > 100 ? 100 : count;
                    if (view_count > 0) {
                        view = malloc(sizeof(*view) * view_count);
                        if (view) {
                            for (int j = 0; j < view_count; j++) view[j] = arr[j];
                        } else {
                            view_count = 0;
                        }
                    }
                    free(arr);
                }
            }
        }

        int ch = getch();
        if (ch != ERR) {
            if (ch == 'q' || ch == 'Q') break;
            if (ch == KEY_UP && scroll > 0) scroll--;
            if (ch == KEY_DOWN && view_count > 0 && scroll < view_count - 1) scroll++;
            if (ch == KEY_PPAGE && scroll > 10) scroll -= 10;
            if (ch == KEY_NPAGE && view_count > 0 && scroll < view_count - 10) scroll += 10;
            if (scroll > 0 && view_count > 0 && scroll > view_count - 1) scroll = view_count - 1;
            if (scroll < 0) scroll = 0;
        }

        clear();
        mvprintw(0, 0, "Memory Monitor - q: quit  ↑/↓: scroll");
        mvprintw(1, 0, "%-7s %-20s %12s %12s %12s %8s %8s",
                 "PID", "NAME", "RSS(KB)", "VIRT(KB)", "PEAK(KB)", "MMAP#", "MUNMAP#");
        int max_rows = LINES - 3;
        if (max_rows < 0) max_rows = 0;
        if (view && view_count > 0) {
            int start = scroll;
            int end = start + max_rows;
            if (end > view_count) end = view_count;
            int row = 2;
            for (int i = start; i < end; i++, row++) {
                struct pid_entry *e = view[i];
                mvprintw(row, 0, "%-7u %-20.20s %12llu %12llu %12llu %8llu %8llu",
                         e->pid, e->name,
                         e->rss_kb,
                         e->virtual_kb,
                         e->peak_rss_kb,
                         e->mmap_count,
                         e->munmap_count);
            }
        } else {
            mvprintw(3, 0, "Waiting for memory data...");
        }
        refresh();
        usleep(100000);
    }

    endwin();
    bpf_link__destroy(link_mmap);
    bpf_link__destroy(link_munmap);
    bpf_object__close(obj);
    free_pid_list(state);
    if (view) free(view);
    return 0;
}