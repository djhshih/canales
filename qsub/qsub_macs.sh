#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: script <in_dir> <out_dir>"
	exit 1
fi

scriptpath=$(dirname "$(readlink -f "$0")")
rootpath=$scriptpath/..
binpath=$rootpath/macs
script=$binpath/macs.pbs
testpattern='*_IP_*.bam'
controlpattern='*_inp_*.bam'

indir=$(readlink -f $1)
outdir=$(readlink -f $2)

mkdir -p $outdir && cd $outdir

for d in $(ls -1 $indir); do
	if [[ -d "$indir/$d" ]]; then
		echo -n "Processing $d ... "
		mkdir -p $outdir/$d && cd $outdir/$d
		testfile=$(ls -1 $indir/$d/$testpattern)
		controlfile=$(ls -1 $indir/$d/$controlpattern)
		if [[ -f $testfile && -f $controlfile ]]; then
			fname=${testfile##*/}
			if [ ! -s "$outdir/$d/.$fname.done" ]; then
				grep "^#\!\|^#PBS" $script > $fname.job.pbs
				echo "set -e" >> $fname.job.pbs
				echo "cd $(pwd)" >> $fname.job.pbs
				echo "$script $testfile $controlfile" >> $fname.job.pbs
				echo "echo \$? > .$fname.done" >> $fname.job.pbs
				qsub $fname.job.pbs
			else
				echo "skipped."
			fi
		fi
	fi
done

