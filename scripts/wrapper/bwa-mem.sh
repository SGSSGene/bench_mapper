#!/usr/bin/bash
set -Eeuo pipefail

source $(dirname "$0")/setup.sh

minlen=$(expr $len - $error)

if [ ! -e "${tmp}/index.fa" ]; then
    ln -rfs "${index}" "${tmp}/index.fa"
    bwa index "${tmp}/index.fa"
fi

bwa mem -A 1 -B 0 -O 0,0 -E 1,1 -T ${minlen} "${tmp}/index.fa" "${fasta_file}" 2>&1 1> "${tmp_s}.sam" | grep "Real time" | awk '{printf "%ss\n",$4}' > ${timing_file}

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


#samtools view ${tmp_s}.sam | awk '{
#    symb=""; if (and($2, 16) == 16) { symb="_rev";} printf "%s%s,%s,%s\n",$1,symb,$3,$4;
#    if (match($NF,"XA:Z:")) { split(substr($NF, 6),a, ";"); for (l in a) { if (a[l]) { print $1 "," a[l]; }}}
#}' | grep -v "\*,\+" | awk -F "," '{v=+$3; s=""; if ($3 < 0) { v=-$3; s="_rev"; } printf "%s%s %s %s\n",$1,s,$2,v; }' > ${sam_file}
#cat ${output}.s1 | awk '{print $1}' | st_name_id_mapper ${input} --revCompl --version-check false > ${output}.qids
#cat ${output}.s1 | awk '{print $2}' | st_name_id_mapper ${index} --version-check false --shortNames >  ${output}.sids
#cat ${output}.s1 | awk '{print $3-1}' | paste -d " " ${output}.qids ${output}.sids - | sort -n > ${output}

