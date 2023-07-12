# 🔎 FIND STRING

This program drops UDP packets sent to port 3000 that contain any string from the `strings.txt` file in their payload.

## 💻 Requirements

This program only requires the `libbpf`.

## 🚀 How to Build

You can run the following command line:
```bash
make
```
It will generate the following files:
- `prog` → The program responsible for attaching the eBPF program into the kernel and handling the information stored
- `prog.bpf.ll` → The LLVM IR   
- `prog.bpf.o` → The eBPF object that will be attached to the kernel

## ☕ How to Run

You can run:
```bash
sudo ./prog
```
There are no flags for now. To test the program, open two different terminals while the eBPF program is running.
- In the first terminal run the following command to open up a socket that listens to UDP packets that come into the 127.0.0.1 address on port 3000:
```bash
nc -kul localhost 3000
```
- In the second terminal run the following command to connect to the socket opened in the first terminal:
```bash
nc -u localhost 3000
```
Type something on the second terminal that contains any string from the `strings.txt` file and click on `<ENTER>`, you should not see the text on the first terminal. If type something that does not contain any string from the `strings.txt` file followed by `<ENTER>` the text will now appear on the first terminal.

[⬆ Back to top](#FIND-STRING)<br>