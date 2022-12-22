
#function: count the number of STRs for each chr in the original after 2-step HipSTR
for chr in {1..22}; do wc /scratch/c.c2090628/Output/CHR_$chr/second/Output_Human_STR_List.txt | awk '{print $1}'; done

chr=X
wc /scratch/c.c2090628/Output/CHR_$chr/second/Output_Human_STR_List.txt | awk '{print $1}'

