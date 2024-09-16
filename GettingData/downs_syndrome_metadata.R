library(tidyverse)
library(GEOquery)

new_series_ID = "GSE114559"

# RNA_series_ID = c("GSE101942", "GSE114559", "GSE121065", "GSE124252", "GSE124513", "GSE126910", "GSE128614", "GSE128621", "GSE131249", "GSE144857", "GSE151282", 
#                   "GSE154418", "GSE160637", "GSE160690", "GSE166849", "GSE167021", "GSE183701", "GSE188568", "GSE190053", "GSE190305", "GSE201093", "GSE203257", 
#                   "GSE208575", "GSE222365", "GSE42142", "GSE52249", "GSE55504", "GSE79842", "GSE84531", "GSE95552")

temp_file_location <- "Data/Metadata/temp_file.tsv"

get_metadata <- function(series_ID, file_location) {
  metadata <- getGEO(series_ID)[[1]]
  
  metadata = as_tibble(pData(metadata))
  view(metadata)
 
  write_tsv(metadata, file_location)
}

drop_cols <- function(temp_file_location, series_ID) {
  metadata <- read_tsv(temp_file_location)
  cols_to_drop <- names(metadata)[grepl("contact", names(metadata)) | 
                                    grepl("library", names(metadata)) | 
                                    grepl("processing", names(metadata)) | 
                                    grepl("description", names(metadata)) |
                                    grepl("relation", names(metadata)) | 
                                    grepl("platform", names(metadata)) | 
                                    grepl("instrument", names(metadata)) | 
                                    grepl("protocol", names(metadata)) | 
                                    grepl("file", names(metadata)) | 
                                    grepl("date", names(metadata)) | 
                                    grepl("row", names(metadata)) | 
                                    grepl("status", names(metadata)) | 
                                    grepl("characteristics", names(metadata)) |
                                    grepl("time", names(metadata)) | 
                                    grepl("channel", names(metadata)) | 
                                    grepl("taxid", names(metadata))
]
  
  # view(cols_to_drop)
  
  metadata_filtered <- metadata %>% 
    select(-cols_to_drop)
  
  # view(metadata_filtered)
  
  file.remove(temp_file_location)
  
  file_location <- "Data/Metadata/"
  write_tsv(metadata_filtered, paste0(file_location, series_ID, "_metadata.tsv"))
}

process_metadata <- function(series_ID, temp_file_location) {
  if (file.exists(temp_file_location)) {
    drop_cols(temp_file_location)
  } else {
    get_metadata(series_ID, temp_file_location)
    drop_cols(temp_file_location, series_ID)
  }
}

process_metadata(new_series_ID, temp_file_location)

# for (i in RNA_series_ID) {
#   proccess_metadata(i, temp_file_location)
# }