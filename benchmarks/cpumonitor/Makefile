TARGET := prog

CC := clang
SRC_DIR := $(shell realpath .)
BPFTOOL := $(SRC_DIR)/../tools/bpftool

LIBS := -lbpf -lelf -lz

# Flag de arquitetura BPF alvo
BPF_ARCH := -D__TARGET_ARCH_x86

all: clean $(SRC_DIR)/$(TARGET)

.PHONY: clean

clean:
	@$(RM) $(SRC_DIR)/$(TARGET)
	@$(RM) $(SRC_DIR)/$(TARGET).bpf.o
	@$(RM) $(SRC_DIR)/$(TARGET).bpf.ll
	@$(RM) $(SRC_DIR)/$(TARGET).skel.h

# Binary Creation
$(SRC_DIR)/$(TARGET): %: $(SRC_DIR)/$(TARGET).c $(SRC_DIR)/$(TARGET).skel.h
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(SRC_DIR)/$(TARGET) $(SRC_DIR)/$(TARGET).c -Wl,-rpath='$(LIBBPF_BUILD)' $(LIBS)

# Skeleton Generation
$(SRC_DIR)/$(TARGET).skel.h: $(SRC_DIR)/$(TARGET).bpf.o
	$(BPFTOOL) gen skeleton $< > $@

# Object Files
$(SRC_DIR)/$(TARGET).bpf.o: $(SRC_DIR)/$(TARGET).bpf.c
	clang -S \
			-target bpf \
			-D__BPF_TRACING__ \
			$(BPF_ARCH) \
			$(CFLAGS) \
			-O2 -emit-llvm -c -g $(SRC_DIR)/$(TARGET).bpf.c -o $(SRC_DIR)/$(TARGET).bpf.ll
	llc -march=bpf -filetype=obj -o $(SRC_DIR)/$(TARGET).bpf.o $(SRC_DIR)/$(TARGET).bpf.ll

.PHONY: compress
compress:
	@rm -f compress/*.gz
	@mkdir -p compress
	@gcc -fpreprocessed -dD -E -P prog.bpf.c -o compress/bpf.nocomm.temp.c
	@sed -e 's/\s\s\s*/ /g' compress/bpf.nocomm.temp.c > compress/bpf.nospace.temp.c
	@gzip -c compress/bpf.nospace.temp.c > compress/bpf.gz
	@{ echo -n "original," ; stat --format=%s compress/bpf.gz; } > compress/size.txt
	@rm -f compress/*.temp.c
