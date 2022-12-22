#!/bin/bash
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=40G
#SBATCH -o /home/c.c2090628/HipSTR/scripts/HighM/outputs/BedSplit_JT_%A_%a-%J.log
#SBATCH -e /home/c.c2090628/HipSTR/scripts/HighM/outputs/BedSplit_JT_%A_%a-%J.err
#SBATCH -J bedsplit_JT
#SBATCH -p compute
#SBATCH --time=24:00:00

# Exclusively for chrX: split the whole genome BED file into smaller-sized files, which only have 100 STRs in each file.
cd /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile

  chr=X
  wordcnt=$(gunzip -c /scratch/scw1193/WES_200k/GRCh38.hipstr_reference.bed.gz | awk -v chr="chr$chr" '{if($1==chr) print $0}' | wc)
  arr=($wordcnt)
  group_num=$((${arr[0]}/100+1))
  
  k=1
  while [ $k -le ${group_num} ]
  do
	a=$((100*$(($k-1))+1))
 	gunzip -c /scratch/scw1193/WES_200k/GRCh38.hipstr_reference.bed.gz | awk  -v chr="chr$chr" '{if($1==chr) print $0}' | tail -n +$a | head -n 100 > STR_chr${chr}_${k}.bed
	((k++))
  done
