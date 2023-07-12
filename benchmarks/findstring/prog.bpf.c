#include <arpa/inet.h>
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/if_ether.h>
#include <linux/udp.h>
#include <linux/ip.h>
#include <linux/in.h>
#include "prog.h"

struct
{
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 1);
    __type(key, char);
    __type(value, int);
} config SEC(".maps");

struct
{
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries, MAPSTRINGSSIZE);
    __type(key, int);
    __type(value, struct data);
} strings SEC(".maps");

struct
{
    __uint(type, BPF_MAP_TYPE_ARRAY);
    __uint(max_entries, MAXSTATES);
    __type(key, int);
    __type(value, struct goto_result[MAXC]);
} goto_func SEC(".maps");

struct
{
    __uint(type, BPF_MAP_TYPE_PROG_ARRAY);
    __uint(max_entries, 1);
    __type(key, int);
    __type(value, int);
} progs SEC(".maps");

struct
{
    __uint(type, BPF_MAP_TYPE_HASH);
    __uint(max_entries, 1000);
    __type(key, unsigned long);
    __type(value, struct state);
} state_map SEC(".maps");


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
    unsigned char *payload;

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

    payload = (void *)udp + sizeof(*udp);
    unsigned int payload_size = ntohs(udp->len) - sizeof(*udp);
    if ((void *)payload + payload_size > data_end)
        return XDP_PASS;

    // Get the port
    char key = 'p';
    int *value = (int *)bpf_map_lookup_elem(&config, &key);
    if (value == NULL || udp->dest != ntohs(*value))
        return XDP_PASS;

    struct state newstate;
    struct state* s = &newstate;
    
    unsigned long ctx_address = (unsigned long)ctx; 
    struct state *state_from_map = (struct state *)bpf_map_lookup_elem(&state_map, &ctx_address);
    if(state_from_map) {
        s = state_from_map;
        bpf_printk("Continue to analyze packet from index %d to %d.", s->payload_index, s->payload_index+1999);
    } else {
        bpf_printk("Packet received. payload_size = %u. Let's process.", payload_size);

        s->ac_state = 1;
        s->payload_index = 0;
        s->matches = 0;

        bpf_map_update_elem(&state_map, &ctx_address, s, BPF_ANY);
    }

    int reached_end = 0;
    unsigned i;
    for (i = 0; i < 2000; i++)
    {
        unsigned payload_access = s->payload_index + i;
        
        if (payload_access > 65492 || (void *)payload + payload_access + 1 > data_end)
        {
            reached_end = 1;
            break;
        }

        struct goto_result *go_from_state = (struct goto_result*)bpf_map_lookup_elem(&goto_func, &s->ac_state);
        if(!go_from_state) {
            break;
        }

        unsigned ch = payload[payload_access] - 'a';

        if(ch >= MAXC) {
            s->ac_state = 1;
            continue;
        }
        
        s->ac_state = go_from_state[ch].next_state;

        if (go_from_state[ch].match == 0) {
            continue;
        }

        // Match found
        s->matches |= go_from_state[ch].match;
    }

    if(reached_end) {
        for (int j = 0; j < MAPSTRINGSSIZE; ++j)
        {
            if (s->matches & (1 << j))
            {
                int key = j;
                struct data *word = (struct data*)bpf_map_lookup_elem(&strings, &key);
                if(word) {
                    word->number++;
                    char fmt[] = "Found the word '%s'. It's the %dth packet with this string.";
                    bpf_trace_printk(fmt, sizeof fmt, word->text, word->number);
                }
            }
        }

        char clean_or_not[14];
        int pass_or_not;
        if(s->matches) {
            pass_or_not = XDP_DROP;
            __builtin_memcpy(clean_or_not, "Dropping...\n", (14));
        } else {
            pass_or_not = XDP_PASS;
            __builtin_memcpy(clean_or_not, "Passing...\n", (12));
        }

        bpf_printk("Packet fully analyzed (%d bytes). %s", s->payload_index + i - 1, clean_or_not);
        unsigned long key = (unsigned long)ctx;
        bpf_map_delete_elem(&state_map, &key);

        return pass_or_not;
    } else {
        s->payload_index += i;
        bpf_tail_call(ctx, &progs, 0);
        return XDP_PASS;
    }
}

char _license[] SEC("license") = "Dual BSD/GPL";