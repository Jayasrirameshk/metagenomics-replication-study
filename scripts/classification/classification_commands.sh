#!/bin/bash
# Taxonomic classification commands
# Run per sample; set ${DB_DIR}, ${RESULTS_DIR}, ${QC_FINAL_DIR}, ${METAPHLAN_DB_DIR}, ${KAIJU_DB_DIR} before running

# --- Kraken2 ---
kraken2 --db ${DB_DIR} \
  --paired --threads 8 --confidence 0.1 \
  --output ${RESULTS_DIR}/${SAMPLE}.kraken \
  --report ${RESULTS_DIR}/${SAMPLE}.report \
  ${QC_FINAL_DIR}/${SAMPLE}_1.fastq.gz \
  ${QC_FINAL_DIR}/${SAMPLE}_2.fastq.gz

# --- Bracken (species, genus, family, order, class, phylum) ---
bracken -d ${DB_DIR} \
  -i ${RESULTS_DIR}/${SAMPLE}.report \
  -o ${RESULTS_DIR}/bracken/species/${SAMPLE}.txt \
  -w ${RESULTS_DIR}/bracken/species/${SAMPLE}_report.txt \
  -r 150 -l S -t 10

bracken -d ${DB_DIR} \
  -i ${RESULTS_DIR}/${SAMPLE}.report \
  -o ${RESULTS_DIR}/bracken/genus/${SAMPLE}.txt \
  -w ${RESULTS_DIR}/bracken/genus/${SAMPLE}_report.txt \
  -r 150 -l G -t 10

bracken -d ${DB_DIR} \
  -i ${RESULTS_DIR}/${SAMPLE}.report \
  -o ${RESULTS_DIR}/bracken/family/${SAMPLE}.txt \
  -w ${RESULTS_DIR}/bracken/family/${SAMPLE}_report.txt \
  -r 150 -l F -t 10

bracken -d ${DB_DIR} \
  -i ${RESULTS_DIR}/${SAMPLE}.report \
  -o ${RESULTS_DIR}/bracken/order/${SAMPLE}.txt \
  -w ${RESULTS_DIR}/bracken/order/${SAMPLE}_report.txt \
  -r 150 -l O -t 10

bracken -d ${DB_DIR} \
  -i ${RESULTS_DIR}/${SAMPLE}.report \
  -o ${RESULTS_DIR}/bracken/class/${SAMPLE}.txt \
  -w ${RESULTS_DIR}/bracken/class/${SAMPLE}_report.txt \
  -r 150 -l C -t 10

bracken -d ${DB_DIR} \
  -i ${RESULTS_DIR}/${SAMPLE}.report \
  -o ${RESULTS_DIR}/bracken/phylum/${SAMPLE}.txt \
  -w ${RESULTS_DIR}/bracken/phylum/${SAMPLE}_report.txt \
  -r 150 -l P -t 10

# --- MetaPhlAn4 ---
metaphlan \
  ${QC_FINAL_DIR}/${SAMPLE}_1.fastq.gz,${QC_FINAL_DIR}/${SAMPLE}_2.fastq.gz \
  --input_type fastq \
  --db_dir ${METAPHLAN_DB_DIR} \
  --mapout ${RESULTS_DIR}/metaphlan4/${SAMPLE}_map.txt \
  --nproc 8 \
  -o ${RESULTS_DIR}/metaphlan4/${SAMPLE}_profile.txt

# --- Kaiju ---
kaiju \
  -t ${KAIJU_DB_DIR}/nodes.dmp \
  -f ${KAIJU_DB_DIR}/kaiju_db_progenomes.fmi \
  -i ${QC_FINAL_DIR}/${SAMPLE}_1.fastq.gz \
  -j ${QC_FINAL_DIR}/${SAMPLE}_2.fastq.gz \
  -o ${RESULTS_DIR}/kaiju/${SAMPLE}.kaiju.out \
  -z 8
