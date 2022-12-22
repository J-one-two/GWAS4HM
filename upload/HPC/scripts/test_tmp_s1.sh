#!/bin/bash
#SBATCH --ntasks=8
#SBATCH --ntasks-per-node=8
#SBATCH --mem-per-cpu=20G
#SBATCH -o /home/c.c2090628/HipSTR/scripts/HighM/outputs/Cap_JT_%A_%a-%J.log
#SBATCH -e /home/c.c2090628/HipSTR/scripts/HighM/outputs/Cap_JT_%A_%a-%J.err
#SBATCH -J captain
#SBATCH -p compute
#SBATCH --time=24:00:00

#----------------------------------------------------------------------------------------------------
#task1: 1st-step hipstr to screen all STRs in 22 chromosomes with 200 participants 
cd /home/c.c2090628/HipSTR/scripts/HighM

chr=X
mkdir -p /scratch/c.c2090628/Output/CHR_$chr #if the directory doesn't exist, then create one

 bedfiles=($(ls  /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/STR_chr${chr}_*.bed | wc))
 bed_num=${bedfiles[0]}
 k=1
 while [ $k -le ${bed_num} ]
 do
	run_num=$(($(squeue -u c.c2090628 | wc | awk '{print $1}')-1))
        if [[ ${run_num} -lt 50 ]]
	then
 	sbatch -A scw1193 /home/c.c2090628/HipSTR/scripts/HighM/scripts/hipstr_HM.sh "$chr" "$k"
        ((k++))
	fi
 done

# pause the program until scripts are done
sign=0
while [ $sign -eq 0 ]
do
   sleep 5
   num=($(squeue -u c.c2090628 | awk '{print $3}' | grep 'first' | wc))
   if [[ ${num[0]} -eq 0 ]]
   then
   sign=1
   fi
done

#----------------------------------------------------------------------------------------------------
#task2: decompress all of the .vcf.gz and merge the terms together; split into small .bed files

cd /scratch/c.c2090628/Output/CHR_$chr
post_file="/home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/post_screening_chr${chr}.bed"
post_split_file="/home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/Post_Split_STR_chr${chr}_"

for i in highmyopia*.vcf.gz;
   do
     gunzip -c $i > ${i%.*};
   done

grep -i 'Human_STR'  highmyopia_chr*_calls_*.vcf > highmyopia_calls_all.txt

awk '{print $3}' highmyopia_calls_all.txt > Output_HM_Human_STR_List.txt

gunzip -c /scratch/scw1193/WES_200k/GRCh38.hipstr_reference.bed.gz > file.tmp

grep -wf Output_HM_Human_STR_List.txt file.tmp > ${post_file}


wordcnt=$(wc ${post_file})
arr=($wordcnt)
group_num=$((${arr[0]}/100+1))
iteract_num=$(($group_num-1))

k=0
while [ $k -le ${iteract_num} ]
  do
        a=$((100*$k+1))
        cat ${post_file} | tail -n +$a | head -n 100 > ${post_split_file}$(($k+1)).bed
        ((k++))
  done

echo "the num of .vcf files for chr${chr} after 1st-step HipSTR is:"
echo $(ls /scratch/c.c2090628/Output/CHR_$chr/highmyopia_chr${chr}_calls_*.vcf | wc | awk '{print $1}')
echo "the num of STRs for chr${chr} after 1st-step HipSTR is:"
echo $(wc /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/post_screening_chr${chr}.bed | awk '{print $1}')
