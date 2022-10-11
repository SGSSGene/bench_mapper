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
            f=${t}_${l}_${e}
            file_sam=${data}/alignment/${f}.sam
            file_gold=${gsi}/razers3_${l}_${e}.gsi

            per=$(expr ${e} \* 100 / ${l} || true)
            if [ ! -e "${file_sam}" ] || [ ! -e ${file_gold} ]; then
                continue
            fi
            rabema_evaluate -e ${per} -r ${index} -g ${file_gold} -b ${file_sam} --DONT-PANIC --show-additional-hits 2>&1 | grep "Normalized intervals found \[%\]"
#            rabema_evaluate -e ${per} -r ${index} -g ${file_gold} -b ${file_sam} --DONT-PANIC --show-additional-hits

            echo "finished with $t $e $l"
            echo
        done
    done
done
