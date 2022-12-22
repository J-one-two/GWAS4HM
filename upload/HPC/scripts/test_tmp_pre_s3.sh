# create a list for name-change process of genotype files, from random index to standard UKBiobank index
cd /scratch/c.c2090628/Output

filename_origin="/scratch/scw1193/WES_HMvHH/*.cram"
outputfile="/scratch/c.c2090628/Output/HM_SubjectsID.txt"

ls $filename_origin  > file1.tmp
array=($(cat file1.tmp))

for filename in ${array[@]}
do

/home/c.c2090628/samtools-1.12/samtools-1.12/samtools \
 view $filename | head -n 1 | awk '{print $NF}' | awk -F "[:/.]" '{print $3}'

done > file2.tmp

awk -F "/" '{print $5}' file1.tmp | awk -F "_" '{print $1}' > file3.tmp

echo "Subjects_ID       ID" > $outputfile
paste file2.tmp file3.tmp >> $outputfile
