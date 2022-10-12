#!/usr/bin/bash

source $(dirname "$0")/setup.sh

ext=i32a
algo=ng21
example --query "${fasta_file}" --index "${index}" --ext ${ext} --min_k $error \
        --max_k $error --algo ${algo} --gen suffix --save_output ${tmp_s}.raw.pos \
        | grep "^${ext}" > ${tmp_s}.log

cat ${tmp_s}.log | grep "^${ext}" | awk '{printf "%s\n",$3}' > ${timing_file}
cat ${tmp_s}.raw.pos | sort -n > ${tmp_s}.pos
rm ${tmp_s}.raw.pos

st_local_mapper --ref ${index} --queries ${data}/reads/sampled_${len}_${error}.fasta \
                --errors ${error} --positions "${tmp_s}.pos" \
                --output "${sam_file}" --reverse_queries 2> /dev/null

