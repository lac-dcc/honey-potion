#include <arpa/inet.h>
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/udp.h>
#include <linux/ip.h>
#include <linux/in.h>
#include "prog.h"

struct {
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 1);
    __type(key, char);
    __type(value, int);
} config SEC(".maps");

struct {
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries, MAPSTRINGSSIZE);
    __type(key, int);
    __type(value, struct data);
} strings SEC(".maps");

/**
 * @brief Check if a character is a special character
 * @param c Character
 * @return int (1 - TRUE and ) - FALSE)
 */
int __always_inline checkSpecialChar(char c) {
    switch (c) {
        case '\0':
            return TRUE;
        case '\n':
            return TRUE;
        case '\t':
            return TRUE;
        case '\v':
            return TRUE;
        case '\f':
            return TRUE;
        case '\a':
            return TRUE;
        case '\b':
            return TRUE;
        case '\r':
            return TRUE;
        default:
            return FALSE;
    }
}

/**
 * @brief 
 * Count the number of non-null elements in a char array
 * @param text Text
 * @return int 
 */
int __always_inline charSize(char text[SIZETEXT]) {
    unsigned int i;
    for (i = 0; i < SIZETEXT; i++)
        if (text[i] == '\0')
            return i;

    return 0;
}

/**
 * @brief 
 * 
 * @param payload_size Size of the payload
 * @param udp UDP header of the packet
 * @param data_end Pointer to the end of the packet
 * @return int 
 */
int __always_inline patternMatch(unsigned int payload_size, struct udphdr *udp, void *data_end) {
    int match;
    unsigned int i;
    unsigned int j;
    for (i = 0; i < MAPSTRINGSSIZE; i++) {
        unsigned int key = i;

        struct data *ptr = (struct data *)bpf_map_lookup_elem(&strings, &key);
        if (ptr && ptr->text[0]) {        
            unsigned char *payload;

            if (payload_size < charSize(ptr->text)) 
                continue;

            // Point to start of payload.
            payload = (unsigned char *)udp + sizeof(*udp);
            if ((void *)payload + payload_size > data_end)
                continue;

            // Compare each byte, exit if a difference is found.
            unsigned int k;
            for (k = 0; k < payload_size; k++) {
                match = TRUE;
                int size = charSize(ptr->text);
                for (j = 0; j < size; j++) {
                    unsigned int pay_access = k+j;
                    if (payload_size <= pay_access)
                        break;

                    int payloadIsSpecial = checkSpecialChar(payload[k]);
                    char fmt[] = "hmm %d\n";
                    bpf_trace_printk(fmt, sizeof(fmt), payloadIsSpecial);
                    // int matchIsSpecial = checkSpecialChar(ptr->text[j]);
                    // if ((j == payload_size - 1) && payloadIsSpecial == TRUE && matchIsSpecial == TRUE)
                    //     continue;
                    // else if (payload[pay_access] != ptr->text[j]) {
                    //     match = FALSE;
                    //     continue;
                    // }
                }

                // Same payload, drop.
                if (match == TRUE)
                    return XDP_DROP;
                }
        }
    }

    return XDP_PASS;
}

/**
 * @brief Drop UDP packets of a specific port that have a pattern 
 * match with any string of a list of string
 */
SEC("matchPayloadUDP")
int matchPayload(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth;
    struct udphdr *udp;
    struct iphdr *ip;

    // Ethernet header
    eth = data;
    if ((void *)eth + sizeof(*eth) > data_end)
        return XDP_PASS;

    // IP header
    ip = data + sizeof(*eth);
    if ((void *)ip + sizeof(*ip) > data_end)
        return XDP_PASS;

    // IP protocol
    if (ip->protocol != IPPROTO_UDP)
        return XDP_PASS;

    // UDP Data
    udp = (void *)ip + sizeof(*ip);
    if ((void *)udp + sizeof(*udp) > data_end)
        return XDP_PASS;

    // Get the port
    char key = 'p';
    int *value = (int *)bpf_map_lookup_elem(&config, &key);
    if (value == NULL || udp->dest != ntohs(*value))
        return XDP_PASS;

    unsigned int payload_size = ntohs(udp->len) - sizeof(*udp);
    return patternMatch(payload_size, udp, data_end);
}

char _license[] SEC("license") = "Dual BSD/GPL";