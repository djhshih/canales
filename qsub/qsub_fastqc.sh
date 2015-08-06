#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: script <in_dir> <out_dir>"
	exit
fi

scriptpath=$(dirname "$(readlink -f "$0")")
rootpath=$scriptpath/..
binpath=$rootpath/fastqc

indir=$(readlink -f $1)
outdir=$(readlink -f $2)

mkdir -p $outdir && cd $outdir

# Use only the R1 reads
for d in $(ls -1 $indir); do
	if [ -d "$indir/$d" ]; then
		echo "Processing $indir/$d ..."
		mkdir -p $outdir/$d && cd $outdir/$d
		for f in $indir/$d/*.fastq.gz; do
			if [ -f $f ]; then
				fname=${f##*/}
				grep "^#\!\|^#PBS" $binpath/fastqc.pbs > $fname.job.pbs
				echo "cd $(pwd)" >> $fname.job.pbs
				echo "$binpath/fastqc.pbs $f" >> $fname.job.pbs
				qsub $fname.job.pbs
			fi
		done
	fi
done

