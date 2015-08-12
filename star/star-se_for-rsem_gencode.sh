#!/bin/bash

if [ "$#" -ne 3 ]; then
	echo "usage: script <fastq.gz> <species> <gencode_version>"
	exit
fi

infastqgz=$1
species=$2
gencode_version=$3
nthreads=$4

STAR \
	--runThreadN ${nthreads} \
	--genomeDir ${CANALES_DATA_PATH}/star/gencode/${species}/release_${gencode_version} \
	--sjdbGTFfile ${CANALES_DATA_PATH}/gencode/${species}/release_${gencode_version}/gencode.v${gencode_version}.annotation.gtf \
	--outFilterType BySJout \
	--outFilterMultimapNmax 20 \
	--alignSJoverhangMin 8 \
	--alignSJDBoverhangMin 1 \
	--outFilterMismatchNmax 999 \
	--alignIntronMin 20 \
	--alignIntronMax 1000000 \
	--alignMatesGapMax 1000000 \
	--outFileNamePrefix ./ \
	--outSAMtype BAM SortedByCoordinate \
	--chimSegmentMin 20 \
	--quantMode TranscriptomeSAM \
	--readFilesCommand zcat \
	--readFilesIn ${infastqgz}
