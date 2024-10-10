#--------------------libraries--------------------
library(GEOquery)
library(affy)
library(tidy)
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
dir.create("affymetrix_data", showWarnings = FALSE)

# Download supplementary files
getGEOSuppFiles("GSE11877")

# Extract the tar file
untar("GSE11877/GSE11877_RAW.tar", exdir = "GSE11877_RAW")

file.rename("GSE11877_RAW", "affymetrix_data/GSE11877_RAW")

# closeAllConnections()
# 
# unlink("GSE11877", recursive = TRUE)

# # List the extracted files
# list.files("GSE11877_RAW")
# 
# # Read the first few lines of the CEL file
# readLines("GSE11877_RAW/GSM11877.CEL.gz", n = 1000)

# Define the full path to your GSE11877_RAW directory
gse_path <- "affymetrix_data/GSE11877_RAW"

# List all the .CEL files in the directory
cel_files <- list.files(path=gse_path, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE)

print(cel_files)

files_to_delete <- setdiff(list.files(gse_path, full.names= TRUE), cel_files)

print(files_to_delete)

if (length(files_to_delete) > 0) {
  file.remove(files_to_delete)
}
cell_data = ReadAffy(filenames = gse_path)
View(cell_data)

# untar("affymetrix_data/GSE11877/GSM299862.CEL.gz", exdir = "affymetrix_data/GSE11877_unzipped")
# lines <- readLines(gzfile("affymetrix_data/GSE11877_RAW/GSM299862.CEL.gz"))
# line_tibble = as_tibble(lines)
# View(line_tibble)