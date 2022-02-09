#include <linux/bpf.h>
#include <bpf/bpf_helpers.h>
#include <linux/version.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>

struct bpf_map_def SEC("maps") map  = {
  .type = BPF_MAP_TYPE_HASH,
  .key_size = sizeof(long),
  .value_size = sizeof(char),
  .max_entries = 64,
};

struct syscalls_enter_kill_args {
  /**
   * This is the tracepoint arguments of the kill functions.
   * Defined at: /sys/kernel/debug/tracing/events/syscalls/sys_enter_kill/format
   */
  long long pad;

  long syscall_nr;
  long pid;
  long sig;
};

SEC("tracepoint/syscalls/sys_enter_kill")
int sysEnterKill(struct syscalls_enter_kill_args *ctx) {
  if (ctx->sig != SIGKILL)
    return 0;

  long key = labs(ctx->pid);
  int val = 1;

  bpf_map_update_elem(&map, &key, &val, BPF_NOEXIST);

  return 0;
}

// As this program is integrating with tracepoints, it must be GPL.
char _license[] SEC("license") = "GPL";
__u32 _version SEC("version") = LINUX_VERSION_CODE;