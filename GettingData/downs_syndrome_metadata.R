library(tidyverse)
library(GEOquery)

new_series_ID = "GSE101942"

get_metadata <- function(series_ID) {
  metadata <- getGEO(series_ID)[[1]]
  
  metadata = as_tibble(pData(metadata))
  view(metadata)
  
  # drop_cols
  # 
  # metadata_filtered <- data %>% select(-drop_cols)
  # 
  # file_location <- "Data/Metadata/"
  # write_tsv(metadata_filtered, paste0(file_location, series_ID, "_metadata.tsv"))
}

get_metadata(new_series_ID)

