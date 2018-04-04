#!/bin/bash

#Trim off bottom count text on all files in a directory

set -euxo pipefail


for file in `*starReadsPerGene.out.tab`; do
       	#cat ${file} | grep -v -E 'no_feature|ambiguous|too_low_aQual|not_aligned|alignment_not_unique' > ${file}.2.txt; #for HTseq
        cat ${file} | grep -v -E 'N_unmapped|N_ambiguous|N_multimapping|N_noFeature' > ${file}.txt; #for star

done
 
