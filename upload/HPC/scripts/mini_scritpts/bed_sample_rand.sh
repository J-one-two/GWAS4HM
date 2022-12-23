#function: randomly select 50 STRs for a pre second step trial, in order to find the outlier sample with a extremely low call rate

cd /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/ 
chr=1
size=100

num=$(wc /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/post_screening_chr${chr}.bed | awk '{print $1}')
cp /home/c.c2090628/HipSTR/scripts/HighM/samples/WholeBedFile/postsplit/post_screening_chr${chr}.bed file1.tmp
shuf -i 1-$num -n $num > file2.tmp
paste file2.tmp file1.tmp > file3.tmp

sort -k1 file3.tmp | head -n $size | awk '{print $2,$3,$4,$5,$6,$7,$8}' > random_sample_chr${chr}.bed

