#!/usr/bin/python

from Bio import SeqIO
import argparse as ap
import sys
import os
import tqdm
import subprocess
import re

parser = ap.ArgumentParser()
parser.add_argument('-i', '--input', required=True, type=str, dest='filename',
                        help='Specify a original fasta file.\n')
parser.add_argument('-l', '--list', required=True, type=str, dest='list',
                        help='Specify a list of accession numbers to fetch.\n')
parser.add_argument('-o', '--output', required=True, dest='out',
                        help='Specify a output fasta file name.\n')

results = parser.parse_args()
filename = results.filename
list = results.list
out = results.out

seq_id_list = []
seq_list = []
seq_description_list = []

os.system('> ' + out)

proc = subprocess.Popen("grep -c '>' " + filename, shell=True, stdout=subprocess.PIPE, )
length = int(proc.communicate()[0].split('\n')[0])

with tqdm.tqdm(range(length)) as pbar:
    pbar.set_description('Reading...')
    for record in SeqIO.parse(filename, "fasta"):
        pbar.update()
        seq_id_list.append(record.id)
        seq_list.append(record.seq)
        seq_description_list.append(record.description)
        # print record.description

proc = subprocess.Popen("wc -l < " + list, shell=True, stdout=subprocess.PIPE, )
length = int(proc.communicate()[0].split('\n')[0])

with tqdm.tqdm(range(length+1)) as pbar:
    pbar.set_description('Writing...')
    with open(list, 'rU') as file:
        for line in file:
            pbar.update()
            if "accession" not in line:
                if '>' in line:
                    name = line.split('>')[1].split('\n')[0].split()[0]
                    # print name
                else:
                    name = line.split('\n')[0].split()[0]
                ind = seq_id_list.index(name)
                f = open(out, 'a')
                sys.stdout = f
                print ">" + seq_id_list[ind]
                print re.sub("(.{60})", "\\1\n", str(seq_list[ind]), 0, re.DOTALL)



