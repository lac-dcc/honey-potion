CC = clang
BPFTOOL = ../tools/bpftool
TARGET = prog

LIBS = -lncurses -lbpf -lelf -lz

all: $(TARGET)

# eBPF program compilation
prog.bpf.o: prog.bpf.c vmlinux.h
	clang -S -target bpf -D__BPF_TRACING__ -D__TARGET_ARCH_x86 -O2 -emit-llvm -c -g prog.bpf.c -o prog.bpf.ll
	llc -march=bpf -filetype=obj -o prog.bpf.o prog.bpf.ll

# Main program with eBPF integration
$(TARGET): prog.c prog.bpf.o
	$(CC) -o $(TARGET) prog.c $(LIBS)

clean:
	rm -f $(TARGET) prog.bpf.o prog.bpf.ll

.PHONY: all clean
