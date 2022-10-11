#!/usr/bin/bash

source $(dirname "$0")/setup.sh

if [ ! -e "${tmp}/genome.fa" ]; then
    ln -rfs "${index}" "${tmp}/genome.fa"
    bowtie2-build ${tmp}/genome.fa ${tmp}/index
fi

ee=$(expr ${error} \* 2 || true)
val=$(stdbuf -oL timeout 3600s bowtie2 --all -x "${tmp}/index" -f "${fasta_file}" -t --end-to-end --xeq --mp 2 --np 2 --rdg 0,2 --rfg 0,2 --score-min C,-${ee},0 2>&1 1> ${tmp_s}.sam \
    | grep "Time searching" | awk -F ":" '{print $2*3600+$3*60+$4 "s"}')

if [ ! -z "${val}" ]; then
    samtools view ${tmp_s}.sam --header > ${tmp_s}.2.sam
    samtools view ${tmp_s}.sam | awk -v OFS='\t' '{
        if (match($NF,"XA:Z:")) {
            split(substr($NF, 6), a, ";");
            $NF=""
            print $0
            query=$1
            for (l in a) {
                if (a[l]) {
                    split(a[l], b, ",");
                    flag=$2
                    flag=or(flag, 256)
                    q=query
                    if (b[2] < 0) {
                        b[2]=-b[2]
                        q=q "_rev"
                    }
                    $1=q
                    $3=b[1]
                    $6=b[3]
                    $4=b[2]
                    $2=flag
                    print $0
                }
            }
        } else {
            print $0
        }
    }' >> ${tmp_s}.2.sam
    samtools sort -O sam -n ${tmp_s}.2.sam > ${sam_file}

else
    echo "3600s"
    echo "" > ${output}
fi
