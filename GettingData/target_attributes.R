#----------------------libraries------------------------------------------------
library(tidyverse)
library(GEOquery)


#----------------------data-----------------------------------------------------
setwd("C:/Users/hoakes/Documents/Piccolo_Research_Lab")
  
RNA_series_ID = c("GSE101942")

# RNA_series_ID = c("GSE101942", "GSE114559", "GSE121065", "GSE124252", "GSE124513", "GSE126910", "GSE128614", "GSE128621", "GSE131249", "GSE144857", "GSE151282",
#                   "GSE154418", "GSE160637", "GSE160690", "GSE166849", "GSE167021", "GSE183701", "GSE188568", "GSE190053", "GSE190305", "GSE201093", "GSE203257",
#                   "GSE208575", "GSE222365", "GSE42142", "GSE52249", "GSE55504", "GSE79842", "GSE84531", "GSE95552")

temp_file_location <- "Data/Metadata/temp_file_target_data.tsv"

file_location <- "Data/Metadata/"

target_attributes <- tibble (
  ID = integer(), sex = character(), ploidy = character(), cell_type = character()
  
)
# view(target_attributes)
#------------------------functions----------------------------------------------

get_metadata <- function(series_ID, file_location) {
  metadata <- getGEO(series_ID)[[1]] # retrieves metadata using GEOquery function
  
  metadata = as_tibble(pData(metadata))
  # view(metadata)
  print("test")
  
  write_tsv(metadata, file_location) # writes metadata to a temporary file
}

append_tibble <- function(series_ID, temp_file_location, target_attributes) {
  # print("test")
  metadata <- read_tsv(temp_file_location)
  metadata_tibble <- as_tibble(metadata)

  for (i in 1:nrow(metadata_tibble)){
    row = metadata_tibble[i, ]
    # view(row)
    cols_to_drop <- names(metadata)[grepl("contact", names(metadata))]
    
    current_sex = "Female"
    current_ploidy = "Disomy"
    current_cell_type = "stem cells"
    
    target_attributes <- add_row(target_attributes, ID = i, sex = current_sex, ploidy = current_ploidy, cell_type = current_cell_type)
  
  }
  return(target_attributes)
  # file.remove(temp_file_location) # remove temporary file
}

process_metadata <- function(series_ID, temp_file_location, target_attributes) {
  # print("test")
  if (file.exists(temp_file_location)) { # check if temporary file exists
    # print("test")
    target_attributes = append_tibble(series_ID, temp_file_location, target_attributes) # if it does, drop columns
  } else {
    # print("test")
    get_metadata(series_ID, temp_file_location) # if it doesn't, get metadata and drop columns
    target_attributes = append_tibble(series_ID, temp_file_location, target_attributes)
  }
  return(target_attributes)
}

#-----------------------script to run-------------------------------------------
for (i in RNA_series_ID) { # loop through all series IDs
  target_attributes = process_metadata(i, temp_file_location, target_attributes)
}
view(target_attributes)

# write_tsv(metadata_filtered, paste0(file_location, series_ID, "_metadata.tsv"))