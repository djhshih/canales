#!/usr/bin/env python3

import gzip
import argparse

pr = argparse.ArgumentParser('Determine mode read length')
pr.add_argument('input', help='input FASTQ file')
pr.add_argument('--nreads', '-n', type=int, default=100, help='number of reads to consider [default: 100]')
pr.add_argument('--distribution', '-d', dest='distribution', action='store_const', 
  const=True, default=False, help='output distribution instead of mode')

argv = pr.parse_args()
infname = argv.input
nreads = argv.nreads
print_distribution = argv.distribution

def get_read(f):
    name = f.readline().rstrip()
    sequence = f.readline().rstrip()
    f.readline()    # ignore the '+' line
    quality = f.readline().rstrip()
    return (name, sequence, quality)

if infname.endswith('.gz'):
    f = gzip.open(infname, 'rb')
else:
    f = open(infname, 'r')

lengths_count = dict()

for i in range(nreads):
    (name, sequence, quality) = get_read(f)
    ln = len(sequence)
    if ln == 0: break    # reached end of file
    if ln in lengths_count:
        lengths_count[ln] += 1
    else:
        lengths_count[ln] = 1

f.close()


if print_distribution:
  print(lengths_count)
else:
  mode = max(lengths_count, key=lengths_count.get)
  print(mode)

