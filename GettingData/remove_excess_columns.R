library(tidyverse)
library(GEOquery)

new_series_ID = "GSE201093"

metadata <- getGEO(series_ID)[[1]]

metadata = as_tibble(pData(metadata))

drop_cols <- names(metadata)[grepl("contact", names(metadata)) | 
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

view(drop_cols)

metadata_filtered <- metadata %>% 
  select(-drop_cols)

view(metadata_filtered)

file_location <- "Data/Metadata/"
write_tsv(metadata_filtered, paste0(file_location, series_ID, "_metadata.tsv"))