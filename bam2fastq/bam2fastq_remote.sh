#!/usr/bin/env bash
set -e

host=mdtb2
rootdir=/data/cghub

indir=$1

if [ "$#" -ne 1 ]; then
	echo "usage script <indir>"
	exit 1
fi

# Copy files from remote host
scp -r $host:$rootdir/$indir .

# Derive FASTQ files
#./bam2fastq.sh $indir/*.bam
./bam2fastq_diskless.sh $indir/*.bam

# Clean up
rm $indir/*.{bam,bam.bai}

