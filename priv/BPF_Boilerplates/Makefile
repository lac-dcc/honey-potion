# To understand this makefile in a easier to digest format, please see /docs/Makefile!
TARGET ?= prog

#This directory represents the user directory, where the user creates .ex files.
SRC_DIR = $(shell realpath .)
#In Honey.ex this is changed to the location of the Honey build, so this is the anchor to eBPF compilation files.
LIBBPF_DIR ?= $(SRC_DIR)/../../benchmarks/libs/libbpf/src
LIBBPF_INCLUDE ?= $(LIBBPF_DIR)/root/usr/include/
LIBBPF_HEADERS ?= $(LIBBPF_DIR)/../../headers/
#This is also redefined in Honey.ex to the priv directory of the honey-files. This is the anchor to honey files.
PRIV_DIR ?= $(SRC_DIR)/../../priv
C_BOILERPLATES ?= $(PRIV_DIR)/c_boilerplates/
OBJ_FOLDER ?= $(SRC_DIR)/obj/
CFLAGS ?= -I'$(LIBBPF_INCLUDE)' -I'$(LIBBPF_HEADERS)' -I'$(OBJ_FOLDER)' -I'$(C_BOILERPLATES)'
LDFLAGS ?= -L'$(LIBBPF_DIR)'

LIBS = -lbpf -lelf

all: clean $(SRC_DIR)/bin/$(TARGET)

.PHONY: clean

clean:
	rm -f $(SRC_DIR)/bin/$(TARGET)
	rm -f $(SRC_DIR)/obj/$(TARGET).bpf.o
	rm -f $(SRC_DIR)/obj/$(TARGET).bpf.ll
	rm -f $(SRC_DIR)/obj/$(TARGET).skel.h

# Binary Creation
$(SRC_DIR)/bin/$(TARGET): %: $(SRC_DIR)/src/$(TARGET).c $(SRC_DIR)/obj/$(TARGET).skel.h
	gcc $(CFLAGS) $(LDFLAGS) -o $(SRC_DIR)/bin/$(TARGET) $(SRC_DIR)/src/$(TARGET).c -Wl,-rpath='$(LIBBPF_DIR)' $(LIBS)

# Skeleton Generation
$(SRC_DIR)/obj/$(TARGET).skel.h: $(SRC_DIR)/obj/$(TARGET).bpf.o
	bpftool gen skeleton $< > $@

# Object Files
$(SRC_DIR)/obj/$(TARGET).bpf.o: $(SRC_DIR)/src/$(TARGET).bpf.c $(C_BOILERPLATES)runtime_functions.bpf.c
	clang -S \
			-target bpf \
			-D__BPF_TRACING__ \
			$(CFLAGS) \
			-O2 -emit-llvm -c -g $(SRC_DIR)/src/$(TARGET).bpf.c -o $(SRC_DIR)/obj/$(TARGET).bpf.ll
	llc -march=bpf -filetype=obj -o $(SRC_DIR)/obj/$(TARGET).bpf.o $(SRC_DIR)/obj/$(TARGET).bpf.ll

.PHONY: compress
compress:
	@rm -f compress/*.gz
	@mkdir -p compress
	@gcc -fpreprocessed -dD -E -P $(SRC_DIR)/src/$(TARGET).bpf.c -o compress/bpf.nocomm.temp.c
	@sed -e 's/\s\s\s*/ /g' compress/bpf.nocomm.temp.c > compress/bpf.nospace.temp.c
	@gzip -c compress/bpf.nospace.temp.c > compress/bpf.gz
	@{ echo -n "original," ; stat --format=%s compress/bpf.gz; } > compress/size.txt
	@rm -f compress/*.temp.c
