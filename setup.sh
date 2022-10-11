#!/usr/bin/bash

p="$(pwd)/submodules"

export PATH="${p}/fmindex-collection/build/:${p}/radixSA64/build/:${p}/seqan3_tools/build/bin:${p}/columba/build:${p}/bwolo/bwolo:${p}/bwolo/fasta2Fmi:${p}/seqan/build/bin:${PATH}"
pwd
source .miniconda3/bin/activate
