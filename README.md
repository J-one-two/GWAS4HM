# MyRepo4R
 
1  DataStorage                                               
2   |--download/                                             
3   |   |--GRCh38.hipstr_reference.bed.gz                    
4   |   |--*.cram                                            
5   |   |--GRCh38_full_analysis_set_plus_decoy_hla.fa        
6   |   |--samtools-1.12/samtools-1.12/samtools              
7   |   |--ukb_geographic_phens-2017-01-06.txt               
8   |   |--w17351_2020-08-20.remove                          
9   |   |--ukb_v2_10xSD_PC-derived_Europeans_Het.keep        
10  |   |--ukb23155_b0_v1_s200632.fam                        
11  |   °--ukb1735_rel_s488374.dat                           
12  |--Output/                                               
13  |   |--CHR_$chr/                                         
14  |   |   |--highmyopia_chr${chr}_calls_${bed}.vcf.gz      
15  |   |   |--highmyopia_chr${chr}_calls_*.vcf              
16  |   |   |--presec/                                       
17  |   |   |   |--Output_Human_STR_List.txt                 
18  |   |   |   |--Mid_genotype.tmp                          
19  |   |   |   |--HM_calls_all_presec.txt                   
20  |   |   |   |--HM_chr${chr}_presec.vcf                   
21  |   |   |   |--Output_Human_STR_genotype.txt             
22  |   |   |   |--${str}.txt                                
23  |   |   |   |--${str}_count.txt                          
24  |   |   |   °--${str}_sorts.txt                          
25  |   |   °--second/                                       
26  |   |       |--Mid_genotype.tmp                          
27  |   |       |--HM_chr${chr}_calls_secondary_${bed}.vcf.gz
28  |   |       |--Output_Human_STR_genotype.txt             
29  |   |       |--HM_calls_all_secondary.txt                
30  |   |       |--${str}.txt                                
31  |   |       |--${str}_count.txt                          
32  |   |       |--${str}_sorts.txt                          
33  |   |       °--HM_CHR${chr}_Output_final.txt             
34  |   °--HM_SubjectsID.txt                                 
35  |--samples/                                              
36  |   |--WholeBedFile/                                     
37  |   |   |--STR_chr${chr}_*.bed                           
38  |   |   °--postsplit/                                    
39  |   |       |--post_screening_chr${chr}.bed              
40  |   |       °--Post_Split_STR_chr${chr}_*.bed            
41  |   |--sample_HM_all.tmp                                 
42  |   °--ukb_seq_HMvHH_phens_2021-10-09.txt                
43  |--scripts/                                              
44  |   |--test_tmp_s1.sh                                    
45  |   |--index_cram_file.sh                                
46  |   |--fun_chr_split.sh                                  
47  |   |--fun_chr_split_chrX.sh                             
48  |   |--hipstr_HM.sh                                      
49  |   |--hipstr_HM_secondary.sh                            
50  |   |--hipstr_HM_presec.sh                               
51  |   |--test_pres2.sh                                     
52  |   °--mini_scripts/                                     
53  |       |--post_output_check.sh                          
54  |       |--count_STR_num.sh                              
55  |       |--count_split_bed.sh                            
56  |       |--count_STR_num_secondary.sh                    
57  |       |--count_split_bed_secondary.sh                  
58  |       |--backup_scr.sh                                 
59  |       °--create_sample_list.sh                         
60  |--Dialog/                                               
61  |   |--hipstr_output.log(.err)                           
62  |   |--BedSplit_JT_%A_%a-%J.log(.err)                    
63  |   |--pres2_JT_%A_%a-%J.log(.err)                       
64  |   |--Cap_JT_second_%A_%a-%J.log(.err)                  
65  |   |--hipstr_JT_second_%A_%a-%J.log(.err)               
66  |   °--Cap_JT_third_%A_%a-%J.log(.err)                   
67  |--R_scripts/                                            
68  |   °--ukb_seq_200k_HM_select_sample.R                   
69  °--localPC/                                              
70      °--first_sep.R   