#!/bin/bash

##############################################################################
#
# This script reproduces RQ2: Binary Size. The numbers produced should be used
# to rebuild Figure 14 in the paper:
# "Honey Potion: an eBPF Backend for Elixir".
#
# The script only dumps text. It measures the size of the text segment of the
# binary files that are either compiled out of hand-written C programs, or
# from code produced via Honey Potion.
#
# Author: Fernando Magno Quintao Pereira
# August 14th, 2024
#
##############################################################################

# Print summary of results:
#
echo ""
echo "########################################"
echo "Data for Figure 14"
echo "########################################"
echo ""
echo " * hand_written_size: size (bytes) of text segment of hand written C apps"
echo " * honey_potion_size: size (bytes) of text segment of Honey Potion apps"
echo ""


# This function gets the size of the text segment of binary programs.
#
get_text_segment_size() {
  local file="$1"
  local text_size=$(size "$file" | awk 'NR==2 {print $1}')
  echo "$text_size"
}


# Move to the folder where the C files are located, compile them and count LoC:
#
bench_path="../benchmarks"
folders=("countsyscalls" "dropudp" "forcekill" "helloworld" "trafficcount")
script_dir=$(cd "$(dirname "$0")" && pwd)

hw_sizes=()
for folder in "${folders[@]}"
do
	full_path="$bench_path/${folder}"
	cd $full_path
	make  >/dev/null 2>&1
	bin_size=$(get_text_segment_size ./prog)
	hw_sizes+=("$bin_size")
	cd $script_dir >/dev/null
done


# Move to the folder where the elixir files are located, compile them, and
# measure binary sizes.
#
folders=("CountSysCalls" "DropUdp" "Forcekill" "HelloWorld" "TrafficCount")
bench_path="../examples"

cd $bench_path
mix deps.get
mix compile --force >/dev/null 2>&1
cd - >/dev/null

hp_sizes=()
for folder in "${folders[@]}"
do
	full_path="$bench_path/lib/bin/${folder}"
	bin_size=$(get_text_segment_size $full_path)
	hp_sizes+=("$bin_size")
	cd $script_dir
done

# Print the hp_sizes
echo "Benchmark, hand_written_size, honey_potion_size"
for ((i=0; i<${#hp_sizes[@]}; i++)); do
  echo "${folders[$i]}, ${hw_sizes[$i]}, ${hp_sizes[$i]}"
done
