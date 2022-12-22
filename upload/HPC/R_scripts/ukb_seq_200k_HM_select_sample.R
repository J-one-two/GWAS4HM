library(data.table)
library(dplyr)
library(lazyeval)
library(tidyr)
library(igraph)
library(demoGraphic)

# Criteria
# -----------
# Not withdrawn
# European ancestry
# Heterogeneity within 4 SD
# Matching sex 
# From an Assessment Centre with at least 50 participants with known avMSE

rm(list=ls())

check_for_relatives <- function (dataKIN, dataIN) {
dataKIN             <- as.data.frame(dataKIN)
dataIN              <- as.data.frame(dataIN)
dataCK              <- dataKIN[dataKIN$ID1 %in% dataIN$IID & dataKIN$ID2 %in% dataIN$IID,]
if(dim(dataCK)[1] == 0){
  dataOUT <- "No relatives in dataset"
  } else {
  dataOUT <- dataCK
  }
return(dataOUT)
}

remove_relatives    <- function (dataKIN, dataIN) {
dataKIN             <- as.data.frame(dataKIN)
dataIN              <- as.data.frame(dataIN)
dataCK              <- dataKIN[dataKIN$ID1 %in% dataIN$IID & dataKIN$ID2 %in% dataIN$IID,]
g                   <- igraph::graph_from_data_frame(dataCK[,1:2], directed=FALSE, vertices=NULL)
mykins              <- igraph::as_data_frame(g,what="vertices")
myexcl              <- mykins$name
gs                  <- groups(components(g))
num_groups          <- length(gs)
mylist              <- data.frame(name=c())
for (i in 1:num_groups){
mygraph             <- induced.subgraph(g,gs[[i]])
livs                <- largest_ivs(mygraph)[[1]]
a                   <- induced_subgraph(mygraph, livs)
b                   <- igraph::as_data_frame(a,what="vertices")
mylist              <- rbind(mylist,b)
}
myincl              <- mylist$name
mydiff              <- myexcl[!myexcl %in% myincl]
dataOUT             <- dataIN[!dataIN$IID %in% mydiff,]
print(paste("Starting sample size =", dim(dataIN)[1]))
print(paste("Finishing sample size =", dim(dataOUT)[1]))
return(dataOUT)
}


# Function to remove related individuals from 2 datasets 
# (remove all those from dataIN2 related to an individual  
# in dataIN1; then restrict to unrelateds in dataIN2)
# ------------------------------------------------------

remove_2relatives   <- function (dataKIN, dataIN1, dataIN2) {
dataKIN             <- as.data.frame(dataKIN)
dataIN1             <- as.data.frame(dataIN1)
dataIN2             <- as.data.frame(dataIN2)
dataCK              <- dataKIN[((dataKIN$ID1 %in% dataIN2$IID & dataKIN$ID2 %in% dataIN1$IID) |
                                (dataKIN$ID2 %in% dataIN2$IID & dataKIN$ID1 %in% dataIN1$IID)),]
myexcl              <- rbind(dataCK[,1],dataCK[,2])
dataINT             <- dataIN2[!dataIN2$IID %in% myexcl,]
print(paste("Pre-starting sample size =", dim(dataIN2)[1]))
dataOUT             <- remove_relatives(dataKIN, dataINT)
return(dataOUT)
}



mydir="C:/Users/sopjg2/OneDrive - Cardiff University/Analyses/ukb_seq_200k/"
set.seed(44444)

data1           <- as.data.frame(fread(file=paste(mydir,"ukb_geographic_phens-2017-01-06.txt",sep=""), header=TRUE))
data2           <- as.data.frame(fread(file=paste(mydir,"w17351_2020-08-20.remove",sep=""), header=TRUE))
names(data2)    <- c("IID")
data2$withdrawn <- 1
data3           <- as.data.frame(fread(file=paste(mydir,"ukb_v2_10xSD_PC-derived_Europeans_Het.keep",sep=""), header=FALSE))
names(data3)    <- c("IID","FID")
data3$EuroHetOK <- 1
data4           <- as.data.frame(fread(file=paste(mydir,"ukb23155_b0_v1_s200632.fam",sep=""), header=FALSE))
names(data4)    <- c("IID","FID","V3","V4","V5","V6")
data5           <- merge(data1,data2,by="IID",all=TRUE)      
data6           <- merge(data5,data3,by=c("IID","FID"),all=TRUE)
data7           <- merge(data6,data4[,c("IID","FID")],by=c("IID","FID"))

# Load Bycroft's pairwise list of kinship (note an entry ID2=-1 with kinship=-1...this will not get selected)
dataKIN         <- as.data.frame(fread(file=paste(mydir,"ukb1735_rel_s488374.dat",sep=""), header=TRUE))
dataKIN$HetHet  <- NULL
dataKIN$IBS0    <- NULL

dim(data7)
data1 <- NULL
data2 <- NULL
data3 <- NULL
data4 <- NULL
data5 <- NULL
data6 <- NULL

data8             <- data7[which(is.na(data7$withdrawn) & 
                    !is.na(data7$Sex_matched) &
                           data7$outlierMSE==0 &
                    !is.na(data7$avMSE) &
                    !is.na(data7$AssessmentCentre) &
                           data7$EuroHetOK==1),]

data9             <- data8 %>% group_by(AssessmentCentre) %>% filter(n() >= 50)
data9             <- as.data.frame(data9)
dim(data9)

data9$HHcase      <- ifelse(data9$avMSE >= +2, 1, NA)
data9$HMcase      <- ifelse(data9$avMSE <= -6, 2, NA)
data9$HMvHH       <- ifelse(data9$avMSE >= +2, 1, NA)
data9$HMvHH       <- ifelse(data9$avMSE <= -6, 2, data9$HMvHH)

table(data9$HMvHH,useNA="always")

dataHM            <- remove_relatives(dataKIN, data9[which(data9$HMcase==2),])
check_for_relatives(dataKIN, dataHM)
dataHH            <- remove_2relatives(dataKIN, dataHM, data9[which(data9$HHcase==1),])
check_for_relatives(dataKIN, dataHH)

dataHMvHH         <- rbind(dataHM,dataHH)
check_for_relatives(dataKIN, dataHMvHH)

dataHMvHH$NewAge      <- scale(dataHMvHH$Age)
dataHMvHH$NewAge2     <- scale(dataHMvHH$NewAge^2)
dataHMvHH$NewAvMSE    <- scale(dataHMvHH$avMSE)
dataHMvHH$NewPC1      <- scale(dataHMvHH$PC1)
dataHMvHH$NewPC2      <- scale(dataHMvHH$PC2)
dataHMvHH$NewPC3      <- scale(dataHMvHH$PC3)
dataHMvHH$NewPC4      <- scale(dataHMvHH$PC4)
dataHMvHH$NewPC5      <- scale(dataHMvHH$PC5)
dataHMvHH$NewPC6      <- scale(dataHMvHH$PC6)
dataHMvHH$NewPC7      <- scale(dataHMvHH$PC7)
dataHMvHH$NewPC8      <- scale(dataHMvHH$PC8)
dataHMvHH$NewPC9      <- scale(dataHMvHH$PC9)
dataHMvHH$NewPC10     <- scale(dataHMvHH$PC10)

dataG                 <- dataHMvHH[,c("FID","IID","HMvHH","HHcase","HMcase","avMSE",
                                  "NewAge","NewAge2","Sex_matched",
                                  "NewPC1","NewPC2","NewPC3","NewPC4","NewPC5",
                                  "NewPC6","NewPC7","NewPC8","NewPC9","NewPC10")]

table(dataHMvHH$HMvHH,useNA="always")

outfile            <- "C:/Users/sopjg2/OneDrive - Cardiff University/Research students/Jiangtian Cui/Analysis/HMvHH/ukb_seq_HMvHH_phens_2021-10-09.txt"
write.table(dataG, file=outfile, quote = FALSE, sep = " ", row.names = FALSE, col.names = TRUE)

# Write script to download new cram files 
data12             <- dataHMvHH[order(dataHMvHH$IID),]
myOUT1             <- paste(data12$IID," 23154_0_0", sep="")
myOUT2             <- paste(data12$IID," 23153_0_0", sep="")
myOUT              <- paste(myOUT1,myOUT2,sep="\n")

p <- 0
for (i in seq(1, length(myOUT), by=50)){
  p                 <- p + 1
  outfile           <- paste("C:/Users/sopjg2/OneDrive - Cardiff University/Research students/Jiangtian Cui/Analysis/HMvHH/bulk_cram_list_2021-10-09_pt", p, ".txt",sep="")
  write.table(myOUT[i:(i+49)],     file=outfile, quote = FALSE, row.names = FALSE, col.names = FALSE)
}

