library(tidyverse)
library(GEOquery)

series_id = "GSE101942"

metadata <- getGEO(series_id)[[1]]

metadata = as_tibble(pData(metadata))
class(metadata)
view(metadata)

write_tsv(metadata, paste(series_id, "_metadata.tsv", sep=""))
