#!/bin/sh
# c_and_x stands for Compile and eXecute
mix compile --force && 
cp lib/xdp_working_frontend.c lib/src/XdpExample.c && 
{
    # rm -f ./lib/bin/* ;
    # rm -f ./lib/obj/* ;
    make -C ./lib/ TARGET=XdpExample clean all;
} && 
sudo ./lib/bin/XdpExample