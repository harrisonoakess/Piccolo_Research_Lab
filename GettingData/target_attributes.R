library(tidyverse)
library(GEOquery)



RNA_series_ID = c("GSE101942", "GSE114559", "GSE121065", "GSE124252", "GSE124513", "GSE126910", "GSE128614", "GSE128621", "GSE131249", "GSE144857", "GSE151282",
                  "GSE154418", "GSE160637", "GSE160690", "GSE166849", "GSE167021", "GSE183701", "GSE188568", "GSE190053", "GSE190305", "GSE201093", "GSE203257",
                  "GSE208575", "GSE222365", "GSE42142", "GSE52249", "GSE55504", "GSE79842", "GSE84531", "GSE95552")

temp_file_location <- "Data/Metadata/temp_file.tsv"

get_metadata <- function(series_ID, file_location) {
  metadata <- getGEO(series_ID)[[1]] # retrieves metadata using GEOquery function
  
  metadata = as_tibble(pData(metadata))
  # view(metadata)
  
  write_tsv(metadata, file_location) # writes metadata to a temporary file
}

append_tibble <- function(series_ID, temp_file_location) {
  
  
  file.remove(temp_file_location) # remove temporary file
}

process_metadata <- function(series_ID, temp_file_location) {
  if (file.exists(temp_file_location)) { # check if temporary file exists
    append_tibble(temp_file_location, series_ID) # if it does, drop columns
  } else {
    get_metadata(series_ID, temp_file_location) # if it doesn't, get metadata and drop columns
    append_tibble(temp_file_location, series_ID)
  }
}

target_attributes <- tibble (
  ID = c(), sex = c(), ploidy = c(), cell_type = c()
)
for (i in RNA_series_ID) { # loop through all series IDs
  process_metadata(i, temp_file_location)
}
file_location <- "Data/Metadata/"
write_tsv(metadata_filtered, paste0(file_location, series_ID, "_metadata.tsv"))