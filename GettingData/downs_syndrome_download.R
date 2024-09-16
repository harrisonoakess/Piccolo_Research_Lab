# This script goes downloads the link, pivots the table, then writes the tsv file using the code from the excel sheet

library(tidyverse)

new_series_ID = "GSE101942" # Replace with series ID or GEO Ascension found on Omnibus Geo Query

RNA_series_ID = c("GSE101942", "GSE114559", "GSE121065", "GSE124252", "GSE124513", "GSE126910", "GSE128614", "GSE128621", "GSE131249", "GSE144857", "GSE151282", 
                  "GSE154418", "GSE160637", "GSE160690", "GSE166849", "GSE167021", "GSE183701", "GSE188568", "GSE190053", "GSE190305", "GSE201093", "GSE203257", 
                  "GSE208575", "GSE222365", "GSE42142", "GSE52249", "GSE55504", "GSE79842", "GSE84531", "GSE95552") # List of RNA series IDs

get_data <- function(series_ID) {
  link = paste("https://www.ncbi.nlm.nih.gov/geo/download/?type=rnaseq_counts&acc=", series_ID, "&format=file&file=", series_ID, "_norm_counts_TPM_GRCh38.p13_NCBI.tsv.gz", sep = "") # creates link to download data
  
  # ID_pattern = "(GSE)\\d+"
  # series_id = str_extract(link, ID_pattern, group = NULL)
  
  data <- read_tsv(link) # reads data from link
  
  pivot_longer(data, 2:ncol(data), names_to = "sample_id", values_to = "values") %>% # switches columns with first row
    pivot_wider(names_from = "GeneID", values_from = "values") -> transposed_data
  
  # view(transposed_data)
  
  file_location <- "Data/TransposedData/"
  write_tsv(transposed_data, paste0(file_location, series_ID, "_transposed.tsv")) # writes trasnposed data to a tsv file
}

# get_data(new_series_ID)


for (i in RNA_series_ID) { # loops through all RNA series IDs
  get_data(i)
}
