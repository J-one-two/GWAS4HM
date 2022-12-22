
#function: count the number of STRs for each chr in the original .bed file
for i in {1..22}; do gunzip -c /scratch/scw1193/WES_200k/GRCh38.hipstr_reference.bed.gz | grep -w "chr${i}" | wc | awk '{print $1}'; done

i=X
gunzip -c /scratch/scw1193/WES_200k/GRCh38.hipstr_reference.bed.gz | grep -w "chr${i}" | wc | awk '{print $1}'

