#!/usr/bin/bash

set -Eeuo pipefail

cd "$(dirname "$0")"/..
if [ $# -ge 1 ] && [ "$1" == "--clean" ]; then
    rm -rf submodules/fmindex-collection/build
    rm -rf submodules/radixSA64/build
    rm -rf submodules/seqan3_tools/build
    rm -rf submodules/columba/build
    rm -rf submodules/seqan/build
    (cd submodules/bwolo/bwolo/src; rm -f *.d *.o ../bwolo)
    (cd submodules/bwolo/fasta2Fmi/src/; rm -f *.d *.o ../fasta2Fmi)
    (cd submodules/bowtie2; make clean)

    echo "cleaned/removed build folders"
    exit
fi


# Build tools
mkdir -p submodules/fmindex-collection/build
(
    echo "# Building fmindex-collection (sahara)"
    cd submodules/fmindex-collection/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make
)

mkdir -p submodules/radixSA64/build
(
    echo "# Building radixSA64"
    cd submodules/radixSA64/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make
)

mkdir -p submodules/seqan3_tools/build
(
    echo "# Building seqan3_tools"
    source setup.sh
    source .miniconda3/bin/activate
    cd submodules/seqan3_tools/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native" -DNODIVSUFSORT=1
    make
)

mkdir -p submodules/columba/build
(
    echo "# Building columba"
    source .miniconda3/bin/activate
    cd submodules/columba/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make
)

(
    echo "# Building bwolo"
    source setup.sh
    cd submodules/bwolo
    make
)


mkdir -p submodules/seqan/build
(
    echo "# Building seqan2 (rabema)"
    source .miniconda3/bin/activate
    cd submodules/seqan/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make rabema_evaluate rabema_build_gold_standard mason_simulator razers3 rabema_prepare_sam
)


(
    echo "# Building bowtie2"
    cd submodules/bowtie2
    make
)
