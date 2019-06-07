#!/bin/bash
# Split a fastq file based on read header information.
# Outputs as a gzipped fastq file.

if [[ $# -lt 3 ]]; then
    echo "Usage: $(basename $0) fastq prefix outputdir"
    false
fi

FQ=$1
SM=$2
OUTDIR=$3

if [[ $FQ == *.gz ]]; then
    CAT=zcat
elif [[ $FQ == *.fastq ]]; then
    CAT=cat
else
    exit 1
fi

if [[ $FQ =~ (.R1|_R1|_r1|_1)(|_001).f(|ast)q(|.gz) ]]; then
    RD=R1
elif [[ $FQ =~ (.R1|_R1|_r1|_1)(|_001).f(|ast)q(|.gz) ]]; then
    RD=R2
else
    exit 1
fi

printf -- "---\n[$(date)] Start split fastq: $FQ\n"

$CAT $FQ |paste - - - - |awk -F"\t" -v SM=$SM -v RD=$RD '{
    h=$1;
    sub(/^@/,"",h);
    sub(/ .+$/,"",h);
    l=split(h,arr,":");
    FCX=arr[l-4];
    LN=arr[l-3];
    print $1"\n"$2"\n+\n"$4|"gzip > "OUTDIR"/"SM"."FCX"_L"LN"."RD".fastq.gz"}
    END {
    print "READ N: "NR}'

printf -- "[$(date)] Finish split fastq: $FQ\n---\n"
