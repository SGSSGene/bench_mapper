#!/usr/bin/bash

source $(dirname "$0")/setup.sh

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
    for e in ${errors[@]}; do
        for l in ${lengths[@]}; do
            f=${t}/${l}_${e}
            file_sam=${data}/alignment/${f}.sam
            file_gold=${gsi}/razers3_${l}_${e}.gsi

            per=$(expr ${e} \* 100 / ${l} || true)
            if [ ! -e "${file_sam}" ] || [ ! -e ${file_gold} ]; then
                echo ${file_sam} or ${file_gold}
                continue
            fi
            echo -n "$t $e $l "
            rabema_evaluate -e ${per} -r ${index} -g ${file_gold} -b ${file_sam} --DONT-PANIC --show-additional-hits 2>&1 | grep "Normalized intervals found \[%\]" | awk '{print $5}' || true
#            rabema_evaluate -e ${per} -r ${index} -g ${file_gold} -b ${file_sam} --DONT-PANIC --show-additional-hits

        done
    done
done
