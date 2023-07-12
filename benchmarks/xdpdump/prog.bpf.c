// SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
// Copyright (c) 2018 Netronome Systems, Inc.

#include <stdbool.h>
#include <stddef.h>
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <linux/ipv6.h>
#include <linux/string.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <bpf/bpf_endian.h>
#include <bpf/bpf_helpers.h>

#include "xdpdump_common.h"

struct {
	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
	__uint(max_entries, MAX_CPU);
	__type(key, __u32);
	__type(value, __u32);
} perf_map SEC(".maps");

/**
 * @brief Get the UDP data and store it in the pkt pointer
 * @param data Pointer to start of the packet
 * @param off Size of ipv4/ipv6 header
 * @param data_end Pointer to end of the packet
 * @param pkt Pointer to the packet metadata struct
 * @return boolean indicating success in the conversion
 */
static __always_inline bool parse_udp(void *data, __u64 off, void *data_end, struct pkt_meta *pkt) {
	struct udphdr *udp;

	udp = data + off;
	if (data + off + sizeof(struct udphdr) > data_end)
		return false;

	pkt->port16[0] = udp->source;
	pkt->port16[1] = udp->dest;
	return true;
}

/**
 * @brief Get the TCP data and store it in the pkt pointer
 * @param data Pointer to start of the packet
 * @param off Size of ipv4/ipv6 header
 * @param data_end Pointer to end of the packet
 * @param pkt Pointer to the packet metadata struct
 * @return boolean indicating success in the conversion
 */
static __always_inline bool parse_tcp(void *data, __u64 off, void *data_end, struct pkt_meta *pkt) {
	struct tcphdr *tcp;

	tcp = data + off;
	if (data + off + sizeof(struct tcphdr) > data_end)
		return false;

	pkt->port16[0] = tcp->source;
	pkt->port16[1] = tcp->dest;
	pkt->seq = tcp->seq;

	return true;
}

/**
 * @brief Get the IPV4 data and store it in the pkt pointer
 * @param data Pointer to start of the packet
 * @param off Size of ethernet header
 * @param data_end Pointer to end of the packet
 * @param pkt Pointer to the packet metadata struct
 * @return boolean indicating success in the conversion
 */
static __always_inline bool parse_ip4(void *data, __u64 off, void *data_end, struct pkt_meta *pkt) {
	struct iphdr *iph;

	iph = data + off;
	if (data + off + sizeof(struct iphdr) > data_end)
		return false;

	if (iph->ihl != 5)
		return false;

	pkt->src = iph->saddr;
	pkt->dst = iph->daddr;
	pkt->l4_proto = iph->protocol;

	return true;
}

/**
 * @brief Get the UDP data and store it in the pkt pointer
 * @param data Pointer to start of the packet
 * @param off Size of ethernet header
 * @param data_end Pointer to end of the packet
 * @param pkt Pointer to the packet metadata struct
 * @return boolean indicating success in the conversion
 */
static __always_inline bool parse_ip6(void *data, __u64 off, void *data_end, struct pkt_meta *pkt) {
	struct ipv6hdr *ip6h;

	ip6h = data + off;
	if (data + off + sizeof(struct ipv6hdr) > data_end)
		return false;

	memcpy(pkt->srcv6, ip6h->saddr.s6_addr32, 16);
	memcpy(pkt->dstv6, ip6h->daddr.s6_addr32, 16);
	pkt->l4_proto = ip6h->nexthdr;

	return true;
}

/**
 * @brief Get metadata about the packets and send to perf
 */
SEC("xdp")
int process_packet(struct xdp_md *ctx)
{
	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct ethhdr *eth = data;
	struct pkt_meta pkt = {};
	__u32 off;

	/* parse packet for IP Addresses and Ports */
	off = sizeof(struct ethhdr);
	if (data + off > data_end)
		return XDP_PASS;

	pkt.l3_proto = bpf_htons(eth->h_proto);

	// Get IPv4 or IPv6 header
	if (pkt.l3_proto == ETH_P_IP)
	{
		if (!parse_ip4(data, off, data_end, &pkt))
			return XDP_PASS;
		off += sizeof(struct iphdr);
	}
	else if (pkt.l3_proto == ETH_P_IPV6)
	{
		if (!parse_ip6(data, off, data_end, &pkt))
			return XDP_PASS;
		off += sizeof(struct ipv6hdr);
	}

	if (data + off > data_end)
		return XDP_PASS;

	// Obtain port numbers for UDP and TCP traffic
	if (pkt.l4_proto == IPPROTO_TCP)
	{
		if (!parse_tcp(data, off, data_end, &pkt))
			return XDP_PASS;
		off += sizeof(struct tcphdr);
	}
	else if (pkt.l4_proto == IPPROTO_UDP)
	{
		if (!parse_udp(data, off, data_end, &pkt))
			return XDP_PASS;
		off += sizeof(struct udphdr);
	}
	else
	{
		pkt.port16[0] = 0;
		pkt.port16[1] = 0;
	}

	pkt.pkt_len = data_end - data;
	pkt.data_len = data_end - data - off;

	bpf_perf_event_output(ctx, &perf_map,
						  (__u64)pkt.pkt_len << 32 | BPF_F_CURRENT_CPU,
						  &pkt, sizeof(pkt));
	return XDP_PASS;
}

char _license[] SEC("license") = "Dual BSD/GPL";