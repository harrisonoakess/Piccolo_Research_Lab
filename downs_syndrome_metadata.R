library(tidyverse)
library(GEOquery)

metadata <- getGEO("GSE101942")[[1]]

metadata = as_tibble(pData(metadata))
class(metadata)
view(metadata)  
