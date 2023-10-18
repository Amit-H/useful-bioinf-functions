 #!/bin/bash

# DESCRIPTION: This script makes a tsv summary of HISAT2 logging files
# USAGE: Run this script inside the hisat.dir output folder where the hisat bam.log files are located. 
# OUTPUT: combined_log.tsv 

for f in *.log
    do 
        echo -n $f | echo -n $(cut -d'.' -f1) && echo -ne '\t' && tail -1 $f | echo -n $(cut -d% -f1) && echo -ne '\t' && sed -n 2p $f | echo -n $(cut -d' ' -f 1) && echo -ne '\t' && sed -n 3p $f | echo -n $(cut -d' ' -f 3) && echo -ne '\t' && sed -n 4p $f | echo -n $(cut -d' ' -f 5) && echo -ne '\t' && sed -n 5p $f | echo -n $(cut -d' ' -f 5) && echo -ne '\t' && sed -n 6p $f | echo -n $(cut -d' ' -f 5) && echo -ne '\t' && sed -n 8p $f | echo -n $(cut -d' ' -f 5) && echo -ne '\t' && sed -n 9p $f | echo -n $(cut -d' ' -f 7) && echo -ne '\t' && sed -n 11p $f | echo -n $(cut -d' ' -f 5) && echo -ne '\t' && sed -n 12p $f | echo -n $(cut -d' ' -f 7) && echo -ne '\t' && sed -n 13p $f | echo -n $(cut -d' ' -f 9)  && echo -ne '\t' && sed -n 14p $f | echo -n $(cut -d' ' -f 9)  && echo -ne '\t' && sed -n 15p $f | echo -n $(cut -d' ' -f 9)
        echo -e '\n' 
    done | grep -v '^[[:space:]]*$' > log.tsv

echo -e "sample_ID\tPercentage Alignment\tTotal Reads\tNum Paired Reads\tNum Paired 0 concordant alignment\tNum Paired 1 concordant alignment\tNum Paired >1 concordant alignment\tNum Pairs Concordantly Aligned 0 Times\tNum Pairs which were condordnantly aligned 0 times which are disconcordantly aligned 1 time\tNum Pairs Algined 0 times concordantly or disconcordantly\tNum Pairs Aligned 0 times concordantly mate pairs\tNum Pairs Aligned 0 times concordantly mate pairs aligned 0 times\tNum Pairs Aligned 0 times concordantly mate pairs aligned 1 time\tNum Pairs Aligned 0 times concordantly mate pairs aligned >1 time" | cat  - log.tsv > combined_log.tsv
rm -rf log.tsv
