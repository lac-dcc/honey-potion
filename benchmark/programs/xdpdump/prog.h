#include <perf-sys.h>

#define MAX_CPU 128

struct pkt_meta
{
	union
	{
		__be32 src;
		__be32 srcv6[4];
	};
	union
	{
		__be32 dst;
		__be32 dstv6[4];
	};
	__u16 port16[2];
	__u16 l3_proto;
	__u16 l4_proto;
	__u16 data_len;
	__u16 pkt_len;
	__u32 seq;
};

struct perf_event_sample
{
	struct perf_event_header header;
	__u64 timestamp;
	__u32 size;
	struct pkt_meta meta;
	__u8 pkt_data[64];
};