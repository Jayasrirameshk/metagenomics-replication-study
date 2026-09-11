#!/bin/bash

input_path="/Users/jayasriramesh/Downloads/outputs/kaiju"

echo -e "sampleID\tcounts\trelabundance\tname" > kaiju.family
for file in ${input_path}/*.kaiju.out; do
    id=$(basename ${file} | cut -f1 -d ".")
    v=$(cat ${file} | wc -l)
    total=$(awk -v a="$v" \
        'BEGIN {FS="\t"; OFS=FS} FNR > 2 && FNR < a-5 {b += $2} END {print b}' \
        ${file})
    awk -v a="$v" -v b="$id" -v c="$total" \
        'BEGIN {FS="\t"; OFS=FS} FNR > 2 && FNR < a-5 {print b,$2,$2/c,$3}' \
        ${file} >> kaiju.family
done
