#ifdef asm_inline
#undef asm_inline
#define asm_inline asm
#endif

#include <uapi/linux/ptrace.h>
#include <linux/fs.h>
#include <linux/sched.h>

struct data_t {
    u32 pid;
    u64 delta;
    char comm[TASK_COMM_LEN];
    char fname[DNAME_INLINE_LEN];
};
BPF_HASH(birth, struct dentry *);
BPF_PERF_OUTPUT(events);
// trace file creation time
int trace_create(struct pt_regs *ctx, struct inode *dir, struct dentry *dentry)
{
    u32 pid = bpf_get_current_pid_tgid() >> 32;
    u64 ts = bpf_ktime_get_ns();
    birth.update(&dentry, &ts);
    return 0;
};
// trace file deletion and output details
int trace_unlink(struct pt_regs *ctx, struct inode *dir, struct dentry *dentry)
{
    struct data_t data = {};
    u32 pid = bpf_get_current_pid_tgid() >> 32;
    u64 *tsp, delta;
    tsp = birth.lookup(&dentry);
    if (tsp == 0) {
        return 0;   // missed create
    }
    delta = (bpf_ktime_get_ns() - *tsp) / 1000000;
    birth.delete(&dentry);
    struct qstr d_name = dentry->d_name;
    if (d_name.len == 0)
        return 0;
    if (bpf_get_current_comm(&data.comm, sizeof(data.comm)) == 0) {
        data.pid = pid;
        data.delta = delta;
        bpf_probe_read(&data.fname, sizeof(data.fname), d_name.name);
    }
    events.perf_submit(ctx, &data, sizeof(data));
    return 0;
}