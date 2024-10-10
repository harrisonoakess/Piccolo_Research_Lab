#--------------------libraries--------------------
library(GEOquery)
library(affy)
# if (!require("BiocManager", quietly = TRUE)) 
#   install.packages("BiocManager")
# BiocManager::install("SCAN.UPC")
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("GEOquery")

# getwd()

# setwd("C:\\Users\\garrettwride\\Piccolo_Research_Lab")

#--------------------data--------------------
# tmpDir =  tempdir()
# getGEOSuppFiles("GSE110064", makeDirectory = FALSE, baseDir=tmpDir)
# 
# celFilePath = file.path(tmpDir, "GSE110064.CEL.gz")


#--------------------------------------------------

# Download supplementary files
getGEOSuppFiles("GSE11877")

# Extract the tar file
untar("GSE11877/GSE11877_RAW.tar", exdir = "GSE11877_RAW")

# List the extracted files
list.files("GSE11877_RAW")

# Read the first few lines of the CEL file
readLines("GSE11877_RAW/GSM11877.CEL.gz", n = 1000)

# Define the full path to your GSE11877_RAW directory
gse_path <- "GSE11877_RAW"

# List all the .CEL files in the directory
cel_files <- list.files(path=gse_path, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE)

print(cel_files)

files_to_delete <- setdiff(list.files("GSE11877_RAW", full.names= TRUE), cel_files)

print(files_to_delete)

if (length(files_to_delete) > 0) {
  file.remove(files_to_delete)
}