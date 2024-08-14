#!/bin/bash

##############################################################################
#
# This script reproduces RQ1: Code Size. The numbers produced should be used
# to rebuild Figure 13 in the paper.
# 
# The script only dumps text. First it counts lines of code of the C programs,
# then the Elixir programs, and then the C programs produced out of the Elixir
# programs by Honey Potion.
#
# Author: Fernando Magno Quintao Pereira
# August 14th, 2024
#
##############################################################################

echo "This script reproduces Figure 13 of the paper:"
echo "Honey Potion: an eBPF Backend for Elixir"

# Move to the folder where the C files are located, compile them and count LoC:
#
echo ""
echo "Hand-written benchmark, lines_of_c, lines_of_h"

bench_path="../benchmarks"
folders=("countsyscalls" "dropudp" "forcekill" "helloworld" "trafficcount")

for folder in "${folders[@]}"
do
	full_path="$bench_path/${folder}"

	# Count lines of C:
	#
	loc=0
	for file in $full_path/*.c
	do
		lines=$(wc -l < "$file")
		loc=$((loc + lines))
	done

	# Count lines of H:
	#
	loh=0
	if [[ $(find "$full_path" -name "*.h" -print -quit) ]]; then
		for file in $full_path/*.h
		do
			lines=$(wc -l < "$file")
			loh=$((loc + lines))
		done
	fi

	echo "$folder, $loc, $loh"
done


# Move to the folder where the Elixir files are located, and count lines of
# code:
#
folders=("CountSysCalls" "DropUdp" "Forcekill" "HelloWorld" "TrafficCount")
bench_path="../examples"

echo ""
echo "Honey Potion benchmark (Elixir), lines_of_ex"

for folder in "${folders[@]}"
do
	full_path="$bench_path/lib"

	# Count lines of C:
	#
	loc=$(wc -l < "$full_path/$folder.ex")

	echo "$folder, $loc"
done


# Move to the folder where the C files produced via Honey Potion are located,
# compile them if they were not already compiled and count LoC:
#
if [[ $(find "$bench_path/lib/src" -name "*.c" -print -quit) ]]; then
	echo ""
	echo "Elixir files were already compiled - Skipping compilation"
else
	cd $bench_path
	mix deps.get
	mix compile --force
	cd -
fi

echo ""
echo "Honey Potion benchmark (C), lines_of_c, lines_of_h"

for folder in "${folders[@]}"
do
	full_path="$bench_path/lib/src"

	# Count lines of C:
	#
	loc_back=$(wc -l < "$full_path/$folder.bpf.c")
	loc_front=$(wc -l < "$full_path/$folder.c")
	loc=$((loc_back + lock_front))

	echo "$folder, $loc, 0"
done
