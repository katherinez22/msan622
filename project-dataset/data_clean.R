setwd("/Users/Katherine/GitHub/msan622/project-dataset/namesbystate")
library(plyr)
listOfFiles <- list.files(pattern= ".TXT") 
# Read in all txt files.
d <- do.call(rbind, lapply(listOfFiles, read.table, sep = ",", 
                           col.names=c("State", "Sex", "Year", "Name", "Number"), 
                           fill=FALSE, strip.white=TRUE)) 
# Sub set the data by extracting only the data from 2002 to 2012.
sub_d <- subset(d, Year >= 1972)
write.csv(sub_d, file = "NamesOf50States.csv")
