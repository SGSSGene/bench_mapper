#!/usr/bin/bash

source $(dirname "$0")/setup.sh

# This generates data


#for len in (40 50 60 70); do
#    mason_simulator -ir ${index} --illumina-read-length ${len} --out-alignment ${data}/reads/sampled_${len}.sam -o ${data}/reads/sampled_${len}.fasta --seq-technology illumina --num-fragments 2000000 --illumina-prob-mismatch=0.04 --illumina-prob-insert 0.0005 --illumina-prob-deletion 0.0005;
#done
#
#for len in (80 90 100); do
#    mason_simulator -ir ${index} --illumina-read-length ${len} --out-alignment ${data}/reads/sampled_${len}.sam -o ${data}/reads/sampled_${len}.fasta --seq-technology illumina --num-fragments 2000000 --illumina-prob-mismatch=0.02 --illumina-prob-insert 0.00025 --illumina-prob-deletion 0.00025;
#done
#
#for len in (150 200); do
#    mason_simulator -ir ${index} --illumina-read-length ${len} --out-alignment ${data}/reads/sampled_${len}.sam -o ${data}/reads/sampled_${len}.fasta --seq-technology illumina --num-fragments 2000000 --illumina-prob-mismatch=0.01 --illumina-prob-insert 0.000125 --illumina-prob-deletion 0.000125;
#done
#
#
#for len in 40 50 60 70 80 90 100 150 200; do
#    for e in 0 1 2 3 4; do
#        st_sam_filter ${data}/reads/sampled_${len}.sam ${data}/reads/sampled_${len}_${e}.sam --fasta ${data}/reads/sampled_${len}_${e}.fasta --dna4 --num 100000 --error ${e} --maxErrors ${e}
#    done
#done


for len in 50; do
    mason_simulator -ir ${index} --illumina-read-length ${len} --out-alignment ${data}/reads/simulated_${len}.sam -o ${data}/reads/simulated_${len}.fasta --seq-technology illumina --num-fragments 20000 --illumina-prob-mismatch=0.04 --illumina-prob-insert 0.0005 --illumina-prob-deletion 0.0005 &
done

for len in 100; do
    mason_simulator -ir ${index} --illumina-read-length ${len} --out-alignment ${data}/reads/simulated_${len}.sam -o ${data}/reads/simulated_${len}.fasta --seq-technology illumina --num-fragments 20000 --illumina-prob-mismatch=0.02 --illumina-prob-insert 0.00025 --illumina-prob-deletion 0.00025 &
done

for len in 150 200; do
    mason_simulator -ir ${index} --illumina-read-length ${len} --out-alignment ${data}/reads/simulated_${len}.sam -o ${data}/reads/simulated_${len}.fasta --seq-technology illumina --num-fragments 20000 --illumina-prob-mismatch=0.01 --illumina-prob-insert 0.000125 --illumina-prob-deletion 0.000125 &
done
wait


for e in ${errors[@]}; do
    for len in ${lengths[@]}; do
        st_sam_filter ${data}/reads/simulated_${len}.sam ${data}/reads/sampled_${len}_${e}.sam --fasta ${data}/reads/sampled_${len}_${e}.fasta --dna4 --num 100000 --minError ${e} --error ${e}
    done
    wait
done
