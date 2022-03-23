#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/icmp.h>
#include "prog.h"

struct {
  __uint(type, BPF_MAP_TYPE_HASH);
  __uint(max_entries, 256);
  __type(key, unsigned char[6]);
  __type(value, struct countentry);
} map SEC(".maps");

/**
 * @brief Count the number of received packets by mac address
 */
SEC("xdp_traffic_count")
int trafficCount(struct xdp_md *ctx)
{
    void *end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;
    void *src = eth->h_source;

    if (src == 0)
      return XDP_PASS;

    if (src + 7 >= end)
      return XDP_PASS;

    struct countentry newitem;
    struct countentry *item = (struct countentry *)bpf_map_lookup_elem(&map, src);

    // No entry was found
    if (item == 0) {
        item = &newitem;

        item->bytes = 0;
        item->packets = 0;
    }

    item->packets++;
    bpf_map_update_elem(&map, src, item, BPF_ANY);

    return XDP_PASS;
}

char _license[] SEC("license") = "Dual BSD/GPL";