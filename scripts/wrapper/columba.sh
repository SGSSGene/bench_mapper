#!/usr/bin/bash

source $(dirname "$0")/setup.sh

if [ ${error} -gt 4 ]; then
    echo "NA" > ${timing_file}
    exit
fi

minlen=$(expr $len - $error || true)

# must build index first
if [ ! -e "${tmp}/index.txt" ]; then
    st_dna5todna4 ${index} > ${tmp}/index.dna4.fa
    st_fasta_dump ${tmp}/index.dna4.fa -d '' -e '$' > ${tmp}/index.txt
    st_binary_rev ${tmp}/index.txt > ${tmp}/index.rev.txt
    rm -f ${tmp}/index.sa; radixSA -w ${tmp}/index.txt ${tmp}/index.sa
    rm -f ${tmp}/index.rev.sa; radixSA -w ${tmp}/index.rev.txt ${tmp}/index.rev.sa

    columba_build ${tmp}/index
fi

input="${tmp}/input_${len}_${error}.fa"
ln -rfs "${fasta_file}" "${input}"
columba -s 16 -e $error -i 0 -p uniform -ss kuch1 -m editopt "${tmp}/index" "${input}" | grep "Total duration" | awk '{printf "%s\n",$3}' > ${timing_file}

tail +2 ${input}_output.txt | awk '{if ($6 == 0) { print $1; } else { print $1 "_rev"; }}' | st_name_id_mapper ${input} --revCompl --version-check false > ${tmp_s}.ids
tail +2 ${input}_output.txt | awk '{print $2}' | st_multistring_filter "${index}" $minlen --version-check false | paste -d ' ' ${tmp_s}.ids - | sort -n > ${tmp_s}.pos

st_local_mapper --ref ${index} --queries ${data}/reads/sampled_${len}_${error}.fasta \
                --errors ${error} --positions "${tmp_s}.pos" \
                --output "${sam_file}" --reverse_queries 2> /dev/null
