#!/usr/bin/python
# @lint-avoid-python-3-compatibility-imports
#
# filelife    Trace the lifespan of short-lived files.
#             For Linux, uses BCC, eBPF. Embedded C.
#
# This traces the creation and deletion of files, providing information
# on who deleted the file, the file age, and the file name. The intent is to
# provide information on short-lived files, for debugging or performance
# analysis.
#
# USAGE: filelife [-h] [-p PID]
#
# Copyright 2016 Netflix, Inc.
# Licensed under the Apache License, Version 2.0 (the "License")
#
# 08-Feb-2015   Brendan Gregg   Created this.
# 17-Feb-2016   Allan McAleavy updated for BPF_PERF_OUTPUT
from __future__ import print_function
from bcc import BPF
import argparse
from time import strftime

# initialize BPF
b = BPF(src_file='program.c')
b.attach_kprobe(event="vfs_create", fn_name="trace_create")
b.attach_kprobe(event="security_inode_create", fn_name="trace_create")
b.attach_kprobe(event="vfs_unlink", fn_name="trace_unlink")

# header
print("%-8s %-6s %-16s %-7s %s" % ("TIME", "PID", "COMM", "AGE(s)", "FILE"))

# process event
def print_event(cpu, data, size):
    event = b["events"].event(data)
    print("%-8s %-6d %-16s %-7.2f %s" % (strftime("%H:%M:%S"), event.pid,
        event.comm.decode('utf-8', 'replace'), float(event.delta) / 1000,
        event.fname.decode('utf-8', 'replace')))

b["events"].open_perf_buffer(print_event)
while 1:
    try:
        b.perf_buffer_poll()
    except KeyboardInterrupt:
        exit()