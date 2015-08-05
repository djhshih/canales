#!/usr/bin/env python3

import gzip
import argparse

pr = argparse.ArgumentParser('Determine average read length')
pr.add_argument('input', help='input FASTQ file')
pr.add_argument('--nreads', '-n', type=int, default=100, help='number of reads to consider')

argv = pr.parse_args()
infname = argv.input
nreads = argv.nreads

def get_read(f):
    name = f.readline()
    sequence = f.readline()
    f.readline()    # ignore the '+' line
    quality = f.readline()
    return (name, sequence, quality)

if infname.endswith('.gz'):
    f = gzip.open(infname, 'rb')
else
    f = open(infname, 'r')

lengths_count = dict()

for i in range(nreads):
    (name, sequence, quality) = get_read(f)
    ln = len(sequence)
    if ln in lengths_count:
        lengths_count[ln] += 1
    else:
        lenghts_count[ln] = 1

f.close()

mode = max(lengths_count, key=lengths_count.get)

print(mode)
