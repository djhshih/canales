#!/bin/bash
# Keep N bp from the 5' end of reads
set -e

if [ "$#" -ne 3 ]; then
	echo "usage: script <in_file> <out_file> <targetlen>"
	exit
fi

infile=$(readlink -f $1)
outfile=$(readlink -f $2)
scriptpath=$(dirname "$(readlink -f "$0")")
rootpath=$scriptpath/..

targetlen=$3
observedlen=$($rootpath/readlen/readlen.py $infile)
cutlen=$(expr $observedlen - $targetlen)

echo "target read length: $targetlen bp"
echo "observed read length: $observedlen bp"
echo "length to cut from 3' end: $cutlen bp"
echo

# in order to keep $targetlen from the 5' end of the reads,
# cut $cutlen from the 3' end
cutadapt --cut -$cutlen -o $outfile $infile
