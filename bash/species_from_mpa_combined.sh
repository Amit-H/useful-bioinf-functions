#!/bin/bash

####################################################################
# This script processes a CSV file named "combined_reads.csv" to extract species-level information from the classification column and reformats the data so that the samples are the columns and the species counts are the rows. The output is saved to "output_species_counts.csv".
#  
# To be used directly after mpa_converter.sh
#
# Input:
# - combined_reads.csv: A CSV file where the first column contains bacterial classifications in the Greengenes taxonomy format (e.g., k__Archaea|p__Euryarchaeota|c__Methanococci|o__Methanococcales|f__Methanococcaceae|g__Methanococcus|s__Methanococcus_maripaludis).
# - The remaining columns contain counts for different samples (e.g., Sample1, Sample2, ..., SampleN).
#
# Output:
# - output_species_counts.csv: A CSV file where the first column contains species names, and the remaining columns contain the counts for each sample.
####################################################################

awk 'BEGIN{FS=OFS=","} NR==1{print "Species", substr($0, index($0, $2))} NR>1{split($1, a, "|"); for(i in a) if(a[i] ~ /^s__/){print substr(a[i], 4), substr($0, index($0, $2))}}' combined_reads.csv > output_species_counts.csv
