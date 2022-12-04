TARGET ?= prog


SRC_DIR = $(shell realpath .)
LIBBPF_DIR ?= $(SRC_DIR)/../../libs/libbpf/src
LIBBPF_INCLUDE ?= $(LIBBPF_DIR)/root/usr/include/
LIBBPF_HEADERS ?= $(LIBBPF_DIR)/../../headers/
CFLAGS ?= -I'$(LIBBPF_INCLUDE)' -I'$(LIBBPF_HEADERS)'
LDFLAGS ?= -L'$(LIBBPF_DIR)'
LLVM13 ?= /usr/bin

LIBS = -lbpf -lelf

all: clean ./obj/$(TARGET).bpf.o skel ./bin/$(TARGET)

.PHONY: clean

clean:
	rm -f ./bin/$(TARGET)
	rm -f ./obj/$(TARGET).bpf.o
	rm -f ./obj/$(TARGET).bpf.ll

# Empty rule because not all programs need to use a skeleton
skel: ./obj/$(TARGET).bpf.o ;

./bin/$(TARGET): %: ./src/$(TARGET).c
	gcc $(CFLAGS) $(LDFLAGS) -o ./bin/$(TARGET) ./src/$(TARGET).c -Wl,-rpath='$(LIBBPF_DIR)' $(LIBS)

# src directory is created during honey-potion execution, so only obj and bin are attempted here
./obj/$(TARGET).bpf.o: ./src/$(TARGET).bpf.c
	mkdir -p obj
	mkdir -p bin
	${LLVM13}/clang -S \
	    -target bpf \
	    -D__BPF_TRACING__ \
	    $(CFLAGS) \
	    -O2 -emit-llvm -c -g ./src/$(TARGET).bpf.c -o ./obj/$(TARGET).bpf.ll
	${LLVM13}/llc -march=bpf -filetype=obj -o ./obj/$(TARGET).bpf.o ./obj/$(TARGET).bpf.ll

.PHONY: compress
compress:
	@rm -f compress/*.gz
	@mkdir -p compress
	@gcc -fpreprocessed -dD -E -P ./src/$(TARGET).bpf.c -o compress/bpf.nocomm.temp.c
	@sed -e 's/\s\s\s*/ /g' compress/bpf.nocomm.temp.c > compress/bpf.nospace.temp.c
	@gzip -c compress/bpf.nospace.temp.c > compress/bpf.gz
	@{ echo -n "original," ; stat --format=%s compress/bpf.gz; } > compress/size.txt
	@rm -f compress/*.temp.c