#!/usr/bin/env bash
set -e

infile=$1
#infile=analyses.n50.txt

if [ "$#" -ne 1 ]; then
	echo "usage script <indir>"
	exit
fi

for x in $(cat $infile); do
	if [[ -d $x ]]; then
		echo "Skipping $x ..."
	else
		echo "Processing $x ..."
		./bam2fastq_remote.sh $x
	fi
done

