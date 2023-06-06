#!/usr/bin/bash

source $(dirname "$0")/setup.sh
set -Eeuo pipefail

#bowtie2 has sam
#bwa_aln has sam
#bwa_mem has sam
#columba
#sahara_allbesthits
#sahara_onebesthit
#sahara
#bwolo
#yara has sam

#tools=(columba bwolo sahara_allbesthits sahara_onebesthit sahara bowtie2 bwa_aln bwa_mem yara razers3)

for t in ${tools[@]}; do
    mkdir -p "${data}/hits/${t}"
    for e in ${errors[@]}; do
        for l in ${lengths[@]}; do
            f=${t}/${l}_${e}
            file_sam=${data}/alignment/${f}.sam
            file_gold=${gsi}/razers3_${l}_${e}.gsi
            hit_file="${data}/hits/${t}/${l}_${e}.txt"

            per=$(expr ${e} \* 100 / ${l} || true)
            if [ ! -e "${file_sam}" ]; then
                echo "${file_sam} is missing to run $t ($e $l)"
                continue
            elif [ ! -e ${file_gold} ]; then
                echo "${file_gold} is missing to run $t ($e $l)"
                continue
            fi
            echo -n "$t $e $l "
            if [ ! -e "${hit_file}" ]; then
                rabema_evaluate -e ${per} -r ${index} -g ${file_gold} -b ${file_sam} --DONT-PANIC --show-additional-hits 2>&1 | grep "Normalized intervals found \[%\]" | awk '{print $5}' > "${hit_file}" || echo "-" > "${hit_file}"
            fi
            cat "${hit_file}"
        done
    done
done
