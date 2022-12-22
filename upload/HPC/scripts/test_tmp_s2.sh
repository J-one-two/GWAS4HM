#!/bin/bash
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=8
#SBATCH --mem-per-cpu=20G
#SBATCH -o /home/c.c2090628/HipSTR/scripts/HighM/outputs/Cap_JT_second_%A_%a-%J.log
#SBATCH -e /home/c.c2090628/HipSTR/scripts/HighM/outputs/Cap_JT_second_%A_%a-%J.err
#SBATCH -J cap_sec
#SBATCH -p htc
#SBATCH --time=2-0:0

#----------------------------------------------------------------------------------------------------
#task1: 1st-step hipstr to screen all STRs in 22 chromosomes with 200 participants 

#----------------------------------------------------------------------------------------------------
#task2: decompress all of the .vcf.gz and merge the terms together; split into small .bed files

#----------------------------------------------------------------------------------------------------
#task3: second-step hipstr with all polymorhpic STRs and 8808 participants

chr=X

mylist="/home/c.c2090628/HipSTR/scripts/HighM/samples/sample_HM_all.tmp"
post_split_file="/home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/Post_Split_STR_chr${chr}_"
mkdir /scratch/c.c2090628/Output/CHR_$chr/second

arr=($(ls ${post_split_file}*.bed | wc))
group_num=${arr[0]}

bedfiles=($(ls /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/Post_Split_STR_chr${chr}_*.bed | wc))
bed_num=${bedfiles[0]}
k=1
while [ $k -le ${group_num} ]
 do
   run_num=$(squeue -u c.c2090628 | grep "second" | wc | awk '{print $1}')
   if [[ ${run_num} -lt 15 ]]  #we set 15 because 20 is the maximum number of submission for the highmem partition
   then
   sbatch -A scw1193 /home/c.c2090628/HipSTR/scripts/HighM/scripts/hipstr_HM_secondary.sh "$k" "$chr"
   ((k++))
   fi
	sleep 1
 done



#----------------------------------------------------------------------------------------------------
#task4: decompress the secondary .vcf.gz files, merge together and delete redundance

#----------------------------------------------------------------------------------------
#task5: Combine the genotype and phenotype together

