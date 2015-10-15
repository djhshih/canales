#!/bin/bash
set -o errexit
set -o nounset

indir=$1
outdir=$2
pattern=$3

for path in $indir/$pattern; do
	f=${path##*/}
	sample=${f%%_*}
	if [ ! -d $outdir/$sample ]; then
		mkdir -p $outdir/$sample
	fi
	ln -s $indir/$f $outdir/$sample
done
