#function: create a sample list, eliminate the ones which are already known invalid

cd /home/c.c2090628/HipSTR/scripts/HighM/samples/

mylist_step1 = "/home/c.c2090628/HipSTR/scripts/HighM/samples/Participants/sample_HM_rand.tmp"

mylist_step2="/home/c.c2090628/HipSTR/scripts/HighM/samples/sample_HM_all.tmp"

ls /scratch/scw1193/WES_HMvHH/*.cram > file1.tmp

#randoly select 200 participants from all the individuals(8808 in this study)
shuf -n 200 file1.tmp > ${mylist_step1}

#copy all the individuals' .cram file address to the mylist_step2 file

cp file1.tmp ${mylist_step2}
