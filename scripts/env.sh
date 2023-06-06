export BM_DATA="${BM_DATA:-data}"
export BM_LENGTHS="${BM_LENGTHS:-"(50 100 150 200)"}"
export BM_ERRORS="${BM_ERRORS:-"(0 1 2 3 4 5)"}"
#export TOOLS="(sahara sahara-onebesthit sahara-allbesthits yara bowtie2 columba columba-naive columba-pigeon bwa-mem bwa-aln razers3 bowtie2-all bwolo)"
export BM_TOOLS=${BM_TOOLS:-"(razers3)"}

script_path="$(dirname "$0")"
ulimit -n 2048

mkdir -p ${BM_DATA}/reads
index="${BM_DATA}/reference_genome.fasta"
gsi=${BM_DATA}/gsi
mkdir -p ${gsi}

echo "Setup:"
echo "  BM_DATA=${BM_DATA}"
echo "  BM_LENGTHS=${BM_LENGTHS}"
echo "  BM_ERRORS=${BM_ERRORS}"
echo "  BM_TOOLS=${BM_TOOLS}"
