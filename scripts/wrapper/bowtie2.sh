#!/usr/bin/bash
index=data/bowtie-index
for len in 40 50 60 70 80 90 100 150 200; do
	for e in 0 1 2 3 4; do
		f=sampled_${len}_${e}.fasta
		ee=$(expr ${e} \* 2)
		input=data/reads/$f
		output=outputs/bowtie2_${f}_${e}_results
		echo -n "$input $e ";
		val=$(stdbuf -oL timeout 3600s bowtie2 -x $index -f $input -t --end-to-end --xeq --mp 2 --np 2 --rdg 0,2 --rfg 0,2 --score-min C,-${ee},0 2>&1 1> ${output}.sam \
			| grep "Time searching" | awk -F ":" '{print $2*3600+$3*60+$4 "s"}')
		if [ ! -z "${val}" ]; then
			echo ${val}
			samtools view ${output}.sam | awk '{
				symb=""; if (and($2, 16) == 16) { symb="_rev";} printf "%s%s,%s,%s\n",$1,symb,$3,$4;
				if (match($NF,"XA:Z:")) { split(substr($NF, 6),a, ";"); for (l in a) { if (a[l]) { print $1 "," a[l]; }}}
			}' | grep -v "\*,\+" | awk -F "," '{v=+$3; s=""; if ($3 < 0) { v=-$3; s="_rev"; } printf "%s%s %s %s\n",$1,s,$2,v; }' > ${output}.s1
			cat ${output}.s1 | awk '{print $1}' | st_name_id_mapper ${input} --revCompl --version-check false > ${output}.qids
			cat ${output}.s1 | awk '{print $2}' | st_name_id_mapper data/GCF_000001405.26_GRCh38_genomic.fasta --version-check false --shortNames >  ${output}.sids
			cat ${output}.s1 | awk '{print $3-1}' | paste -d " " ${output}.qids ${output}.sids - | sort -n > ${output}
		else
			echo "3600s"
			echo "" > ${output}
		fi

	done;
done | tee results/bowtie2
