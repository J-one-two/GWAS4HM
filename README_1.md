1  DataStorage                                               
2   |--download/                                             
3   |   |--GRCh38.hipstr_reference.bed.gz                    
4   |   |--*.cram                                            
5   |   |--GRCh38_full_analysis_set_plus_decoy_hla.fa        
6   |   °--samtools-1.12/samtools-1.12/samtools              
7   |--Output/                                               
8   |   |--CHR_$chr/                                         
9   |   |   |--highmyopia_chr${chr}_calls_${bed}.vcf.gz      
10  |   |   |--highmyopia_chr${chr}_calls_*.vcf              
11  |   |   |--presec/                                       
12  |   |   |   |--Output_Human_STR_List.txt                 
13  |   |   |   |--Mid_genotype.tmp                          
14  |   |   |   |--HM_calls_all_presec.txt                   
15  |   |   |   |--HM_chr${chr}_presec.vcf                   
16  |   |   |   |--Output_Human_STR_genotype.txt             
17  |   |   |   |--${str}.txt                                
18  |   |   |   |--${str}_count.txt                          
19  |   |   |   °--${str}_sorts.txt                          
20  |   |   °--second/                                       
21  |   |       |--Mid_genotype.tmp                          
22  |   |       |--HM_chr${chr}_calls_secondary_${bed}.vcf.gz
23  |   |       |--Output_Human_STR_genotype.txt             
24  |   |       |--HM_calls_all_secondary.txt                
25  |   |       |--${str}.txt                                
26  |   |       |--${str}_count.txt                          
27  |   |       |--${str}_sorts.txt                          
28  |   |       °--HM_CHR${chr}_Output_final.txt             
29  |   °--HM_SubjectsID.txt                                 
30  |--samples/                                              
31  |   |--WholeBedFile/                                     
32  |   |   |--STR_chr${chr}_*.bed                           
33  |   |   °--postsplit/                                    
34  |   |       |--post_screening_chr${chr}.bed              
35  |   |       °--Post_Split_STR_chr${chr}_*.bed            
36  |   °--sample_HM_all.tmp                                 
37  |--scripts/                                              
38  |   |--test_tmp_s1.sh                                    
39  |   |--index_cram_file.sh                                
40  |   |--fun_chr_split.sh                                  
41  |   |--fun_chr_split_chrX.sh                             
42  |   |--hipstr_HM.sh                                      
43  |   |--hipstr_HM_secondary.sh                            
44  |   |--hipstr_HM_presec.sh                               
45  |   |--test_pres2.sh                                     
46  |   °--mini_scripts/                                     
47  |       |--post_output_check.sh                          
48  |       |--count_STR_num.sh                              
49  |       |--count_split_bed.sh                            
50  |       |--count_STR_num_secondary.sh                    
51  |       |--count_split_bed_secondary.sh                  
52  |       |--backup_scr.sh                                 
53  |       |--create_sample_list.sh                         
54  |       °--bed_sample_rand.sh                            
55  |--Dialog/                                               
56  |   |--hipstr_output.log(.err)                           
57  |   |--BedSplit_JT_%A_%a-%J.log(.err)                    
58  |   |--pres2_JT_%A_%a-%J.log(.err)                       
59  |   |--Cap_JT_second_%A_%a-%J.log(.err)                  
60  |   |--hipstr_JT_second_%A_%a-%J.log(.err)               
61  |   °--Cap_JT_third_%A_%a-%J.log(.err)                   
62  |--R_scripts/                                            
63  |   °--ukb_seq_200k_HM_select_sample.R                   
64  °--localPC/                                              
65      °--first_sep.R   