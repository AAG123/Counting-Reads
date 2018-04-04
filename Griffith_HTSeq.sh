#!/bin/bash

#Run HTseq union mode on paired end Griffith Data. 
#I recall that this script does not play well as a qsub. run in interactive node as a general bash script

set -euxo pipefail

module load enthought_python/7.3.2
module load samtools/1.3

echo "You're counting reads on  $HOSTNAME"

#PATHS TO WHAT YOU NEED FOR HTSEQ:

## Path to all reference files
REF_DIR=/data/users/$USER/BioinformaticsSG/griffith_data/refs

## Path to the annotation file
REF_ANNOTATION=${REF_DIR}/chr22.ERCC92.gtf

##the desired output directory for the count files
COUNTS_DIR=/data/users/$USER/BioinformaticsSG/Review/griffith_analysis_demo/counts

#Directory containing the alignment files
ALIGNMENTS_DIR=/data/users/$USER/BioinformaticsSG/Review/griffith_analysis_demo/alignments/
##the list of alignment files you want to perform read counting on, saved in a txt file that you made interactively by following the follow-along guide
ALIGNMENTS_FILENAMES=/data/users/$USER/BioinformaticsSG/Review/griffith_analysis_demo/alignments/HBR_alignments_filenames.txt

##use this basename to help name the output files
BASENAME="HBR"

#detect the number of samples by printing out the list of alignment file names. then count the lines that print out. There are 3 in this case 
sample_count=$(cat ${ALIGNMENTS_FILENAMES} | wc -l)

#####################

# Iterate over each sample

for SAMPLE_N in $(seq ${sample_count}); do

    # Build the name of the files.
    ALIGNED_READS=$(head -n ${SAMPLE_N} ${ALIGNMENTS_FILENAMES} | tail -n 1)

    # Run HTSeq
        echo "Counting ${ALIGNED_READS}"


#python -m HTSeq.scripts.count [options] <alignment_files> <gff_file>
python -m HTSeq.scripts.count --order=pos --format=bam --stranded=no --type=exon --idattr=gene_id --mode=union \
--samout=${COUNTS_DIR}/${BASENAME}_${SAMPLE_N}.sam ${ALIGNED_READS} ${REF_ANNOTATION} > ${COUNTS_DIR}/${BASENAME}_${SAMPLE_N}.counts.out


        echo "Counting of ${ALIGNED_READS} complete"
done


#NOTES:
#python -m HTSeq.scripts.count [options] <alignment_files> <gff_file>
#python -m HTSeq.scripts.count --order=pos \ #Star output is sorted by coordinate according to the file name. default is ordere by "name"
#--format=bam \ #format of the input alignments
#--max-reads-in-buffer=30000000 \ #30000000 is the default value. only relevant when alignment file is paired end and sorted by position.
#--stranded=yes \ #are your samples stranded or not? for paired end, first read must be on same strand and second read on opposite strand
#--type=exon \ #feature type, found in 3rd column of annotation file
#--idattr=gene_id \ #id attribute used as a feature ID
#--additional-attr=gene_name \ #using an Ensembl GTF file, this will get you an additional column containing the gene name.
#--mode=union  \ #this mode is what STAR counts mimics. this is the default setting in HTSeq
#--nonunique=none \ #this is the default. mode to handle reads that align to or are assigned to more than one feature in overlap
#--samout=${COUNTS_DIR}/${BASENAME}_${SAMPLE_N}.sam \
#${ALIGNED_READS} \ #input file
#${REF_ANNOTATION} #The annotation file, usually a gtf that contains the gene annotations you desire to be detected




