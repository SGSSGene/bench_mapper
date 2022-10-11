set -Eeuo pipefail

DATA="${DATA:-data}"
LENGTHS="${LENGTHS:-"(50 100 150 200)"}"
ERRORS="${ERRORS:-"(0 1 2 3 4 5)"}"
TOOLS=${TOOLS:-"(razers3)"}

script_path="$(dirname "$0")"
data="${DATA}"
eval lengths=${LENGTHS}
eval errors=${ERRORS}
eval tools=${TOOLS}
ulimit -n 2048

mkdir -p ${data}/reads
index="${data}/reference_genome.fasta"
gsi=${data}/gsi
mkdir -p ${gsi}

