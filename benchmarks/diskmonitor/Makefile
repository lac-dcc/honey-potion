-include ../Makefile.config

LIBS := -lbpf -lelf -lz -lncurses

BPFTOOL_DEFAULT := $(SRC_DIR)/../tools/bpftool
BPFTOOL_SYSTEM := /usr/sbin/bpftool
BPFTOOL := $(shell if [ -f "$(BPFTOOL_DEFAULT)" ] && $(BPFTOOL_DEFAULT) version >/dev/null 2>&1; then echo "$(BPFTOOL_DEFAULT)"; else echo "$(BPFTOOL_SYSTEM)"; fi)

BPF_ARCH := -D__TARGET_ARCH_x86

clean: clean-vmlinux

clean-vmlinux:
	@$(RM) $(SRC_DIR)/vmlinux.h

$(SRC_DIR)/$(TARGET).bpf.o: $(SRC_DIR)/vmlinux.h

$(SRC_DIR)/vmlinux.h:
	$(BPFTOOL) btf dump file /sys/kernel/btf/vmlinux format c > $(SRC_DIR)/vmlinux.h

