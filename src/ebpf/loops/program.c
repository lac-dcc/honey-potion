// #include <stdio.h> ERROR: Usar bibliotecas standards pode gerar conflito

// ERROR: BPF program is too large. Processed 1000001 insn
// processed 1000001 insns (limit 1000000) max_states_per_insn 4
// total_states 10991 peak_states 10991 mark_read 1
int loop1(void *ctx) {
    // #pragma unroll -> ERROR: Program loop too large (20994 insns), at most 4096 insns
    for(long int i = 0; i < 76923; i++){
        bpf_trace_printk("Hello, World, MAX_I: 76923, CURRENT_I: %ld\n", i);
    }


    return 0;
}


int loop2(void *ctx) {
    u32 pid = bpf_get_current_pid_tgid();
    while(pid < 30){ // Resolve o valor
        pid++;
    }
    
    bpf_trace_printk("PID (Expected 30): %ld\n", pid);

    return 0;
}

int loop3(void *ctx) {
    u32 pid = bpf_get_current_pid_tgid();
    u32 time = 4294967294U;//4294967293U;
    while(time < pid){ // Comportamento estranho, funciona com o 4294967294, valor máximo de u32 4294967295
        bpf_trace_printk("Time: %u, PID: %u\n", time, pid);
        time++;
    }    

    return 0;
}

int loop4(void *ctx) {
    u32 pid = bpf_get_current_pid_tgid();
    while(pid % 2 != 0){ // ERROR: Infinite loop detected at insn 2
        pid--;
    }
    
    bpf_trace_printk("MOD PID: %ld\n", pid);

    return 0;
}

// Chamadas de função, ERRO:  The 'unknown opcode' can happen if you 
// reference a global or static variable, or data in read-only section.
// For example, 'char *p = "hello"' will result in p referencing a read-only section, 
// and 'char p[] = "hello"' will have "hello" stored on the stack
static void call2();
static void call1(int i) {
    if(i == 0)
        return;
    bpf_trace_printk("Recursao\n");
    call1(i - 1);
}
static void call2() {
    call1(10);
    bpf_trace_printk("Recursao\n");
}
int loop(void *ctx) {

    call1(1);

    return 0;
}