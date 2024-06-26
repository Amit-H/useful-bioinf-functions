#!/bin/bash

####################################################################
# combine_mpa.sh converts multiple outputs from kreport2mpa.py
# and generates a combined CSV or MPA file.
# This script is based on the original function by Jennifer Lu
# (https://github.com/jenniferlu717/KrakenTools) and has been
# modified to handle multiple input files and ensure non-blank
# columns in the output.
#
# Author: Jennifer Lu, jennifer.lu717@gmail.com
# Modified by: Amit Halkhoree, amithalkhoree@gmail.com
#
# This file is part of KrakenTools.
# KrakenTools is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the license, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see <http://www.gnu.org/licenses/>.
#
####################################################################
# Updated: 26/07/2024
#
# This program reads multiple files in the MetaPhlAn (mpa) format
# (as output from kreport2mpa.py) and combines them into a single
# CSV or MPA file. Each line represents a possible taxon classification.
# The first column lists the domain, kingdom, phyla, etc., leading up
# to each taxon. The levels are separated by the | delimiter, with the
# type of level specified before each name with a single letter and
# underscore (d_ for domain, k_ for kingdom, etc). The second column
# is the number of reads classified within that taxon's subtree.
#
# Input files:
#   - MetaPhlAn format (mpa-format) files with two columns
#   - All files must be generated from the same database, with the same
#     options from kreport2krona.py or errors may occur
#
# Input Parameters to Specify [OPTIONAL]:
#   - header_line = prints a header line in mpa-report
#       [Default: no header]
#   - intermediate-ranks = includes non-traditional taxon levels
#       (traditional levels: domain, kingdom, phylum, class, order,
#       family, genus, species)
#       [Default: no intermediate ranks]
#
# Output file format (tab-delimited or CSV):
#   - Taxonomy tree levels |-delimited, with level type [d,k,p,c,o,f,g,s,x]
#   - Number of reads within subtree of the specified level
#
# Methods:
#   - main
#
# Usage:
#   ./combine_mpa.sh -i <input_files_or_directory> -o <output_file>
#
# Example:
#   ./combine_mpa.sh -i /path/to/mpa_files_directory -o output.csv
#   ./combine_mpa.sh -i SAMPLEID1_INFO_INFO_INFO_mpa.txt SAMPLEID2_INFO_INFO_INFO_mpa.txt -o output.mpa
#
####################################################################


print_usage_and_exit() {
    echo "Usage: $0 -i <input_files_or_directory> -o <output_file>"
    exit 1
}

# Check if the correct number of arguments is provided
if [ "$#" -lt 4 ]; then
    print_usage_and_exit
fi

# Parse arguments
while getopts "i:o:" opt; do
    case $opt in
        i) input_arg="$OPTARG" ;;
        o) output_file="$OPTARG" ;;
        *) print_usage_and_exit ;;
    esac
done

# Determine if input is a directory or list of files
if [ -d "$input_arg" ]; then
    input_files=($(find "$input_arg" -type f -name "*_mpa.txt"))
else
    input_files=($input_arg)
fi

# Check if any input files were found
if [ ${#input_files[@]} -eq 0 ]; then
    echo "No input files found."
    exit 1
fi

# Initialize variables
temp_dir=$(mktemp -d)
sample_count=0
samples=()

echo "Number of files to parse: ${#input_files[@]}"

# Process each file
for in_file in "${input_files[@]}"; do
    echo "Processing file: $in_file"
    sample_count=$((sample_count + 1))
    sample_name=$(basename "$in_file" | sed 's/_mpa.txt$//')
    samples+=("$sample_name")
    awk -v sample_count="$sample_count" -F'\t' '{
        if ($1 !~ /^#/) {
            print $1 "\t" sample_count "\t" $2
        }
    }' "$in_file" >> "$temp_dir/classifications.txt"
done

echo "Number of classifications to write: $(wc -l < "$temp_dir/classifications.txt")"
echo -ne "\t0 classifications printed"

# Sort and process classifications
sort -k1,1 -k2,2n "$temp_dir/classifications.txt" > "$temp_dir/sorted_classifications.txt"

# Determine output format
output_format="mpa"
if [[ "$output_file" == *.csv ]]; then
    output_format="csv"
fi

# Write output
if [ "$output_format" == "csv" ]; then
    {
        echo -n "Classification"
        for sample in "${samples[@]}"; do
            echo -n ",$sample"
        done
        echo ""

        prev_classification=""
        counts=()
        while IFS=$'\t' read -r classification sample_idx val; do
            if [[ "$classification" != "$prev_classification" && -n "$prev_classification" ]]; then
                echo -n "$prev_classification"
                for ((i=1; i<=sample_count; i++)); do
                    echo -n ",${counts[$i]:-0}"
                done
                echo ""
                counts=()
            fi
            counts[$sample_idx]=$val
            prev_classification="$classification"
        done < "$temp_dir/sorted_classifications.txt"

        # Print the last classification
        if [[ -n "$prev_classification" ]]; then
            echo -n "$prev_classification"
            for ((i=1; i<=sample_count; i++)); do
                echo -n ",${counts[$i]:-0}"
            done
            echo ""
        fi
    } > "$output_file"
else
    {
        echo -n "#Classification"
        for sample in "${samples[@]}"; do
            echo -n -e "\t$sample"
        done
        echo ""

        prev_classification=""
        counts=()
        while IFS=$'\t' read -r classification sample_idx val; do
            if [[ "$classification" != "$prev_classification" && -n "$prev_classification" ]]; then
                echo -n "$prev_classification"
                for ((i=1; i<=sample_count; i++)); do
                    echo -n -e "\t${counts[$i]:-0}"
                done
                echo ""
                counts=()
            fi
            counts[$sample_idx]=$val
            prev_classification="$classification"
        done < "$temp_dir/sorted_classifications.txt"

        # Print the last classification
        if [[ -n "$prev_classification" ]]; then
            echo -n "$prev_classification"
            for ((i=1; i<=sample_count; i++)); do
                echo -n -e "\t${counts[$i]:-0}"
            done
            echo ""
        fi
    } > "$output_file"
fi

# Clean up
rm -r "$temp_dir"

echo -e "\r\t$(wc -l < "$temp_dir/sorted_classifications.txt") classifications printed"
echo "Output written to $output_file"
