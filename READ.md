 DataStorage
 |--download/
 | |--GRCh38.hipstr_reference.bed.gz
 | |--*.cram
 | |--GRCh38_full_analysis_set_plus_decoy_hla.fa
 | °--samtools-1.12/samtools-1.12/samtools
 |--Output/
 | |--CHR_$chr/
 | | |--highmyopia_chr${chr}_calls_${bed}.vcf.gz
 | | |--highmyopia_chr${chr}_calls_*.vcf
 | | |--presec/
 | | | |--Output_Human_STR_List.txt
 | | | |--Mid_genotype.tmp
 | | | |--HM_calls_all_presec.txt
 | | | |--HM_chr${chr}_presec.vcf
 | | | |--Output_Human_STR_genotype.txt
 | | | |--${str}.txt
 | | | |--${str}_count.txt
 | | | °--${str}_sorts.txt
 | | °--second/
 | | |--Mid_genotype.tmp
 | | |--HM_chr${chr}_calls_secondary_${bed}.vcf.gz
 | | |--Output_Human_STR_genotype.txt
 | | |--HM_calls_all_secondary.txt
 | | |--${str}.txt
 | | |--${str}_count.txt
 | | |--${str}_sorts.txt
 | | °--HM_CHR${chr}_Output_final.txt
 | °--HM_SubjectsID.txt
 |--samples/
 | |--WholeBedFile/
 | | |--STR_chr${chr}_*.bed
 | | °--postsplit/
 | | |--post_screening_chr${chr}.bed
 | | °--Post_Split_STR_chr${chr}_*.bed
 | °--sample_HM_all.tmp
 |--scripts/
 | |--test_tmp_s1.sh
 | |--index_cram_file.sh
 | |--fun_chr_split.sh
 | |--fun_chr_split_chrX.sh
 | |--hipstr_HM.sh
 | |--hipstr_HM_secondary.sh
 | |--hipstr_HM_presec.sh
 | |--test_pres2.sh
 | °--mini_scripts/
 | |--post_output_check.sh
 | |--count_STR_num.sh
 | |--count_split_bed.sh
 | |--count_STR_num_secondary.sh
 | |--count_split_bed_secondary.sh
 | |--backup_scr.sh
 | |--create_sample_list.sh
 | °--bed_sample_rand.sh
 |--Dialog/
 | |--hipstr_output.log(.err)
 | |--BedSplit_JT_%A_%a-%J.log(.err)
 | |--pres2_JT_%A_%a-%J.log(.err)
 | |--Cap_JT_second_%A_%a-%J.log(.err)
 | |--hipstr_JT_second_%A_%a-%J.log(.err)
 | °--Cap_JT_third_%A_%a-%J.log(.err)
 |--R_scripts/
 | °--ukb_seq_200k_HM_select_sample.R
 °--localPC/
    °--first_sep.R
