#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: script <in_dir> <out_dir>"
	exit
fi

indir=$(readlink -f $1)
outdir=$(readlink -f $2)
rootpath=$(pwd)/..
binpath=$rootpath/bam2fastq

mkdir -p $outdir && cd $outdir

# assume BAM files are in their own subdirectories
for d in $(ls -1 $indir); do
	if [ -d "$indir/$d" ]; then
		if [ ! -f "$outdir/$d/*.fastq.gz" ]; then
			echo "Processing $outdir/$d ..."
			mkdir -p $outdir/$d && cd $outdir/$d
			grep "^#\!\|^#PBS" $binpath/bam2fastq_diskless_mem4g.pbs \
				> job.pbs
			echo "cd $(pwd)" >> job.pbs
			echo "nixroot $binpath/bam2fastq_diskless_mem4g.pbs $indir/$d/*.bam" \
				>> job.pbs
			qsub job.pbs
		fi
	fi
done

