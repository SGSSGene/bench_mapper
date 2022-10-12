#!/usr/bin/bash

source $(dirname "$0")/setup.sh

minlen=$(expr $len - $error)

if [ ! -e "${tmp}/index.fa" ]; then
    ln -rfs "${index}" "${tmp}/index.fa"
    bwa index "${tmp}/index.fa"
fi

bwa aln -n $error ${tmp}/index.fa ${fasta_file} 2>&1 1> ${tmp_s}.sai | grep "calculate SA coordinate" | awk '{printf "%ss\n",$5}' > ${timing_file}
bwa samse ${tmp}/index.fa ${tmp_s}.sai ${fasta_file} > ${tmp_s}.sam 2>/dev/null


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
