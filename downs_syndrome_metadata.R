library(tidyverse)
library(GEOquery)

new_series_ID = "GSE101942"

get_metadata <- function(series_ID) {
  metadata <- getGEO(series_ID)[[1]]
  
  metadata = as_tibble(pData(metadata))
  # class(metadata)
  # view(metadata)
  write_tsv(metadata, paste(series_id, "_metadata.tsv", sep=""))
}

get_metadata(new_series_ID)
