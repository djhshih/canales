#!/usr/bin/env bash
set -e

# Convert BAM from the TCAG GBM RNA-seq study to FASTQ

if [ "$#" -ne 1 ]; then
	echo "usage: script <in.bam>"
	exit 1
fi

infile=$1
infname=${infile##*/}
outfstem=${infname%%.*}
sortedfile=${outfstem}.sorted_reads.bam


# Sort alignment by reads
samtools sort -n -m 10G -o $sortedfile -T $sortedfile $infile

# Filter out non-primary alignments and strip off /1 and /2 suffix from read names,
# then re-convert to BAM files for bedtools to convert to FASTQ
samtools view -h -F 0x100 $sortedfile | sed 's|/[12]||' | samtools view -b - |
	bedtools bamtofastq -i - -fq ${outfstem}.R1.fastq -fq2 ${outfstem}.R2.fastq

# Compress the FASTQ files
gzip ${outfstem}.R1.fastq
gzip ${outfstem}.R2.fastq

# Clean up
rm $sortedfile

