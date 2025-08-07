#!/bin/bash

export OMP_TARGET_OFFLOAD=MANDATORY

output_file="lulesh_results.md"
echo "| Directory | Compilation Flags | s | Avg Elapsed Time (s) | Final Origin Energy |" > "$output_file"
echo "|-----------|--------------------|---|------------------------|----------------------|" >> "$output_file"

rep=1
dirs=(
  #"1_OpenMPApps_OpenMP4/lulesh-mp4"
  #"2_HeCBench/src/lulesh-omp"
  #"3_OpenACC-translation/openacc/src"
  #"LULESH-openacc-work/openacc/src"
  "3_OpenACC-translation-basic/openacc/src"
  #"3_OpenACC-translation-keep-binding-clauses/openacc/src"
  "3_OpenACC-translation-present-alloc/openacc/src"
)

for dir in "${dirs[@]}"; do
  echo "==============================="
  echo "Processing directory: $dir"
  cd "$dir" || { echo "Failed to enter $dir"; continue; }

  make clean &> /dev/null
  echo "Compiling..."
  make &> build.log

  compile_line=$(grep -m1 -E "pgc\+\+|nvc\+\+|icpx|g\+\+" build.log)
  flags=$(echo "$compile_line" | cut -d ' ' -f2-)
  echo "Compilation flags: $flags"

  if [[ -x "./lulesh" ]]; then
    exe="./lulesh"
  elif [[ -x "./lulesh2.0" ]]; then
    exe="./lulesh2.0"
  else
    echo "No valid lulesh binary (lulesh or lulesh2.0) found in $dir"
    cd - > /dev/null
    continue
  fi

  for s in 100 150 200 250 300; do
    echo "--------------------------------"
    echo "Running: $exe -i 100 -s $s ($rep times)"

    # Wait if total CPU usage is too high (> 50%)
    cpu_sum=$(top -b -n 1 | awk 'NR>7 { sum += $9 } END { printf "%.1f\n", sum }')
    cpu_sum_val=${cpu_sum%.*}

    if (( cpu_sum_val > 50 )); then
      echo -e "\033[1;31mWARNING: you are not alone! (CPU: ${cpu_sum}%)\033[0m"
      while (( cpu_sum_val > 50 )); do
        sleep 5
        cpu_sum=$(top -b -n 1 | awk 'NR>7 { sum += $9 } END { printf "%.1f\n", sum }')
        cpu_sum_val=${cpu_sum%.*}
      done
    fi

    total_time=0
    consistent_energy=""
    inconsistent_energy=false

    for i in {1..$rep}; do
      output=$($exe -i 100 -s $s 2>&1)

      elapsed=$(echo "$output" | grep "Elapsed time" | awk '{print $(NF-1)}')
      energy=$(echo "$output" | grep "Final Origin Energy" | awk '{print $NF}')

      if [[ -z "$elapsed" || -z "$energy" ]]; then
        echo -e "\033[1;31mRun $i failed or did not produce valid output\033[0m"
        continue
      fi

      total_time=$(awk "BEGIN {print $total_time + $elapsed}")
      
      if [[ -z "$consistent_energy" ]]; then
        consistent_energy="$energy"
      elif [[ "$energy" != "$consistent_energy" ]]; then
        inconsistent_energy=true
      fi
    done

    avg_time=$(awk "BEGIN {printf \"%.3f\", $total_time / $rep}")
    echo -n "  s = $s | Avg Elapsed = $avg_time s"

    if $inconsistent_energy; then
      echo -e " | \033[1;31mEnergy mismatch across runs!\033[0m"
      energy_note="INCONSISTENT"
    else
      echo " | Energy = $consistent_energy"
      energy_note="$consistent_energy"
    fi

    echo "| $dir | \`$flags\` | $s | $avg_time | $energy_note |" >> "$output_file"
  done

  cd - > /dev/null
done

echo "==============================="
echo "All results saved to $output_file"

