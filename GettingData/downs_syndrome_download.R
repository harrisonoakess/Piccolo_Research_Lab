# This script goes downloads the link, pivots the table, then writes the tsv file using the code from the excel sheet

library(tidyverse)

new_series_ID = "GSE101942"

get_data <- function(series_ID) {
  link = paste("https://www.ncbi.nlm.nih.gov/geo/download/?type=rnaseq_counts&acc=", series_ID, "&format=file&file=", series_ID, "_norm_counts_TPM_GRCh38.p13_NCBI.tsv.gz", sep = "")
  
  # ID_pattern = "(GSE)\\d+"
  # series_id = str_extract(link, ID_pattern, group = NULL)
  
  data <- read_tsv(link)
  
  pivot_longer(data, 2:ncol(data), names_to = "sample_id", values_to = "values") %>%
    pivot_wider(names_from = "GeneID", values_from = "values") -> transposed_data
  
  # view(transposed_data)
  
  file_location <- "Data/TransposedData/"
  write_tsv(transposed_data, paste0(file_location, series_ID, "_transposed.tsv"))
}

get_data(new_series_ID)
