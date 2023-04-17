#!/usr/bin/bash

source $(dirname "$0")/setup.sh
set -Eeuo pipefail

t=razers3

tmp="${data}/tmp/goldstandard"
mkdir -p "${tmp}"

for e in ${errors[@]}; do
    for l in ${lengths[@]}; do
        f=${t}_${l}_${e}
        file_sam=${data}/alignment/${t}/${l}_${e}.sam
        file_bam=${tmp}/${f}.sam.sorted.bam
        file_gold=${gsi}/${f}.gsi
        per=$(expr $e \* 100 / ${l} || true)
        if [ ! -e "${file_sam}" ]; then
            continue
        fi
        rabema_prepare_sam -i ${file_sam} -o ${tmp}/${f}_prepared.sam
        samtools view -Sb ${tmp}/${f}_prepared.sam > ${tmp}/${f}.bam
        samtools sort ${tmp}/${f}.bam > ${file_bam}
        rabema_build_gold_standard -e $per -o ${file_gold} -r ${index} -b ${file_bam} &
        echo "finished with $t $e $l"
    done
    wait
    echo "finished $e"
done

