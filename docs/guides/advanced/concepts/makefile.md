# Makefile
This document specifies how we compile our examples using a generic Makefile.

The generic Makefile we use to compile our examples is located in /priv/BPF_Boilerplates. 

## Dependency Directories
All of the directories used in the Makefile are relative to the Examples folder. (Notice how there is a Makefile there). 

When a user creates a directory and adds Honey-Potion as a dependency these directories aren't valid anymore. To fix this the Honey.Compiler.Pipeline module addresses this by defining some of these directories at runtime, making it work without depending on how the user decided to include Honey-Potion as a dependency. 

## Order of Operations
To compile our eBPF programs, we take some steps. From now on I'll describe each of them in order and give general explanation on what it does/generates. 

When reading the Makefile code keep in mind that we create in the user directory (SRC_DIR) 3 folders, /src, /obj and /bin, of which /src already has the files to be compiled when we get to Honey.Compiler.Pipeline.

### Object Files

```
$(SRC_DIR)/obj/$(TARGET).bpf.o: $(SRC_DIR)/src/$(TARGET).bpf.c $(C_BOILERPLATES)runtime_functions.bpf.c
	${LLVM13}/clang -S \
	    -target bpf \
	    -D__BPF_TRACING__ \
	    $(CFLAGS) \
	    -O2 -emit-llvm -c -g $(SRC_DIR)/src/$(TARGET).bpf.c -o $(SRC_DIR)/obj/$(TARGET).bpf.ll
	${LLVM13}/llc -march=bpf -filetype=obj -o $(SRC_DIR)/obj/$(TARGET).bpf.o $(SRC_DIR)/obj/$(TARGET).bpf.ll
```

In the first step, we take the back-end file (.bpf.c) and use clang to compile the .bpf.ll and .bpf.o files. To do this we depend on the BPF libraries located in /benchmarks/libs and the boilerplates located in /priv/C_Boilerplates. 

As for the flags we use, they are mostly self-explanatory, like -target bpf to make sure we get BPF bytecodes and so on.

This step exists to create the object files (.bpf.o) for the next step.

### Skeleton Generation

```
$(SRC_DIR)/obj/$(TARGET).skel.h: $(SRC_DIR)/obj/$(TARGET).bpf.o
	$(BPFTOOL) gen skeleton $< > $@
```

In the second step we take the object files we just created and make Skeletons (.bpf.skel) by using the BPFTOOL executable. This Skeleton is used as a way to "Include" the bytecodes in our binary after the compilation is complete and allows us some more power in creating eBPF programs, like using global variables for example!

This step is taken to create the Skeleton that is included in our front-end (.c) code.

### Binary Creation

```
$(SRC_DIR)/bin/$(TARGET): %: $(SRC_DIR)/src/$(TARGET).c $(SRC_DIR)/obj/$(TARGET).skel.h
	gcc $(CFLAGS) $(LDFLAGS) -o $(SRC_DIR)/bin/$(TARGET) $(SRC_DIR)/src/$(TARGET).c -Wl,-rpath='$(LIBBPF_DIR)' $(LIBS)
```

In the last step we take the front-end code and compile it into the binary. Because the front-end code has an include for the Skeleton generated in the previous step, we don't have to mention the back-end in this step at all, as it is already included.  

To make sure the Skeleton file is generated before the Binary it is included as a dependency of the binary in the Makefile.

### Overview

So, just to wrap up, the first two steps generate the back-end code, creating files into the /obj/ directory. The first step creates the object file as a final output and the second step takes that and generates Skeleton file as a final output. 

The last step compiles the front-end .c file into a binary file. However, as the front-end includes the Skeleton file, we need the first two steps to generate the final output.
