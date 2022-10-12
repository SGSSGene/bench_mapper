#!/usr/bin/bash

source $(dirname "$0")/setup.sh

minlen=$(expr $len - $error)

if [ ! -e "${tmp}/genome.fa" ]; then
    ln -rfs "${index}" "${tmp}/genome.fa"
    yara_indexer "${tmp}/genome.fa"
fi

p=$(python -c "import math; print(int(math.ceil(100. * ${error} /  ${len})))")

yara_mapper "${tmp}/genome" "${fasta_file}" -o "${sam_file}" -e ${p} -y full -t 1 -v > "${tmp_s}.log" 2>&1

TT=$(cat "${tmp_s}.log" | grep "Total time:" | awk '{print $3}')
T1=$(cat "${tmp_s}.log" | grep "Genome loading time:" | awk '{print $4}')
T2=$(cat "${tmp_s}.log" | grep "Reads loading time:" | awk '{print $4}')
T3=$(cat "${tmp_s}.log" | grep "Output time:" | awk '{print $3}')
echo $(bc <<< $(echo ${TT} - ${T1} - ${T2} - ${T3}))s > ${timing_file}


