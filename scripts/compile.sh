#!/usr/bin/bash

set -Eeuo pipefail

cd "$(dirname "$0")"/..

clean=
if [ $# -gt 1 ] && [ "$1" == "--clean" ]; then
    clean=1
fi


# Build tools
test "${clean}" && rm -rf submodules/fmindex-collection/build
mkdir -p submodules/fmindex-collection/build
(
    cd submodules/fmindex-collection/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make
)

test "${clean}" && rm -rf submodules/radixSA64/build
mkdir -p submodules/radixSA64/build
(
    cd submodules/radixSA64/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make
)

test "${clean}" && rm -rf submodules/seqan3_tools/build
mkdir -p submodules/seqan3_tools/build
(
    cd submodules/seqan3_tools/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native" -DNODIVSUFSORT=1
    make
)

test "${clean}" && rm -rf submodules/columba/build
mkdir -p submodules/columba/build
(
    cd submodules/columba/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native" -DSPARSEHASH_INCLUDE_DIR=${HOMEBREW_PREFIX}/include
    make
)

(
    cd submodules/bwolo
    make
)


test "${clean}" && rm -rf submodules/seqan/build
mkdir -p submodules/seqan/build
(
    cd submodules/seqan/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make rabema_evaluate rabema_build_gold_standard mason_simulator razers3 rabema_prepare_sam
)


(
    cd submodules/bowtie2
    test "${clean}" && make clean
    make
)
