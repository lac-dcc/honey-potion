# 📦 DROP UDP

This program drops UDP packets sent to port 3000 and redirects UDP packets from port 3001 to 3000.

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
There are no flags for now. To test the program, open three different terminals while the eBPF program is running.
- In the first terminal run the following command to open up a socket that listens to UDP packets that come into the 127.0.0.1 address on port 3000:
```bash
nc -kul localhost 3000
```
- In the second terminal run the following command to open a socket that listens to UDP packets that come into the 127.0.0.1 address on port 3001:
```bash
nc -kul localhost 3001
```
- In the third terminal run the following command to connect to the socket opened in the first terminal:
```bash
nc -u localhost 3000
```
Type something on the third terminal and click on `<ENTER>`, you should not see the text on the first terminal. If you close the eBPF program and type something followed by `<ENTER>` the text will now appear on the first terminal.

Now, stop the process in the third terminal and run the following command line while the eBPF program is running:
```bash
nc -u localhost 3001
```
Type something on the third terminal again and click on `<ENTER>`, you should see the text on the first terminal. If you close the eBPF program and type something followed by `<ENTER>` the text will now appear on the second terminal.

[⬆ Back to top](#DROP-UDP)<br>