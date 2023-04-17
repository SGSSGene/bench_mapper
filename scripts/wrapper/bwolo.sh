#!/usr/bin/bash

set -Eeuo pipefail

source $(dirname "$0")/setup.sh

minlen=$(expr $len - $error || true)

if [ ! -e "${tmp}/index.txt" ]; then
    fasta2Fmi -f ${index} -i ${tmp}/index
fi

bwolo -f $fasta_file -i "${tmp}/index" -s -${error} --rev-compl 2>&1 1> ${tmp_s}.raw \
    | grep "Search time" \
    | awk '{printf "%ss\n",$3}' > ${timing_file}

cat ${tmp_s}.raw \
    | awk -F ":" '{print $2}' \
    | st_multistring_filter ${index} $minlen --version-check false \
    | paste -d " " - ${tmp_s}.raw | tr ":" " " \
    | awk '{printf "%s %s %s\n",$3,$1,$2}' | sort -n > ${tmp_s}.pos

st_local_mapper --ref ${index} --queries ${data}/reads/sampled_${len}_${error}.fasta \
                --errors ${error} --positions "${tmp_s}.pos" \
                --output "${sam_file}" --reverse_queries 2> /dev/null

