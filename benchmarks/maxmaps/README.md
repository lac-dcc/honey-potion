# 🤙 MaxMaps 

This program was made to benchmark how many maps we can use with some limitations from the old implementation of Honey Potion.
This is not part of the set of benchmarks Honey Potion wishes to achieve. Instead it's a study on old limitations.

## 💻 Requirements

This program only requires the `libbpf` and `bpftool`.

## 🚀 How to Build

You can run the following command line:
```bash
make
```
It will generate the following folders:
- `obj` → The folder responsible for the objects created during compilation, like the LLVM IR and skeletons.
- `bin` → The folder where the binary will be found.

## ☕ How to Run

You can run:
```bash
cd bin
sudo ./MaxMaps
```

[⬆ Back to top](#MaxMaps)<br>
