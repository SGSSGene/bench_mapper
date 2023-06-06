#!/usr/bin/env bash

set -Eeuo pipefail

if [ -z "${BM_DATA:-}" ] \
    || [ -z "${BM_LENGTHS:-}" ] \
    || [ -z "${BM_ERRORS:-}" ] \
    || [ -z "${BM_TOOLS:-}" ]; then
    echo "BM_DATA, BM_LENGTHS, BM_ERRORS or BM_TOOLS are not set properly"
    exit
fi

eval data="${BM_DATA}"
eval lengths="${BM_LENGTHS}"
eval errors="${BM_ERRORS}"
eval tools="${BM_TOOLS}"


for t in ${tools[@]}; do
    for e in ${errors[@]}; do
        for l in ${lengths[@]}; do
            echo -n "$t $e $l "
            bash ${script_path}/wrapper/${t}.sh "${t}" ${l} ${e} ${data}
            cat ${data}/timing/${t}/time_${l}_${e}.txt
        done
    done
done
