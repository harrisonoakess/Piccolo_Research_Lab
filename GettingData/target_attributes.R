#----------------------libraries------------------------------------------------
library(tidyverse)
library(stringr)
library(GEOquery)


#----------------------data-----------------------------------------------------
# setwd("C:/Users/hoakes/Documents/Piccolo_Research_Lab")
  
# RNA_series_ID = c("GSE128621")

RNA_series_ID = c("GSE101942", "GSE114559", "GSE121065", "GSE124252", "GSE124513", "GSE126910", "GSE128614", "GSE128621", "GSE131249", "GSE144857", "GSE151282",
                  "GSE154418", "GSE160637", "GSE160690", "GSE166849", "GSE167021", "GSE183701", "GSE188568", "GSE190053", "GSE190305", "GSE201093", "GSE203257",
                  "GSE208575", "GSE222365", "GSE42142", "GSE52249", "GSE55504", "GSE79842", "GSE84531", "GSE95552")

temp_file_location <- "Data/Metadata/temp_file_target_data.tsv"

file_location <- "Data/Metadata/"

target_attributes <- tibble ( # create tibble to store target attributes
  geo_accession = character(), sex = character(), ploidy = character(), cell_type = character()
  
)
# view(target_attributes)
#------------------------functions----------------------------------------------

get_metadata <- function(series_ID, file_location) {
  metadata <- getGEO(series_ID)[[1]] # retrieves metadata using GEOquery function
  
  metadata = as_tibble(pData(metadata)) # converts metadata to tibble
  # view(metadata)
  
  write_tsv(metadata, file_location) # writes metadata to a temporary file
}

append_tibble <- function(series_ID, temp_file_location, target_attributes) { # fucniton that appends new rows from one file to target_attributes
  metadata <- read_tsv(temp_file_location) # read temporary file
  metadata_tibble <- as_tibble(metadata)

  for (i in 1:nrow(metadata_tibble)){ # loop through all rows in metadata
    row = metadata_tibble[i, ]
    
    current_sex = "n/a"
    current_ploidy = "n/a"
    current_cell_type = "n/a"
    ID = "n/a"
    
    column_name <- names(metadata)[grepl("cell type", names(metadata)) | # get column name for cell type
                                      grepl("cell_type", names(metadata))]
    # View(column_name)
    if (length(column_name) != 0) { # if column name exists
      current_cell_type = row[[column_name]] # current cell type is the value in that column
    }
    
    column_name <- names(metadata)[grepl("geo", names(metadata))] # get column name for ID
    # View(column_name)
    if (length(column_name) != 0) { # if column name exists
      ID = row[[column_name]] # current ID is the value in that column
    }
    
    if (any(str_detect(row, regex("female", ignore_case = TRUE)), na.rm = TRUE)){ # first check each cell in row for 'female' if found set current sex to female
      current_sex = "female" 
    } else if (any(str_detect(row, regex("male", ignore_case = TRUE)), na.rm = TRUE)){
      current_sex = "male"
    }
    
    if (any(str_detect(row, regex("trisomic | trisomy", ignore_case = TRUE)), na.rm = TRUE)){ # first check each cell in row for 'trisomic' if found set current ploidy to trisomic
      current_ploidy = "trisomic"
    } else if (any(str_detect(row, regex("disomic | disomy | WT | normal", ignore_case = TRUE)), na.rm = TRUE)){
      current_ploidy = "disomic"
    }
    
    target_attributes <- add_row(target_attributes, geo_accession = ID , sex = current_sex, ploidy = current_ploidy, cell_type = current_cell_type) # append to tiblle with row contained retrieved values
  }
  file.remove(temp_file_location) # remove temporary file
  return(target_attributes)
}

process_metadata <- function(series_ID, temp_file_location, target_attributes) {
  if (file.exists(temp_file_location)) { # check if temporary file exists
    target_attributes = append_tibble(series_ID, temp_file_location, target_attributes) # if it does, drop columns
  } else {
    get_metadata(series_ID, temp_file_location) # if it doesn't, get metadata and drop columns
    target_attributes = append_tibble(series_ID, temp_file_location, target_attributes)
  }
  return(target_attributes)
}

#-----------------------script to run-------------------------------------------
for (i in RNA_series_ID) { # loop through all series IDs to crate one tibble with the target attributes data from all files
  target_attributes = process_metadata(i, temp_file_location, target_attributes)
}
view(target_attributes)

write_tsv(target_attributes, paste0(file_location, "_target_attributes.tsv"))
