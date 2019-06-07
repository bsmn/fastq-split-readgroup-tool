#!/usr/bin/env bash
# Split a fastq file based on read header information.
#
# Assumes the format of the header is:
# @<machine>:<run>:<flowcell>:<lane>:<tile><x_coord>:<y_coord> <read_mate_number>:<vendor_filtered>:<bits>:<barcode>
#
# Outputs as a gzipped fastq file. Output prefix will be used for the output files 
# created which will be of the form <prefix><flowcell>_<lane>_R<1/2>.fastq.gz

set -o errexit
set -o nounset
set -o pipefail

if [[ $# -lt 2 ]]; then
    echo "Usage: $(basename $0) fastq prefix"
    false
fi

FASTQ=$1
OUTPREFIX=$2

set -o errexit
set -o nounset
set -o pipefail

if [[ "${FASTQ}" = *.gz ]]; then
    CAT=zcat
elif [[ "${FASTQ}" = *.fastq ]]; then
    CAT=cat
else
    printf "Not a fastq or gzip file, exiting."
    false
fi

printf -- "[$(date)] Start split fastq: ${FASTQ}\n"

${CAT} ${FASTQ} | paste - - - - | awk -F"\t" -v OUTPREFIX=${OUTPREFIX} '{
    header=$1;
    sub(/^@/,"",header);

    x = split(header, arr1, " ");
    part1 = arr1[1];
    part2 = arr1[2];

    l = split(part1, arr2, ":");
    FLOWCELL = arr2[3];
    LANE = arr2[4];
    
    m = split(part2, arr3, ":")
    READ = arr3[1];

    print $1 "\n" $2 "\n" $3 "\n" $4 > OUTPREFIX "_" FLOWCELL "_" LANE "_R" READ ".fastq.gz"}'


printf -- "[$(date)] Finish split fastq: ${FASTQ}\n---\n"
