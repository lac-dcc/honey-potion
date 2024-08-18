#!/bin/bash

##############################################################################
#
# This script reproduces RQ4: Optimizations. The numbers produced should be
# used to rebuild Figure 16 in the paper:
# "Honey Potion: an eBPF Backend for Elixir".
#
# The script only dumps text. It measures the size of the ASTs produced for
# different Honey Potion programs, using different groups of optimizations.
#
# Author: Fernando Magno Quintao Pereira
# August 15th, 2024
#
##############################################################################


# Inform the user that this script takes some seconds to finish:
#
echo ""
echo "We are compiling programs with/without optimizations..."
echo "This will take a few seconds..."


# This function extracts the size of the AST, as logged by the Honey Potion
# compiler:
#
extract_ast_size() {
  local log_file="$1"
  local search_string="$2"

  # Search for the string in the log file
  local result=$(grep "$search_string" "$log_file" | awk -F' - ' '{print $2}')

  # Check if grep found the search string
  if [ -z "$result" ]; then
    echo '*'
  else
    echo "$result"
  fi
}


# Move to the folder where the Elixir files are located, compile them and
# record the sizes of the ASTs:
#
optimizers=("noOptimization" "typeProp" "constProp_TypeProp" "constProp_DeadCodeElim_TypeProp")
bench_path="../examples"
script_dir=$(cd "$(dirname "$0")" && pwd)

for optimizer in "${optimizers[@]}"
do
	cp "opt_versions/$optimizer" "../lib/honey/optimizer.ex"
	
	# Compile all the programs in the examples folder, using the new
	# optimizer:
	#
	cd $bench_path
	mix deps.get
	mix compile --force > "$script_dir/$optimizer.txt" 2>/dev/null
	cd - >/dev/null

	# Put back the original optimizer into the honey library:
	#
	cp "opt_versions/optimizer.ex" "../lib/honey/optimizer.ex"
done


# These are the current benchmarks that we have in the examples folder:
#
folders=("Case" "Cond" "CountSysCalls" "CP" "CtxAccess" "DCE" "DropUdp" "Forcekill" "GetPID" "HelloWorld" "Honey_Fact" "Honey_List" "Honey_List_Linked" "Honey_Maps" "Honey_Tuple" "If_Then_Else" "Integer_String_Pattern_Matching" "ListSysCalls" "One" "TrafficCount")

# Print summary of results:
#
echo ""
echo ""
echo "########################################"
echo "Data for Figure 16"
echo "########################################"
echo ""
echo " * noOptimization: all the optimizations disabled"
echo "   - this mode might fail to compile some programs (marked with *)"
echo " * typeProp: only type propagation"
echo " * constProp_TypeProp: type propagation and constant propagation"
echo " * constProp_TypeProp_DeadCodeElim: type propagation, constant propagation and dead-code elimination"

# Print the table header:
#
echo ""
echo -n "Benchmark, "
for optimizer in "${optimizers[@]}"
do
	echo -n "$optimizer, "
done
echo ""

# Print the table body:
#
for folder in "${folders[@]}"
do

	echo -n "$folder, "

	for optimizer in "${optimizers[@]}"
	do
		ast_size=$(extract_ast_size "$optimizer.txt" "$folder ")
        		echo -n "$ast_size, "
	done
	echo ""

done

# Remove log files:
#
for optimizer in "${optimizers[@]}"
do
	rm -rf "$optimizer.txt"
done
