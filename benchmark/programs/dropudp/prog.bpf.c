#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/ipv6.h>
#include <netinet/ip.h>
#include <linux/udp.h>

struct {
    __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
    __uint(max_entries, 1);
    __type(value, long);
    __type(key, __u32);
} map SEC(".maps");

/**
 * @brief Edit the destination port of the packet
 * @param data Packet data delimiter. The bytes of the packet being processed 
 * are delimited by the `data` and `data_end`
 * @param nh_off Offset of the IP header in the packet
 * @param data_end Packet data delimiter. The bytes of the packet being processed 
 * are delimited by the `data` and `data_end`
 * @param port New port of the packet
 */
static __always_inline void editDestPortUDP(void *data, __u64 nh_off, void *data_end, int port) {
    struct udphdr *udph = data + nh_off;

    if (data + nh_off + sizeof(struct udphdr) <= data_end)
        udph->dest = ntohs(port);
}

/**
 * @brief Get the destinaton port of the packet
 * @param data Packet data delimiter. The bytes of the packet being processed 
 * are delimited by the `data` and `data_end`
 * @param nh_off Offset of the IP header in the packet
 * @param data_end Packet data delimiter. The bytes of the packet being processed 
 * are delimited by the `data` and `data_end`
 * @return Destination port 
 */
static __always_inline int getDestPortUDP(void *data, __u64 nh_off, void *data_end) {
    struct udphdr *udph = data + nh_off;

    if (data + nh_off + sizeof(struct udphdr) > data_end)
        return 0;

    return udph->dest;
}

/**
 * @brief Get the packet protocol
 * @param data Packet data delimiter. The bytes of the packet being processed 
 * are delimited by the `data` and `data_end`
 * @param nh_off Offset of the IP header in the packet
 * @param data_end Packet data delimiter. The bytes of the packet being processed 
 * are delimited by the `data` and `data_end`
 * @return Packet protocol 
 */
static __always_inline int getProtocolIPv4(void *data, __u64 *nh_off, void *data_end) {
    struct iphdr *iph = data + *nh_off;

    // Again verifier check our boundary checks
    if (data + *nh_off + sizeof(struct iphdr) > data_end)
        return 0;

    *nh_off += sizeof(struct iphdr);
    return iph->protocol;
}

/**
 * @brief Get the packet protocol
 * @param data Packet data delimiter. The bytes of the packet being processed 
 * are delimited by the `data` and `data_end`
 * @param nh_off Offset of the IP header in the packet
 * @param data_end Packet data delimiter. The bytes of the packet being processed 
 * are delimited by the `data` and `data_end`
 * @return Packet protocol 
 */
static __always_inline int getProtocolIPv6(void *data, __u64 *nh_off, void *data_end) {
    struct ipv6hdr *ip6h = data + *nh_off;

    // Again verifier check our boundary checks
    if (data + *nh_off + sizeof(struct ipv6hdr) > data_end)
        return 0;

    *nh_off += sizeof(struct ipv6hdr);
    return ip6h->nexthdr;
}

/**
 * @brief Drop UDP packets whose destination is port 3000 and redirect packets
 * from port 3001 to port 3000
 */
SEC("xdp_drop_UDP")
int dropXDP(struct xdp_md *ctx) {
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;

    __u64 nh_off = sizeof(*eth);
    __u32 ipproto = 0;

    // Verifier use this boundry check
    if (data + nh_off > data_end)
        return XDP_ABORTED;

    if (eth->h_proto == htons(ETH_P_IP))
        ipproto = getProtocolIPv4(data, &nh_off, data_end);
    else if (eth->h_proto == htons(ETH_P_IPV6))
        ipproto = getProtocolIPv6(data, &nh_off, data_end);
    else
        return XDP_PASS;

    if (ipproto == IPPROTO_UDP) {
        uint16_t dest_port = ntohs(getDestPortUDP(data, nh_off, data_end));

        if (dest_port == 3000) {            
            uint32_t index = (uint32_t)dest_port;
            long *value = bpf_map_lookup_elem(&map, &index);
            if (value)
                *value += 1;    

            return XDP_DROP;
        }
        else if (dest_port == 3001) {
            editDestPortUDP(data, nh_off, data_end, 3000);
        }
    }

    return XDP_PASS;
}

char _license[] SEC("license") = "Dual BSD/GPL";