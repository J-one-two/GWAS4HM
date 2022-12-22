allele_letters_eraser <- function(my_data){
  tmp_data <- my_data
  vec_length <- dim(tmp_data)[2]
  total_str_num <- vec_length-19
  
  for(i in 20:(20+total_str_num-1))
  {
    split_data <- unlist(strsplit(as.character(tmp_data[,i]), "_"))
    mod1 <- is.na(split_data)
    mod2 <- is.na(as.numeric(split_data))
    mod3 <- xor(mod1,mod2)
    
    tmp_data[,i] <- split_data[which(!mod3)]
  }
  
  signal_vec <- rep(1,dim(tmp_data)[2])
  for(i in 20:(20+total_str_num-1)){
    if(length(levels(factor(tmp_data[,i])))<2){
      signal_vec[i] <- 0
    }
  }
  
  tmp_data <- tmp_data[which(signal_vec==1)]
  output_data <- tmp_data
  return(output_data)
}
allele_length_average <- function(input_data){
  tmp_data <- input_data
  rows <- dim(tmp_data)[1]/2
  col_max_num <- dim(tmp_data)[2]
  cal_data <- tmp_data[1:rows,20:col_max_num]
  
    for(i in 20:col_max_num){
    cal_data[,(i-19)] <- 0.5*as.numeric(tmp_data[1:rows,i])+0.5*as.numeric(tmp_data[(rows+1):(rows*2),i])
  }
  
  output_data <- data.frame(tmp_data[1:rows,1:19],cal_data)
  return(output_data)
}

#this script was designed for analyses on different chr separately
#function: first_sec.R
#         1. logistic regression for association study
library(reshape)
library(qqman)
library(ggplot2)

chr=14

  str1="E:/OneDrive - Cardiff University/Outputs/2022-03-09/HM_CHR"
  str2="_Output_final.csv"
  filename=paste(str1,chr,str2,sep="")

  my_data <- read.csv(filename,sep="")
  print(chr)
  print(dim(my_data))

total_num <- (dim(my_data)[2]-19)/2
parti_num <- dim(my_data)[1]
maximum <- dim(my_data)[2]
name <- c()

# combine the two columns of an STR into one column, written as melt_data
for (i in 1:total_num)
{
  columns <- c(1,2*i,2*i+1,(maximum-17):maximum)
  tmp <- data.frame(my_data[,columns])
  id_names <- colnames(tmp)[-c(2,3)]
  new_mat <- melt(tmp, id=id_names)
  name[i] <- paste("Human_STR_", unlist(strsplit(as.character(new_mat$variable[1]), "_"))[3], sep="")
  if(i==1)
  {melt_data <- new_mat}
  else{
    melt_data <- data.frame(melt_data,new_mat$value)
  }
}

melt_data <- melt_data[names(melt_data)!="variable"]
names(melt_data) <- c(id_names, name)
dim(melt_data)

# #estimate the number of different alleles of each STR
# alleles_num <- rep(0,total_num)
# for (i in 1:total_num)
# {
#   alleles_num[i] <- length(levels(factor(melt_data[,i+19])))
# }
# 
# summary_allele <- data.frame(name,alleles_num)
# tail(summary_allele[order(summary_allele$alleles_num),])

#filter out the weak STRs whose number of variants is less than 2
signal_vec <- rep(1,dim(melt_data)[2])
for(i in 19:(19+total_num-1)){
  if(length(levels(factor(melt_data[,i])))<2){
    signal_vec[i] <- 0
  } 
}

melt_filtered_data <- melt_data[which(signal_vec==1)]

# #estimate the number of different alleles of each STR after filter
# total_filtered_num <- dim(melt_filtered_data)[2]-19
# alleles_filtered_num <- rep(0,total_filtered_num)
# name_filtered <- colnames(melt_filtered_data)[20:(20+total_filtered_num-1)]
# for (i in 1:total_filtered_num)
# {
#   alleles_filtered_num[i] <- length(levels(factor(melt_filtered_data[,i+19])))
# }
# 
# summary_filtered_allele <- data.frame(name_filtered,alleles_filtered_num)
# tail(summary_filtered_allele[order(summary_filtered_allele$alleles_filtered_num),])
# head(summary_filtered_allele[order(summary_filtered_allele$alleles_filtered_num),])

##-----------------------------------------------------------------------------------
#block function: logistic regression analysis
#generate a data frame for logistic regression anaylsis
lr_data <- allele_letters_eraser(melt_filtered_data)
lr_data$HMvHH <- lr_data$HMvHH-1
levels(factor(lr_data$HMvHH))

lr_averaged_data <- allele_length_average(lr_data)

lr_total_str_num <- dim(lr_averaged_data)[2]-19
lr_p_value <- rep(1, lr_total_str_num)
lr_str_names <- colnames(lr_averaged_data)[20:(20+lr_total_str_num-1)]

filename <- paste("E:/CardiffRes/R/HipSTR_results/HM/Geno_pheno_chr_",chr,".txt",sep="")
outfile <- file(filename,"w+")
write.table(lr_averaged_data,outfile,append = FALSE, sep="\t", dec= ".", row.names = FALSE, col.names = TRUE)
close(outfile)

#save the genotype data for Human_STR_424816 and Human_STR_827099
if(chr==2)
{
  tmp_data <- lr_averaged_data[,c(1:19)]
  tmp_data <- data.frame(tmp_data,"Human_STR_827099"=lr_averaged_data$Human_STR_827099)
  outfile <- file("E:/CardiffRes/R/HipSTR_results/HM/Geno_Human_STR_827099.txt","w+")
  write.table(tmp_data,outfile,append = FALSE, sep="\t", dec= ".", row.names = FALSE, col.names = TRUE)
  close(outfile)
}
if(chr==14)
{
  tmp_data <- lr_averaged_data[,c(1:19)]
  tmp_data <- data.frame(tmp_data,"Human_STR_424816"=lr_averaged_data$Human_STR_424816)
  outfile <- file("E:/CardiffRes/R/HipSTR_results/HM/Geno_Human_STR_424816.txt","w+")
  write.table(tmp_data,outfile,append = FALSE, sep="\t", dec= ".", row.names = FALSE, col.names = TRUE)
  close(outfile)
}

for(i in 1:lr_total_str_num)
{ 
  if(length(levels(factor(lr_averaged_data[,(i+19)]))) <= 1){
  next
  }
   mylogit <- glm(HMvHH~lr_averaged_data[,(i+19)]+NewPC10+NewPC9+NewPC8+NewPC7+NewPC6+NewPC5+NewPC4+NewPC3+NewPC2+NewPC1+factor(Sex_matched)+NewAge+NewAge2,
                  family = "binomial", data = lr_averaged_data)
   lr_p_value[i] <- coef(summary(mylogit))[2,4]
  
}

table_lr <- data.frame( "CHR"=rep(chr,lr_total_str_num),"STR"=lr_str_names, "p.value"=lr_p_value, "BP"=seq(1,lr_total_str_num) )


qq(table_lr$p.value)
manhattan(table_lr, chr="CHR", bp="BP", snp="STR", p="p.value" )







