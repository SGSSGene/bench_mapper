#!/usr/bin/env bash

set -Eeuo pipefail

source $(dirname "$0")/setup.sh

for t in ${tools[@]}; do
    for e in ${errors[@]}; do
        for l in ${lengths[@]}; do
            echo -n "$t $e $l "
            bash ${script_path}/wrapper/${t}.sh "${t}" ${l} ${e}
            cat ${data}/timing/${t}/time_${l}_${e}.txt
        done
    done
done
