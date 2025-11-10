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
#include <sys/sysinfo.h>
#include <arpa/inet.h>
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

const char* get_protocol_name(__u8 protocol) {
    switch (protocol) {
        case 6: return "TCP";   // PROTO_TCP
        case 17: return "UDP";  // PROTO_UDP
        case 1: return "ICMP";  // PROTO_ICMP
        case 2: return "IGMP";
        case 41: return "IPv6";
        case 47: return "GRE";
        case 50: return "ESP";
        case 51: return "AH";
        case 132: return "SCTP";
        default: 
            if (protocol == 0) return "NONE";
            return "OTHER";
    }
}

const char* get_port_name(__u16 port) {
    switch (port) {
        case 80: return "HTTP";
        case 443: return "HTTPS";
        case 22: return "SSH";
        case 53: return "DNS";
        case 25: return "SMTP";
        case 587: return "SMTP-S";
        case 110: return "POP3";
        case 143: return "IMAP";
        case 993: return "IMAPS";
        case 3306: return "MySQL";
        case 5432: return "PostgreSQL";
        case 6379: return "Redis";
        case 27017: return "MongoDB";
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

void format_ip(__u32 ip, char *buf, size_t buflen) {
    struct in_addr addr;
    addr.s_addr = ip;
    snprintf(buf, buflen, "%s", inet_ntoa(addr));
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
        return 0;  // Unknown, assume not kernel thread
    }
    
    // Common kernel thread patterns
    if (strncmp(name, "irq/", 4) == 0) return 1;
    if (strncmp(name, "kworker/", 8) == 0) return 1;
    if (strncmp(name, "ksoftirqd/", 10) == 0) return 1;
    if (strncmp(name, "rcu_", 4) == 0) return 1;
    if (strncmp(name, "migration/", 10) == 0) return 1;
    if (strncmp(name, "watchdog/", 9) == 0) return 1;
    
    // Very low PIDs are often kernel threads
    if (pid < 10) return 1;
    
    return 0;
}

struct traffic_entry {
    struct traffic_key key;
    char name[64];
    char ip_str[INET_ADDRSTRLEN];
    __u64 bytes_sent;
    __u64 bytes_recv;
    __u64 packets_sent;
    __u64 packets_recv;
    __u64 prev_bytes_sent;
    __u64 prev_bytes_recv;
    __u64 last_update_ns;
    double bandwidth_sent;  // bytes per second
    double bandwidth_recv;  // bytes per second
    double bandwidth_total; // total bytes per second
    double smoothed_bandwidth;
    struct traffic_entry *next;
};

static struct traffic_entry *find_or_add_traffic(struct traffic_entry **list, struct traffic_key *key) {
    struct traffic_entry *cur = *list;
    while (cur) {
        if (cur->key.pid == key->pid &&
            cur->key.protocol == key->protocol &&
            cur->key.port == key->port &&
            cur->key.ip == key->ip) {
            return cur;
        }
        cur = cur->next;
    }
    struct traffic_entry *node = calloc(1, sizeof(struct traffic_entry));
    if (!node) return NULL;
    node->key = *key;
    format_ip(key->ip, node->ip_str, sizeof(node->ip_str));
    if (key->pid > 0) {
        get_comm_by_pid(key->pid, node->name, sizeof(node->name));
    } else {
        snprintf(node->name, sizeof(node->name), "-");
    }
    node->next = *list;
    (*list) = node;
    return node;
}

static void free_traffic_list(struct traffic_entry *list) {
    while (list) {
        struct traffic_entry *tmp = list;
        list = list->next;
        free(tmp);
    }
}

static int compare_traffic_bandwidth(const void *va, const void *vb) {
    const struct traffic_entry *const *a = (const struct traffic_entry *const *)va;
    const struct traffic_entry *const *b = (const struct traffic_entry *const *)vb;
    
    // First compare by bandwidth if available
    if ((*b)->bandwidth_total > (*a)->bandwidth_total) return 1;
    if ((*b)->bandwidth_total < (*a)->bandwidth_total) return -1;
    
    // If bandwidth is equal, compare by total bytes
    __u64 total_a = (*a)->bytes_sent + (*a)->bytes_recv;
    __u64 total_b = (*b)->bytes_sent + (*b)->bytes_recv;
    if (total_b > total_a) return 1;
    if (total_b < total_a) return -1;
    
    return 0;
}

int main() {
    struct bpf_object *obj;
    int err;
    struct bpf_link *link_sendto = NULL;
    struct bpf_link *link_recvfrom = NULL;
    struct bpf_link *link_sendmsg = NULL;
    struct bpf_link *link_recvmsg = NULL;
    
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
    
    struct bpf_program *prog_sendto = bpf_object__find_program_by_name(obj, "on_sys_enter_sendto");
    struct bpf_program *prog_recvfrom = bpf_object__find_program_by_name(obj, "on_sys_enter_recvfrom");
    struct bpf_program *prog_sendmsg = bpf_object__find_program_by_name(obj, "on_sys_enter_sendmsg");
    struct bpf_program *prog_recvmsg = bpf_object__find_program_by_name(obj, "on_sys_enter_recvmsg");
    
    if (prog_sendto) {
        link_sendto = bpf_program__attach_tracepoint(prog_sendto, "syscalls", "sys_enter_sendto");
        if (link_sendto) printf("Attached to syscalls:sys_enter_sendto\n");
    }
    
    if (prog_recvfrom) {
        link_recvfrom = bpf_program__attach_tracepoint(prog_recvfrom, "syscalls", "sys_enter_recvfrom");
        if (link_recvfrom) printf("Attached to syscalls:sys_enter_recvfrom\n");
    }
    
    if (prog_sendmsg) {
        link_sendmsg = bpf_program__attach_tracepoint(prog_sendmsg, "syscalls", "sys_enter_sendmsg");
        if (link_sendmsg) printf("Attached to syscalls:sys_enter_sendmsg\n");
    }
    
    if (prog_recvmsg) {
        link_recvmsg = bpf_program__attach_tracepoint(prog_recvmsg, "syscalls", "sys_enter_recvmsg");
        if (link_recvmsg) printf("Attached to syscalls:sys_enter_recvmsg\n");
    }
    
    if (!link_sendto && !link_recvfrom && !link_sendmsg && !link_recvmsg) {
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
    
    int traffic_fd = get_map_fd_by_name(obj, "traffic_map");
    int protocol_fd = get_map_fd_by_name(obj, "protocol_totals");
    
    if (traffic_fd < 0 || protocol_fd < 0) {
        endwin();
        if (link_sendto) bpf_link__destroy(link_sendto);
        if (link_recvfrom) bpf_link__destroy(link_recvfrom);
        if (link_sendmsg) bpf_link__destroy(link_sendmsg);
        if (link_recvmsg) bpf_link__destroy(link_recvmsg);
        bpf_object__close(obj);
        return 1;
    }
    
    struct traffic_entry *state = NULL;
    struct timespec ts_prev = {0}, ts_now = {0};
    clock_gettime(CLOCK_MONOTONIC, &ts_prev);
    int scroll = 0;
    const double update_interval_ns = 1e9; // 1s
    const double alpha = 0.3; // smoothing factor for EMA
    struct traffic_entry **view_cached = NULL;
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
            
            struct traffic_key key = {}, next_key;
            int map_has_data = 0;
            if (bpf_map_get_next_key(traffic_fd, NULL, &key) == 0) {
                map_has_data = 1;
                do {
                    struct traffic_stats stats;
                    if (bpf_map_lookup_elem(traffic_fd, &key, &stats) == 0) {
                        struct traffic_entry *e = find_or_add_traffic(&state, &key);
                        if (!e) continue;
                        
                        __u64 d_sent = 0, d_recv = 0;
                        if (e->prev_bytes_sent > 0 || e->prev_bytes_recv > 0) {
                            if (stats.bytes_sent >= e->prev_bytes_sent) d_sent = stats.bytes_sent - e->prev_bytes_sent;
                            if (stats.bytes_recv >= e->prev_bytes_recv) d_recv = stats.bytes_recv - e->prev_bytes_recv;
                        }
                        
                        double elapsed_sec = interval_ns / 1e9;
                        if (elapsed_sec > 0) {
                            double inst_bandwidth = (double)(d_sent + d_recv) / elapsed_sec;
                            
                            if (e->smoothed_bandwidth == 0) {
                                e->smoothed_bandwidth = inst_bandwidth;
                            } else {
                                e->smoothed_bandwidth = alpha * inst_bandwidth + (1.0 - alpha) * e->smoothed_bandwidth;
                            }
                            
                            e->bandwidth_sent = (double)d_sent / elapsed_sec;
                            e->bandwidth_recv = (double)d_recv / elapsed_sec;
                            e->bandwidth_total = e->bandwidth_sent + e->bandwidth_recv;
                        }
                        
                        e->bytes_sent = stats.bytes_sent;
                        e->bytes_recv = stats.bytes_recv;
                        e->packets_sent = stats.packets_sent;
                        e->packets_recv = stats.packets_recv;
                        e->prev_bytes_sent = stats.bytes_sent;
                        e->prev_bytes_recv = stats.bytes_recv;
                        e->last_update_ns = stats.last_update_ns;
                        
                        if (e->name[0] == '\0' || e->name[0] == '-') {
                            if (key.pid > 0) {
                                get_comm_by_pid(key.pid, e->name, sizeof(e->name));
                            }
                        }
                    }
                } while (bpf_map_get_next_key(traffic_fd, &key, &next_key) == 0 && (key = next_key, 1));
            }
            
            int count = 0;
            for (struct traffic_entry *c = state; c; c = c->next) {
                if ((c->bytes_sent > 0 || c->bytes_recv > 0 || c->bandwidth_total > 0) &&
                    !is_kernel_thread(c->key.pid, c->name)) {
                    count++;
                }
            }
            struct traffic_entry **arr = count ? malloc(sizeof(*arr) * count) : NULL;
            struct traffic_entry **view = NULL;
            int view_count = 0;
            if (arr) {
                int i = 0;
                for (struct traffic_entry *c = state; c; c = c->next) {
                    // Include entries with any traffic, excluding kernel threads
                    if ((c->bytes_sent > 0 || c->bytes_recv > 0 || c->bandwidth_total > 0) &&
                        !is_kernel_thread(c->key.pid, c->name)) {
                        arr[i++] = c;
                    }
                }
                qsort(arr, count, sizeof(*arr), compare_traffic_bandwidth);
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
        mvprintw(0, 0, "Network Monitor - q: quit  ↑/↓: scroll");
        mvprintw(1, 0, "%-7s %-20s %-6s %12s %12s %12s",
                 "PID", "PROCESS", "PROTO", "SENT", "RECV", "BANDWIDTH");
        
        mvprintw(2, 0, "Protocol Stats: ");
        __u8 proto_key = 0, next_proto_key;
        int proto_col = 18;
        if (bpf_map_get_next_key(protocol_fd, NULL, &proto_key) == 0) {
            do {
                __u64 total_bytes = 0;
                if (bpf_map_lookup_elem(protocol_fd, &proto_key, &total_bytes) == 0) {
                    char bytes_str[32];
                    format_bytes(total_bytes, bytes_str, sizeof(bytes_str));
                    mvprintw(2, proto_col, "%s:%s  ", get_protocol_name(proto_key), bytes_str);
                    proto_col += strlen(get_protocol_name(proto_key)) + strlen(bytes_str) + 3;
                }
            } while (bpf_map_get_next_key(protocol_fd, &proto_key, &next_proto_key) == 0 &&
                     (proto_key = next_proto_key, 1));
        }
        
        int max_rows = LINES - 4;
        if (max_rows < 0) max_rows = 0;
        if (view_cached && view_count_cached > 0) {
            int start = scroll;
            int end = start + max_rows;
            if (end > view_count_cached) end = view_count_cached;
            int row = 3;
            for (int i = start; i < end; i++, row++) {
                struct traffic_entry *e = view_cached[i];
                
                if (is_kernel_thread(e->key.pid, e->name)) {
                    continue;  // Skip displaying kernel threads
                }
                
                char sent_str[32], recv_str[32], bw_str[32];
                format_bytes(e->bytes_sent, sent_str, sizeof(sent_str));
                format_bytes(e->bytes_recv, recv_str, sizeof(recv_str));
                format_bytes((__u64)e->bandwidth_total, bw_str, sizeof(bw_str));
                
                if (e->bandwidth_total > 10 * 1024 * 1024) {
                    attron(A_REVERSE);
                }
                
                char bw_display[32];
                if (e->bandwidth_total > 0) {
                    snprintf(bw_display, sizeof(bw_display), "%s/s", bw_str);
                } else {
                    __u64 total = e->bytes_sent + e->bytes_recv;
                    format_bytes(total, bw_display, sizeof(bw_display));
                }
                
                mvprintw(row, 0, "%-7u %-20.20s %-6s %12s %12s %12s",
                         e->key.pid, e->name,
                         get_protocol_name(e->key.protocol),
                         sent_str, recv_str, bw_display);
                
                if (e->bandwidth_total > 10 * 1024 * 1024) {
                    attroff(A_REVERSE);
                }
            }
            
            int anomaly_count = 0;
            for (int i = 0; i < view_count_cached; i++) {
                if (view_cached[i]->bandwidth_total > 10 * 1024 * 1024) {
                    anomaly_count++;
                }
            }
            if (anomaly_count > 0) {
                mvprintw(LINES - 1, 0, "⚠️  ALERT: %d high-bandwidth connections detected (>10 MB/s)", anomaly_count);
            } else {
                mvprintw(LINES - 1, 0, "✓ No anomalies detected");
            }
        } else {
            mvprintw(3, 0, "No network traffic data yet... (generate some traffic: ping, curl, etc.)");
        }
        refresh();
        
        struct timespec tiny = { .tv_sec = 0, .tv_nsec = 10000000 };
        nanosleep(&tiny, NULL);
    }
    
    if (view_cached) free(view_cached);
    free_traffic_list(state);
    endwin();
    if (link_sendto) bpf_link__destroy(link_sendto);
    if (link_recvfrom) bpf_link__destroy(link_recvfrom);
    if (link_sendmsg) bpf_link__destroy(link_sendmsg);
    if (link_recvmsg) bpf_link__destroy(link_recvmsg);
    bpf_object__close(obj);
    
    return 0;
}
