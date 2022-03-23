-include ../Makefile.config

all: clean prog.bpf.o skel $(TARGET)

skel: prog.bpf.o
	${BPFTOOL} gen skeleton prog.bpf.o > prog.skel.h