#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: script <in_dir> <out_dir>"
	exit
fi

scriptpath=$(dirname "$(readlink -f "$0")")
rootpath=$scriptpath/..
binpath=$rootpath/keep5pnbp

indir=$(readlink -f $1)
outdir=$(readlink -f $2)

mkdir -p $outdir && cd $outdir

# Use only the R1 reads
for d in $(ls -1 $indir); do
	if [ -d "$indir/$d" ]; then
		if [ -f $indir/$d/*.R1.fastq.gz ]; then
			echo "Processing $indir/$d ..."
			mkdir -p $outdir/$d && cd $outdir/$d
			grep "^#\!\|^#PBS" $binpath/keep5p50bp.pbs > job.pbs
			echo "cd $(pwd)" >> job.pbs
			echo "$binpath/keep5p50bp.pbs $indir/$d/*.R1.fastq.gz" >> job.pbs
			qsub job.pbs
		fi
	fi
done

