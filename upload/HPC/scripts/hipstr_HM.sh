#!/bin/sh
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=40G
#SBATCH -o /home/c.c2090628/HipSTR/scripts/HighM/outputs/hipstr_output.log
#SBATCH -e /home/c.c2090628/HipSTR/scripts/HighM/outputs/hipstr_output.err
#SBATCH -J first
#SBATCH -p compute
#SBATCH --time=1:00:00

cd /home/c.c2090628/HipSTR/scripts/HighM/outputs

chr=$1
bed=$2

mylist="/home/c.c2090628/HipSTR/scripts/HighM/samples/Participants/sample_HM_rand.tmp"
myfasta="/scratch/scw1193/WES_200k/GRCh38_full_analysis_set_plus_decoy_hla.fa"


/home/c.c2090628/HipSTR/HipSTR \
   --bam-files     ${mylist} \
   --fasta         ${myfasta} \
   --regions       /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/STR_chr${chr}_${bed}.bed \
   --min-reads     1000 \
   --max-reads     90000 \
   --str-vcf       /scratch/c.c2090628/Output/CHR_${chr}/highmyopia_chr${chr}_calls_${bed}.vcf.gz 
