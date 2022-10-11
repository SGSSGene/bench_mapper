#!/usr/bin/bash

source $(dirname "$0")/setup.sh

razers3 -v -rr 100 -i ${identity} -m 100000000 -ds -o ${sam_file} ${index} ${fasta_file}
