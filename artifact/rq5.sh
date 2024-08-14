#!/bin/bash

##############################################################################
#
# This script reproduces RQ5: Compilation time. The numbers produced should be
# used to rebuild Figure 17 in the paper:
# "Honey Potion: an eBPF Backend for Elixir".
#
# However, there are two differences.
# 1. We are not separating the Honey Potion times into Code Generation and
# Compilation: that turned out to be difficult to do automatically, for it
# requires us to change the code of the Honey Potion compiler to print out
# internal time.
#
# 2. We are reporting user time for C, and user+sys for Honey Potion. This
# change has simplified our automatic setup. The sys time that we ommit for the
# hand-written C programs is rather small, and it is not for the benefit of
# Honey Potion anyways.
#
# The script only dumps text. It measures the time taken to compile the
# hand-written C programs, the time taken to generate C code out of Elixir via
# honey potion, and the time taken to compile the generated programs.
#
# Author: Fernando Magno Quintao Pereira
# August 14th, 2024
#
##############################################################################

echo "This script reproduces Figure 17 of the paper:"
echo "Honey Potion: an eBPF Backend for Elixir"


# This function gets user time taken by `command`.
#
get_user_time() {
  local command="$1"
  local time_output=$( (time $command) 2>&1 1>/dev/null )
  local user_time=$(echo "$time_output" | grep "user" | awk '{print $2}')
  echo "$user_time"
}


# This function converts time in the format ZmY.XXXms to milliseconds.
#
convert_time_to_ms() {
  local time_str="$1"

  # Extract minutes and seconds from the input string
  local minutes=$(echo "$time_str" | awk -F'[m.]' '{print $1}')
  local seconds=$(echo "$time_str" | awk -F'[m.]' '{print $2}')
  local milliseconds=$(echo "$time_str" | awk -F'[.]' '{print $2}' | sed 's/s//')

  # Calculate total milliseconds
  local total_milliseconds=$((minutes * 60 * 1000 + seconds * 1000 + milliseconds))

  echo "$total_milliseconds"
}


# Move to the folder where the C files are located, compile them and count LoC:
#
bench_path="../benchmarks"
folders=("countsyscalls" "dropudp" "forcekill" "helloworld" "trafficcount")
script_dir=$(cd "$(dirname "$0")" && pwd)

hw_times=()
for folder in "${folders[@]}"
do
	full_path="$bench_path/${folder}"
	cd $full_path
	user_time=$(get_user_time "make")
	ms_time=$(convert_time_to_ms "$user_time")
	hw_times+=("$ms_time")
	cd $script_dir
done


# Move to the folder where the Elixir files are located, compile them and
# record compilation times:
#
folders=("CountSysCalls" "DropUdp" "Forcekill" "HelloWorld" "TrafficCount")
bench_path="../examples"

extract_time() {
  local log_file="$1"
  local search_string="$2"

  grep "$search_string" "$log_file" | sed 's/\[profile\]\s*\(.*\)ms\s*compiling.*/\1/'
}

cd $bench_path
mix deps.get
mix compile --force --profile=time 2> "$script_dir/time_log.txt"
cd -

hp_times=()
for folder in "${folders[@]}"
do
        user_time=$(extract_time "time_log.txt" $folder)
        hp_times+=("$user_time")
done


# Print the compilation times:
#
echo ""
echo "Benchmark, hand_written_time, honey_potion_time"
for ((i=0; i<${#hw_times[@]}; i++)); do
	echo "${folders[$i]}, ${hw_times[$i]}, ${hp_times[$i]}"
done


# Remove the log file:
#
rm -rf "time_log.txt"
