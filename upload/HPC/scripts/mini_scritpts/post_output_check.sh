#function: check the correctness of the final output file 

chr=19

echo "file path of the final output file is:"
echo "/scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt"

echo "the num of rows of the output file is:"
wc /scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt | awk '{print $1}'

echo "the num of columns for the first line is:"
head -n 1 /scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt | wc | awk '{print $2}'

echo "the num of columns for the second line is:"
head -n 2 /scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt | tail -n 1 | wc | awk '{print $2}'

echo "the num of columns for the last line is:"
tail -n 1 /scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt | wc | awk '{print $2}'

num_STR=$(wc /scratch/c.c2090628/Output/CHR_$chr/second/Output_Human_STR_List.txt | awk '{print $1}')
name_STR=($(cat /scratch/c.c2090628/Output/CHR_$chr/second/Output_Human_STR_List.txt))

echo "the genotypic information of first STR is:"
awk '{print $2}' /scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt | sort | uniq > file1.tmp
awk '{print $3}' /scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt | sort | uniq > file2.tmp
paste file2.tmp file1.tmp | column -t 

echo "the genotypic information in ${name_STR[0]}_markers.txt is"
cat /scratch/c.c2090628/Output/CHR_$chr/second/${name_STR[0]}_markers.txt

num1=$((2*$num_STR))
num2=$((2*$num_STR+1))
echo "the genotypic information of last STR is:"
awk -v num=$num1 '{print $num}' /scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt | sort | uniq > file1.tmp
awk -v num=$num2 '{print $num}' /scratch/c.c2090628/Output/CHR_${chr}/second/HM_CHR${chr}_Output_final.txt | sort | uniq > file2.tmp
paste file2.tmp file1.tmp | column -t 

echo "the genotypic information in ${name_STR[$(($num_STR-1))]}_markers.txt is"
cat /scratch/c.c2090628/Output/CHR_$chr/second/${name_STR[$(($num_STR-1))]}_markers.txt

_now=$(date +"%Y-%m-%d")
filepath="/scratch/c.c2090628/Output/CHR_${chr}/second"
filename="HM_CHR${chr}_Output_final.txt"
outputpath="/home/c.c2090628/output"

NAME=${filename%.*}
EXT="csv"

echo -n "Would you like to output the file into the Output folder?[y/n]"
read -r ans
if [[ "$ans" == "y" ]] 
then
	cat ${filepath}/$filename > $outputpath/${NAME}_${_now}.${EXT}
	echo -n "successfully output the file to: "
	ls $outputpath/${NAME}_${_now}.${EXT}
else
	echo "quit the programme without saving"
fi
