set -Eeuo pipefail

DATA="${DATA:-data}"
LENGTHS="${LENGTHS:-"(50 100 150 200)"}"
ERRORS="${ERRORS:-"(0 1 2 3 4 5)"}"
#export TOOLS="(sahara sahara-onebesthit sahara-allbesthits yara bowtie2 columba columba-naive columba-pigeon bwa-mem bwa-aln razers3 bowtie2-all bwolo)"
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

