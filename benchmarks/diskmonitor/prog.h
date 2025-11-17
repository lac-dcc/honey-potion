#ifndef PROG_H
#define PROG_H

#include <linux/types.h>

#define OP_READ 0
#define OP_WRITE 1

struct io_key {
    __u32 pid;
    __u8 operation;
};

struct io_stats {
    __u64 bytes_read;
    __u64 bytes_written;
    __u64 ops_read;
    __u64 ops_write;
    __u64 total_latency_ns;
    __u64 max_latency_ns;
    __u64 min_latency_ns;
    __u64 last_update_ns;
};

const char* get_operation_name(__u8 operation);

#endif // PROG_H

