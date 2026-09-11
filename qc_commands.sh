#!/bin/bash
# Quality control commands
# Run per sample; set ${SAMPLE}, ${TEMP_DIR}, ${DEDUP_DIR}, ${QC_FINAL_DIR} before running

# --- FastQC ---
fastqc raw_data/*_1.fastq.gz raw_data/*_2.fastq.gz -o qc_results/

# --- Deduplication (clumpify) ---
clumpify.sh \
  -Xmx28g \
  in1=${SAMPLE}_1.fastq.gz \
  in2=${SAMPLE}_2.fastq.gz \
  out1=${TEMP_DIR}/${SAMPLE}_deduped.m1.fq \
  out2=${TEMP_DIR}/${SAMPLE}_deduped.m2.fq \
  dedupe \
  subs=1 \
  k=11 \
  passes=3 \
  &> ${TEMP_DIR}/${SAMPLE}_deduplicationstats.txt

# --- Trimming (BBDuk) ---
bbduk.sh \
  -Xmx28g \
  in1=${DEDUP_DIR}/${SAMPLE}_dedup_1.fastq.gz \
  in2=${DEDUP_DIR}/${SAMPLE}_dedup_2.fastq.gz \
  out1=${QC_FINAL_DIR}/${SAMPLE}_1.fastq.gz \
  out2=${QC_FINAL_DIR}/${SAMPLE}_2.fastq.gz \
  ref=adapters,artifacts,phix \
  k=25 \
  mink=6 \
  hdist=1 \
  hdist2=0 \
  ktrim=r \
  qtrim=rl \
  trimq=20 \
  minlength=75
