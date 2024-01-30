#!/bin/bash

# Makes sample sheet csv which looks like this (from funcscan docs):
#sample,fasta
#sample_1,/<path>/<to>/wastewater_metagenome_contigs_1.fasta.gz
#sample_2,/<path>/<to>/wastewater_metagenome_contigs_2.fasta.gz

# Run in directory that has the fastq.gz files you want to make into a sample sheet
echo "sample,fasta" > samples.csv && for f in *.fasta.gz; do echo "${f%_*},$(pwd)/$f" >> samples.csv; done

