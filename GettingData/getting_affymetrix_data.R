#--------------------libraries--------------------
library(GEOquery)
if (!require("BiocManager", quietly = TRUE))     install.packages("BiocManager") BiocManager::install("SCAN.UPC")

#--------------------data--------------------
tmpDir =  tempdir()
getGEOSuppFiles("GSE110064", makeDirectory = FALSE, baseDir=tmpDir)

celFilePath = file.path(tmpDir, "GSE110064.CEL.gz")





