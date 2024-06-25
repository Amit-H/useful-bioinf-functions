#!/bin/bash

: '
This script processes multiple mpa tables in a specified directory and generates a CSV file.
The CSV file has samples on the Y-axis and classifications on the X-axis, with each record being the count.

Usage:
    ./generate_csv.sh <input_directory> <output_file>

Arguments:
    input_directory: The directory containing the mpa tables.
    output_file: The path to the output CSV file.

Example:
    ./generate_csv.sh /path/to/your/input_directory /path/to/your/output_file.csv
'

print_usage_and_exit() {
    echo "Usage: $0 <input_directory> <output_file>"
    exit 1
}

if [ "$#" -ne 2 ]; then
    print_usage_and_exit
fi

input_dir="$1"
output_file="$2"
temp_classifications="temp_classifications.txt"
sorted_classifications="sorted_classifications.txt"

> "$temp_classifications"

total_files=$(ls -1 "$input_dir" | wc -l)
current_file=0

for file in "$input_dir"/*; do
    awk '{print $1}' "$file" >> "$temp_classifications"
    current_file=$((current_file + 1))
    echo -ne "Processing files: $current_file/$total_files\r"
done

sort -u "$temp_classifications" > "$sorted_classifications"

{
    echo -n "Sample"
    while read -r classification; do
        echo -n ",$classification"
    done < "$sorted_classifications"
    echo ""
} > "$output_file"

current_file=0

for file in "$input_dir"/*; do
    sample_name=$(basename "$file")
    {
        echo -n "$sample_name"
        while read -r classification; do
            count=$(grep -w "$classification" "$file" | awk '{print $2}')
            [ -z "$count" ] && count=0
            echo -n ",$count"
        done < "$sorted_classifications"
        echo ""
    } >> "$output_file"
    current_file=$((current_file + 1))
    echo -ne "Writing to CSV: $current_file/$total_files\r"
done

rm "$temp_classifications" "$sorted_classifications"

echo -e "\nCSV file created: $output_file"
