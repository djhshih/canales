#!/usr/bin/env bash
set -e

# Convert BAM from the TCAG GBM RNA-seq study to FASTQ
# Avoid intermediate disk IO operations through use of pipes

if [ "$#" -ne 1 ]; then
	echo "usage: script <in.bam>"
	exit 1
fi

infile=$1
infname=${infile##*/}
outfstem=${infname%%.*}
tmpdir=$(mktemp -d)
r1pipe=$tmpdir/R1.pipe
r2pipe=$tmpdir/R2.pipe

trap "rm -rf $tmpdir" EXIT

mkfifo $r1pipe
mkfifo $r2pipe

# Sort alignment by reads
# Strip off /1 and /2 suffix from read names
# Filter out non-primary alignment reads and convert to BAM files
# Then use bedtools to convert BAM to FASTQ, writing to a named pipe
samtools sort -n -m 50G -T $outfstem -O sam $infile \
	| sed 's|/[12]||' \
	| samtools view -b -F 0x100 - \
	| bedtools bamtofastq -i - -fq $r1pipe -fq2 $r2pipe &


# Read from named pipes and output compressed FASTQ files
gzip -c <$r1pipe >${outfstem}.R1.fastq.gz &
gzip -c <$r2pipe >${outfstem}.R2.fastq.gz &

# Wait for subprocesses to finish
for job in $(jobs -p ); do
	echo "Waiting for subprocess $job ..."
	wait $job || echo "Subprocess $job failed."
done

