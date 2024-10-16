total_start_time = Sys.time()
#--------------------libraries--------------------
library(GEOquery)
library(affy)
library(tidyverse)
library(BiocManager)
library(tidyverse)
library(SCAN.UPC) 
options(timeout = max(300, getOption("timeout")))

# geo_id = 'GSE11877'
# 
# if (!file.exists(geo_id)){
#   # Download supplementary files
#   print(paste("Downloading", geo_id))
#   getGEOSuppFiles(geo_id)
#   Sys.sleep(5)
#   print("Download Successful")
# }
# 
# print("Waiting on file...")
# Sys.sleep(10)
# if (!require("BiocManager", quietly = TRUE)) 
#   install.packages("BiocManager")
# BiocManager::install("SCAN.UPC")
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("GEOquery")

# getwd()

# setwd("C:\\Users\\garrettwride\\Piccolo_Research_Lab")

#--------------------data--------------------
# geofiles = c("GSE11877")

geofiles = c("GSE110064", "GSE11877", "GSE1281", "GSE1282", "GSE1294", "GSE138861", "GSE1397", "GSE143885", "GSE149459", "GSE149460",
"GSE149461", "GSE149462", "GSE149463", "GSE149464", "GSE149465", "GSE158376", "GSE158377", "GSE1611", "GSE16176", "GSE16676",
"GSE16677", "GSE168111", "GSE17459", "GSE17760", "GSE1789", "GSE19680", "GSE19681", "GSE19836", "GSE20910", "GSE222355",
"GSE30517", "GSE61804", "GSE35561", "GSE35665", "GSE36787", "GSE39159", "GSE4119", "GSE47014", "GSE48611", "GSE49050",
"GSE49635", "GSE5390", "GSE59630", "GSE62538", "GSE6283", "GSE65055", "GSE70102", "GSE83449", "GSE84887", "GSE99135")

#------------------functions----------------------

get_scan_upc_files = function(geo_id){
  
  if (!file.exists(geo_id)){
    # Download supplementary files
    print(paste("Downloading", geo_id))
    getGEOSuppFiles(geo_id)
    print("Download Successful")
  }
  
  # formated string for the untar
  tar_file_f = sprintf("%s/%s_RAW.tar", geo_id, geo_id)
  
  # formated string for the untar output
  tar_file_output_f = sprintf("affymetrix_data/%s_RAW", geo_id)
  
  # Extract the tar file
  untar(tar_file_f, exdir = tar_file_output_f)
  print("Unzip Successfull")
  
  # Deletes the file with the zipped files
  unlink(geo_id, recursive = TRUE)
  
  # Define the full path to your GSE11877_RAW directory
  gse_path <- tar_file_output_f
  
  # List all the .CEL files in the directory
  cel_files <- list.files(path = gse_path, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
  
  # Makes a list of all files that are not in the above cel_files vector
  files_to_delete <- setdiff(list.files(gse_path, full.names= TRUE), cel_files)
  
  # print(files_to_delete)
  
  # Deletes all files in the files_to_delete
  if (length(files_to_delete) > 0) {
    file.remove(files_to_delete)
  }
  
  # Sets the file pattern to .CEL, so scan pulls everythiing with that ending
  celFilePattern <- file.path(gse_path, "*.CEL.gz")
  
  # formated string for the SCAN output
  scan_output_file_f = sprintf("affymetrix_data/%s_SCAN", geo_id)
  
  # last step to converting the information
  SCAN(celFilePattern, outFilePath = scan_output_file_f, convThreshold = .01, probeLevelOutDirPath = NA)
  
  # Delete the RAW file
  unlink(tar_file_output_f, recursive = TRUE)
}

#-------------------Script-------------------------
for (file in geofiles){
  file_start_time = Sys.time()
  get_scan_upc_files(file)
  file_end_time = Sys.time()
  total_file_time = file_end_time - file_start_time
  print(paste('File download time: ', total_file_time))
}
total_end_time = Sys.time()
total_time = total_end_time - total_start_time
print(paste('Total time: ', total_time))
