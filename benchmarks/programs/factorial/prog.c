// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
/* Copyright (c) 2020 Facebook */
#include <stdio.h>
#include <unistd.h>
#include <sys/resource.h>
#include <bpf/libbpf.h>
#include "prog.skel.h"
#include "fact.h"

// input value of factorial
#define INPUT_VALUE 10

static int libbpf_print_fn(enum libbpf_print_level level, const char *format, va_list args)
{
    return vfprintf(stderr, format, args);
}

int last_ret_val = 1;
int current_factor = 0;
int continuing = 1;

int handle_executed = 0;

/* Callback that handles the ring buffer responses */
static int handle_event(void *ctx, void *data, size_t data_sz)
{
	const struct event *e = data;

    /* Overwriting global variables to save the
    state of the recursion */
    last_ret_val = e->result;
    continuing = e->continuing;
    current_factor = e->next_factor;

    /*  Informs to the while-loop that it can be stoped and the current
    eBPF program killed. */
    handle_executed = 1;

    return 0;
}

int main(int argc, char **argv)
{
    struct ring_buffer *rb = NULL;
    struct fact_bpf *skel;
    int err;

    libbpf_set_strict_mode(LIBBPF_STRICT_ALL);
    /* Set up libbpf errors and debug info callback */
    libbpf_set_print(libbpf_print_fn);

    current_factor = INPUT_VALUE;
    while(continuing)
    {
        /* Open BPF application */
        skel = fact_bpf__open();
        if (!skel)
        {
            fprintf(stderr, "Failed to open BPF skeleton\n");
            return 1;
        }
        skel->bss->last_result = last_ret_val;
        skel->bss->factor = current_factor;

        /* ensure BPF program only handles write() syscalls from our process */
        skel->bss->my_pid = getpid();

        /* Load & verify BPF programs */
        err = fact_bpf__load(skel);
        if (err)
        {
            fprintf(stderr, "Failed to load and verify BPF skeleton\n");
            goto cleanup;
        }

        /* Attach tracepoint handler */
        err = fact_bpf__attach(skel);
        if (err)
        {
            fprintf(stderr, "Failed to attach BPF skeleton\n");
            goto cleanup;
        }

        /* Set up ring buffer polling */
        rb = ring_buffer__new(bpf_map__fd(skel->maps.rb), handle_event, NULL, NULL);
        if (!rb)
        {
            err = -1;
            fprintf(stderr, "Failed to create ring buffer\n");
            goto cleanup;
        }

        /* Waiting until get repsponded by the ring buffer */
        handle_executed = 0;
        while(!handle_executed) {
            err = ring_buffer__poll(rb, 100 /* timeout, ms */);

            /* This print triggers the kernel event handedl by
            the eBPF program: "tp/syscalls/sys_enter_write" */
            fprintf(stderr, "\n");
        }

        /* Freeing the allocated resources */
        ring_buffer__free(rb);
        fact_bpf__destroy(skel);
    }
    printf("====== RESULT: %d\n", last_ret_val);


cleanup:
    return -err;
}
