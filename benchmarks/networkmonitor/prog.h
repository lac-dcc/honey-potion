#ifndef PROG_H
#define PROG_H

#include <linux/types.h>

// Protocol types
#define PROTO_TCP 6
#define PROTO_UDP 17
#define PROTO_ICMP 1
#define PROTO_OTHER 0

// Key structure for traffic classification
struct traffic_key {
    __u32 pid;
    __u8 protocol;      // TCP, UDP, ICMP, etc.
    __u16 port;         // Destination port (for application classification)
    __u32 ip;           // Destination IP
};

// Traffic statistics
struct traffic_stats {
    __u64 bytes_sent;
    __u64 bytes_recv;
    __u64 packets_sent;
    __u64 packets_recv;
    __u64 last_update_ns;
};

// Protocol name mapping (helper functions)
const char* get_protocol_name(__u8 protocol);
const char* get_port_name(__u16 port);

#endif // PROG_H

