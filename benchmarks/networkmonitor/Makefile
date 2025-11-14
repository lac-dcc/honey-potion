-include ../Makefile.config

LIBS := -lbpf -lelf -lz -lncurses

# Try custom bpftool first, fallback to system bpftool
BPFTOOL_DEFAULT := $(SRC_DIR)/../tools/bpftool
BPFTOOL_SYSTEM := /usr/sbin/bpftool
BPFTOOL := $(shell if [ -f "$(BPFTOOL_DEFAULT)" ] && $(BPFTOOL_DEFAULT) version >/dev/null 2>&1; then echo "$(BPFTOOL_DEFAULT)"; else echo "$(BPFTOOL_SYSTEM)"; fi)

BPF_ARCH := -D__TARGET_ARCH_x86

# Extend the clean target to also remove debug_maps and vmlinux.h
clean: clean-vmlinux clean-debug-maps

clean-debug-maps:
	@$(RM) $(SRC_DIR)/debug_maps

clean-vmlinux:
	@$(RM) $(SRC_DIR)/vmlinux.h

# Add dependency on vmlinux.h for bpf.o
$(SRC_DIR)/$(TARGET).bpf.o: $(SRC_DIR)/vmlinux.h

# Generate vmlinux.h
$(SRC_DIR)/vmlinux.h:
	$(BPFTOOL) btf dump file /sys/kernel/btf/vmlinux format c > $(SRC_DIR)/vmlinux.h

# Build debug_maps utility
debug_maps: $(SRC_DIR)/debug_maps

$(SRC_DIR)/debug_maps: $(SRC_DIR)/debug_maps.c $(SRC_DIR)/prog.h
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $< -Wl,-rpath='$(LIBBPF_BUILD)' -lbpf -lelf -lz

