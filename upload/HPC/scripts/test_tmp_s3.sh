#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem-per-cpu=40G
#SBATCH -o /home/c.c2090628/HipSTR/scripts/HighM/outputs/Cap_JT_third_%A_%a-%J.log
#SBATCH -e /home/c.c2090628/HipSTR/scripts/HighM/outputs/Cap_JT_third_%A_%a-%J.err
#SBATCH -J cap_thrd
#SBATCH -p htc
#SBATCH --time=1-0:0

#----------------------------------------------------------------------------------------------------
#task1: 1st-step hipstr to screen all STRs in 22 chromosomes with 200 participants 

#----------------------------------------------------------------------------------------------------
#task2: decompress all of the .vcf.gz and merge the terms together; split into small .bed files

#----------------------------------------------------------------------------------------------------
#task3: second-step hipstr with all polymorhpic STRs and 4080 participants

#----------------------------------------------------------------------------------------------------
#task4: decompress the secondary .vcf.gz files, merge together and delete redundance

chr=19
cd /scratch/c.c2090628/Output/CHR_$chr/second


filename="/scratch/c.c2090628/Output/CHR_$chr/second/Output_Human_STR_List.txt"
midfile="/scratch/c.c2090628/Output/CHR_$chr/second/Mid_genotype.tmp"
touch $midfile
>$midfile
finalfile="/scratch/c.c2090628/Output/CHR_$chr/second/Output_Human_STR_genotype.txt"
mid_calls_file="/scratch/c.c2090628/Output/CHR_$chr/second/HM_calls_all_secondary.txt"
vcffile="/scratch/c.c2090628/Output/CHR_${chr}/second/HM_chr${chr}_calls_secondary_"

for i in ${vcffile}*.vcf.gz
   do
     gunzip -c $i > ${i%.*};
   done

grep -w "chr${chr}"  ${vcffile}*.vcf > file.tmp
grep -i 'Human_STR' file.tmp > ${mid_calls_file}

grep -i 'Human_STR_' ${mid_calls_file} | awk '{print $3}' > ${filename}


#make a title for all the STRs as well as participants

echo "Subjects_ID" > file.tmp
while read -r line; do echo "${line}_1"; echo "${line}_2" ; done < ${filename} >> file.tmp

paste -sd "\t" file.tmp > ${finalfile}
> file.tmp

cnt=$(cat ${filename})
array=(${cnt})

for k in "${array[@]}"
do
 str=$(echo "$k")
 line=$(grep -w ${str} ${mid_calls_file})
 arr=($line)

 for i in "${arr[@]}"
 do
        echo $i
 done | tail -n +10 | awk -F ':' '{print $1}' > file.tmp
 sed -i -e "s/.*\..*/NA|NA/" file.tmp

 awk -F '|' '{print $1,$2}' file.tmp > ${str}.txt

# make a list of the different length for each STR
 line2=$(grep -w ${str} ${mid_calls_file})
 arr2=($line2)
 for n in {3,4}
 do
        echo ${arr2[$n]}
 done  > file2.tmp
 head -n 1 file2.tmp > ${str}_sorts.txt

 line2=$(tail -n 1 file2.tmp)
 IFS=',' read -r -a arr2 <<< $line2
 for n in ${arr2[@]}
 do
        echo "$n"
 done >> ${str}_sorts.txt

 while read -r line
 do
    wordcnt=$(echo "$line"| wc -c);
    echo $((wordcnt-1))
 done < ${str}_sorts.txt > ${str}_count.txt #don't forget to minus 1 for each length afterward

#change the markers into length_letter
 sort ${str}_count.txt | uniq -c | awk '{print $2 "\t" $1}' > file4.tmp
 arr4=($(awk '{print $2}' file4.tmp))
 cat  ${str}_count.txt |  while read -r ll
 do
      index=$(awk '{print $1}' file4.tmp | grep -w $ll -n | awk -F ':' '{print $1}')
      ((index-=1))
      num=${arr4[$index]}
      ltr=$((num+64))
      name=$(awk '{print $1}' file4.tmp | grep -i $ll | awk '{print $1}')
      echo "$name $ltr" | awk '{printf "%s_%c\n", $1, $2}'
      ((arr4[$index]-=1))

  done > ${str}_markers.txt

# replace genotype code with motif lengths
 line=$(wc -l ${str}_markers.txt)
 arr3=($line)
 sum=$((${arr3[0]}-1))
 line=$(cat ${str}_markers.txt)
 arr3=($line)
 cat ${str}.txt > file3.tmp
 for n in {0..250}
 do
 ll=${arr3[$n]}
 awk -v ll=$ll -v n=$n '$1==n {$1=ll} {print $1}' file3.tmp > file1.tmp
 awk -v ll=$ll -v n=$n '$2==n {$2=ll} {print $2}' file3.tmp > file2.tmp
 paste file1.tmp file2.tmp > file3.tmp
 done
 cat file3.tmp > ${str}.txt
 paste ${midfile} ${str}.txt > file.tmp
 cat file.tmp > ${midfile} 

done

#generate ID list

 line=$(grep -i '#CHROM' ${vcffile}1.vcf)
 arr=($line)


for i in ${arr[@]}
do
        echo "$i"
done | tail -n +10 > subjects.tmp

paste subjects.tmp $midfile > file.tmp
cat file.tmp >> ${finalfile}

#----------------------------------------------------------------------------------------
#task5: Combine the genotype and phenotype together

cd /scratch/c.c2090628/Output/CHR_$chr/second

filename_1="/scratch/c.c2090628/Output/CHR_$chr/second/Output_Human_STR_genotype.txt"
filename_2="/scratch/scw1193/WES_HMvHH/ukb_seq_HMvHH_phens_2021-10-09.txt"
filename_3="/scratch/scw1193/WES_HMvHH/*.cram"
filename_4="/scratch/c.c2090628/Output/HM_SubjectsID.txt"
filename_output="/scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt"


#Change names into real ID and combine phenotype and genotype 
head -n 1 $filename_1 > file1.tmp
join <(sort $filename_4) <(sort $filename_1) | awk '!($1="")' >> file1.tmp

line1=$(head -n 1 file1.tmp )
line2=$(head -n 1 $filename_2 | awk '!($1="")')

echo "${line1} ${line2}" > file2.tmp
join <(sort file1.tmp) <(sort $filename_2) >> file2.tmp

cp file2.tmp $filename_output

