#!/usr/bin/bash

set -Eeuo pipefail

cd "$(dirname "$0")"/..

# Build tools
rm -r submodules/fmindex-collection/build
mkdir submodules/fmindex-collection/build
(
    cd submodules/fmindex-collection/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make
)

rm -r submodules/radixSA64/build
mkdir submodules/radixSA64/build
(
    cd submodules/radixSA64/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make
)

rm -rf submodules/seqan3_tools/build
mkdir submodules/seqan3_tools/build
(
    cd submodules/seqan3_tools/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make
)

rm -r submodules/columba/build
mkdir submodules/columba/build
(
    cd submodules/columba/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native" -DSPARSEHASH_INCLUDE_DIR=${HOMEBREW_PREFIX}/include
    make
)

(
    cd submodules/bwolo
    make
)


rm -r submodules/seqan/build
mkdir submodules/seqan/build
(
    cd submodules/seqan/build
    cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="-O3 -march=native"
    make rabema_evaluate rabema_build_gold_standard mason_simulator razers3 rabema_prepare_sam yara_mapper
)


