set -Eeuo pipefail

tool="$1"; shift
len="$1"; shift
error="$1"; shift
data="${DATA}"

error_rate=$(expr ${error} \* 100 / ${len} || true)
identity=$(expr 100 - ${error_rate} || true)
tmp="${data}/tmp/${tool}"
mkdir -p ${tmp}
tmp_s="${tmp}/tmp_${len}_${error}"

mkdir -p ${data}/alignment/${tool}
mkdir -p ${data}/timing/${tool}

index=${data}/reference_genome.fasta
fasta_file=${data}/reads/sampled_${len}_${error}.fasta
sam_file=${data}/alignment/${tool}/${len}_${error}.sam
timing_file=${data}/timing/${tool}/time_${len}_${error}.txt


if [ -e "${sam_file}" ]; then
    echo "${tool} file ${sam_file} exists - skipping"
    exit
fi
