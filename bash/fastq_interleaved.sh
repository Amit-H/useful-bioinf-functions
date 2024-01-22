#!/bin/bash

# Converts R1 + R2 fastq files into interleaved fastq files and also creates a fasta version.
# REQUIRES BBMap 

# Define the directory containing the fastq files
FASTQ_DIR="./" # Replace with the path to your fastq files if they are not in the current directory

# Navigate to the directory
cd "$FASTQ_DIR"

# Loop through R1 files and find matching R2 files
for R1_file in sim_Sample_*_R1.fastq; do
    # Extract the sample ID by removing the suffix "_R1.fastq"
    ID=$(echo "$R1_file" | sed 's/_R1.fastq//')

    # Define the corresponding R2 file
    R2_file="${ID}_R2.fastq"

    # Check if the R2 file exists
    if [ -f "$R2_file" ]; then
        # Create interleaved fastq file
        reformat.sh in1="$R1_file" in2="$R2_file" out="${ID}.fastq"

        # Convert interleaved fastq to fasta
        reformat.sh in="${ID}.fastq" out="${ID}.fasta"
    else
        echo "Matching R2 file for $R1_file not found."
    fi
done
