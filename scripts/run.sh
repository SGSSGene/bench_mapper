#!/usr/bin/bash

source $(dirname "$0")/setup.sh

t="razers3"

for t in ${tools[@]}; do
    for e in ${errors[@]}; do
        for l in ${lengths[@]}; do
            bash ${script_path}/wrapper/${t}.sh "${t}" ${l} ${e}
        done
    done
done
