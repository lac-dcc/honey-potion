// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
/* Copyright (c) 2020 Facebook */
#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include "fact.h"

char LICENSE[] SEC("license") = "Dual BSD/GPL";

struct {
	__uint(type, BPF_MAP_TYPE_RINGBUF);
	__uint(max_entries, 256 * 1024);
} rb SEC(".maps");

int my_pid = 0;
int last_result = 0;
int factor = 0;

SEC("tp/syscalls/sys_enter_write")
int handle_tp(void *ctx)
{
	int pid = bpf_get_current_pid_tgid() >> 32;

	/* Ensures that this eBPF program
	is triggered by the printf call
	in our User-side program */
	if (pid != my_pid)
		return 0;

    /* reserve the eBPF ring buffer */
    struct event *e;
	e = bpf_ringbuf_reserve(&rb, sizeof(*e), 0);
	if (!e) {
		return 0;
    }

	/* Runs the factorial in tail-end format */
	if(factor <= 1) {
		e->result = last_result;

	} else {
		e->continuing = 1;
		e->result = last_result * factor;
		e->next_factor = factor - 1;
	}
    bpf_ringbuf_submit(e, BPF_RB_FORCE_WAKEUP);

	return 0;
}

// fact(last_result = 1, factor = x)e->continuing = 0;