#--------------------libraries--------------------
# library(GEOquery)
# if (!require("BiocManager", quietly = TRUE)) 
#   install.packages("BiocManager")
# BiocManager::install("SCAN.UPC")

#--------------------data--------------------
# tmpDir =  tempdir()
# getGEOSuppFiles("GSE110064", makeDirectory = FALSE, baseDir=tmpDir)
# 
# celFilePath = file.path(tmpDir, "GSE110064.CEL.gz")


#--------------------------------------------------
# Install and load required libraries
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("GEOquery")
library(GEOquery)

# Set the GSE accession number
gse_accession <- "GSE11877"

# Download the supplementary files
tryCatch({
  gse <- getGEO(gse_accession, GSEMatrix = FALSE, getGPL = FALSE)
  supfiles <- getGEOSuppFiles(gse_accession, fetch_files = FALSE)
  print(supfiles)  # Print the supfiles data frame for inspection
}, error = function(e) {
  cat("Error in downloading supplementary files:", conditionMessage(e), "\n")
  return(NULL)
})

if (is.null(supfiles) || nrow(supfiles) == 0) {
  cat("No supplementary files found for", gse_accession, "\n")
  quit(save = "no")
}

# Filter for .cel.gz files
cel_files <- supfiles[grep("\\.cel\\.gz$", rownames(supfiles), ignore.case = TRUE), ]

if (nrow(cel_files) == 0) {
  cat("No .cel.gz files found in the supplementary files.\n")
  print(rownames(supfiles))  # Print all available file names
  quit(save = "no")
}

# Create a directory to store the downloaded files
dir.create("GSE11877_cel_files", showWarnings = FALSE)

# Download and extract .cel.gz files
for (file in rownames(cel_files)) {
  file_url <- as.character(cel_files[file, "url"])
  file_name <- basename(file_url)
  
  cat("Attempting to download:", file_name, "\n")
  
  tryCatch({
    download.file(file_url, destfile = file.path("GSE11877_cel_files", file_name), mode = "wb")
    cat("Successfully downloaded:", file_name, "\n")
  }, error = function(e) {
    cat("Error downloading", file_name, ":", conditionMessage(e), "\n")
  })
}

# Check the contents of the directory
downloaded_files <- list.files("GSE11877_cel_files")
cat("Files in GSE11877_cel_files directory:\n")
print(downloaded_files)

if (length(downloaded_files) == 0) {
  cat("No files were downloaded. Please check the console output for error messages.\n")
} else {
  cat("Downloaded", length(downloaded_files), "files to the 'GSE11877_cel_files' directory.\n")
}