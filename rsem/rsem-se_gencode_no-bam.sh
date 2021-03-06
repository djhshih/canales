#!/bin/bash
set -e

if [ "$#" -ne 5 ]; then
	echo "usage: script <bam> <species> <genome_version> <gencode_version> <nthreads>"
	exit 1
fi

inbam=$1
species=$2
genome_version=$3
gencode_version=$4
nthreads=$5

inpath=$(readlink -f $inbam)
indir=${inpath%/*}
sample_name=${indir##*/}
# the parent directory is named with the sample name

echo $sample_name

# Generate expression table and additional BAM files

# use the minimum allowable seed length to avoid discarding reads successfully
# mapped by STAR
$CANALES_CHROOT rsem-calculate-expression \
	-p $nthreads \
	--seed-length 5 \
	--bam $inbam \
	--no-bam-output \
	${CANALES_DATA_PATH}/rsem/gencode/${species}/release_${gencode_version}/${genome_version}_gencode-${gencode_version} \
	$sample_name

