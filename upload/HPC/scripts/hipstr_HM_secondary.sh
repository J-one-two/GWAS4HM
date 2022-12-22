#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=250G
#SBATCH -o /home/c.c2090628/HipSTR/scripts/HighM/outputs/hipstr_JT_second_%A_%a-%J.log
#SBATCH -e /home/c.c2090628/HipSTR/scripts/HighM/outputs/hipstr_JT_second_%A_%a-%J.err
#SBATCH -J second
#SBATCH -p highmem
#SBATCH --time=24:00:00

cd /home/c.c2090628/HipSTR/scripts/HighM/outputs

bed=$1
chr=$2

mylist="/home/c.c2090628/HipSTR/scripts/HighM/samples/sample_HM_all.tmp"
myfasta="/scratch/scw1193/WES_200k/GRCh38_full_analysis_set_plus_decoy_hla.fa"
myregions="/home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/Post_Split_STR_chr${chr}_${bed}.bed"
myout="/scratch/c.c2090628/Output/CHR_${chr}/second/HM_chr${chr}_calls_secondary_${bed}.vcf.gz"



/home/c.c2090628/HipSTR/HipSTR \
   --bam-files     ${mylist} \
   --fasta         ${myfasta} \
   --regions       ${myregions} \
   --min-reads     4200 \
   --max-reads     4200000 \
   --str-vcf       ${myout} 
