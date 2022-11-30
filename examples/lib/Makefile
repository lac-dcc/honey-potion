TARGET ?= prog


SRC_DIR = $(shell realpath .)
LIBBPF_DIR ?= $(SRC_DIR)/../../libs/libbpf/src
CFLAGS ?= -I'$(LIBBPF_DIR)/root/usr/include/' -I'$(LIBBPF_DIR)/../../headers/'
LDFLAGS ?= -L'$(LIBBPF_DIR)'
LLVM13 ?= /usr/bin

BPFTOOL='$(SRC_DIR)/../../tools/bpftool'

LIBS = -lbpf -lelf

all: clean $(TARGET).bpf.o skel $(TARGET)

.PHONY: clean

clean:
	rm -f $(TARGET)
	rm -f $(TARGET).bpf.o
	rm -f $(TARGET).bpf.ll

# Empty rule because not all programs need to use a skeleton
skel: $(TARGET).bpf.o ;

$(TARGET): %: $(TARGET).c Makefile
	$(MAKE) --directory='${LIBBPF_DIR}' all
	DESTDIR=root $(MAKE) --directory='${LIBBPF_DIR}' install_headers
	gcc $(CFLAGS) $(LDFLAGS) -o $(TARGET) $(TARGET).c -Wl,-rpath='$(LIBBPF_DIR)' $(LIBS)

$(TARGET).bpf.o: $(TARGET).bpf.c
	${LLVM13}/clang -S \
	    -target bpf \
	    -D__BPF_TRACING__ \
	    $(CFLAGS) \
	    -O2 -emit-llvm -c -g $(TARGET).bpf.c
	${LLVM13}/llc -march=bpf -filetype=obj -o $(TARGET).bpf.o $(TARGET).bpf.ll

.PHONY: compress
compress:
	@rm -f compress/*.gz
	@mkdir -p compress
	@gcc -fpreprocessed -dD -E -P $(TARGET).bpf.c -o compress/bpf.nocomm.temp.c
	@sed -e 's/\s\s\s*/ /g' compress/bpf.nocomm.temp.c > compress/bpf.nospace.temp.c
	@gzip -c compress/bpf.nospace.temp.c > compress/bpf.gz
	@{ echo -n "original," ; stat --format=%s compress/bpf.gz; } > compress/size.txt
	@rm -f compress/*.temp.c