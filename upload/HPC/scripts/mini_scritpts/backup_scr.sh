#function: backup the all scripts in one command
cd /home/c.c2090628/HipSTR/scripts/HighM/scripts

_now=$(date +"%Y-%m-%d")
filepath="/home/c.c2090628/HipSTR/scripts/HighM/scripts/backup/backup_$_now/"
mkdir -p $filepath

for filename in *.sh
do
	NAME=${filename%.*}
	EXT=${filename#*.}
	cp $filename $filepath
done

cp -R ./mini_scripts $filepath
