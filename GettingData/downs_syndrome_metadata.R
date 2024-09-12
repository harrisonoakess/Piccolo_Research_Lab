library(tidyverse)
library(GEOquery)

new_series_ID = "GSE114559"

RNA_series_ID = c("GSE101942", "GSE114559", "GSE121065", "GSE124252", "GSE124513", "GSE126910", "GSE128614", "GSE128621", "GSE131249", "GSE144857", "GSE151282", 
                  "GSE154418", "GSE160637", "GSE160690", "GSE166849", "GSE167021", "GSE183701", "GSE188568", "GSE190053", "GSE190305", "GSE201093", "GSE203257", 
                  "GSE208575", "GSE222365", "GSE42142", "GSE52249", "GSE55504", "GSE79842", "GSE84531", "GSE95552")

get_metadata <- function(series_ID) {
  metadata <- getGEO(series_ID)[[1]]
  
  metadata = as_tibble(pData(metadata))
  view(metadata)
 
  file_location <- "Data/Metadata/"
  write_tsv(metadata, paste0(file_location, series_ID, "_metadata.tsv"))
}

# get_metadata(new_series_ID)

for (i in RNA_series_ID) {
  get_metadata(i)
}