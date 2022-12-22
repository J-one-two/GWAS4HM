#!/bin/sh
#SBATCH --ntasks=4
#SBATCH --ntasks-per-node=4
#SBATCH --mem-per-cpu=40G
#SBATCH -o /home/c.c2090628/HipSTR/scripts/HighM/outputs/index_JT_%A_%a-%J.log
#SBATCH -e /home/c.c2090628/HipSTR/scripts/HighM/outputs/index_JT_%A_%a-%J.err
#SBATCH -J index
#SBATCH -p compute
#SBATCH --time=20:00:00

#function: load samtools and index the .cram files in /scratch/scw1193/WES_HMvHH/
module load samtools

list=(/scratch/scw1193/WES_HMvHH/*.cram)

for k in ${list[@]}
do
	if samtools index $k; then
	echo "$k has been successfully indexed"
	else 
 	echo "failed to index $k"
	fi
done
