#function: count the numbers of splited .bed files for each chr after first-step HipSTR and splitting
for i in {1..22}; do ls /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/Post_Split_STR_chr*_*.bed | grep "_chr${i}_" | wc | awk '{print $1}'
done

i=X
ls /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/Post_Split_STR_chr*_*.bed | grep "_chr${i}_" | wc | awk '{print $1}'

