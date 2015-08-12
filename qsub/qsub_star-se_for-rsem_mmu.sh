#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: script <in_dir> <out_dir>"
	exit
fi

scriptpath=$(dirname "$(readlink -f "$0")")
rootpath=$scriptpath/..
binpath=$rootpath/star
inpattern='*.fastq.gz'
script=$binpath/star-se_for-rsem_gencode_mmu.pbs

indir=$(readlink -f $1)
outdir=$(readlink -f $2)

mkdir -p $outdir && cd $outdir

for d in $(ls -1 $indir); do
	if [ -d "$indir/$d" ]; then
		echo "Processing $indir/$d ..."
		mkdir -p $outdir/$d && cd $outdir/$d
		for f in $indir/$d/$inpattern; do
			if [ -f $f ]; then
				fname=${f##*/}
				if [ ! -s "$outdir/$d/.$fname.done" ]; then
					grep "^#\!\|^#PBS" $script > $fname.job.pbs
					echo "set -e" >> $fname.job.pbs
					echo "cd $(pwd)" >> $fname.job.pbs
					echo "$script $f" >> $fname.job.pbs
					echo "echo \$? > .$fname.done" >> $fname.job.pbs
					qsub $fname.job.pbs
				fi
			fi
		done
	fi
done

