library(tidyverse)
library(GEOquery)

new_series_ID = "GSE110064" # Replace with series ID or GEO Ascension found on Omnibus Geo Query

RNA_series_ID = c("GSE101942", "GSE114559", "GSE121065", "GSE124252", "GSE124513", "GSE126910", "GSE128614", "GSE128621", "GSE131249", "GSE144857", "GSE151282",
                  "GSE154418", "GSE160637", "GSE160690", "GSE166849", "GSE167021", "GSE183701", "GSE188568", "GSE190053", "GSE190305", "GSE201093", "GSE203257",
                  "GSE208575", "GSE222365", "GSE42142", "GSE52249", "GSE55504", "GSE79842", "GSE84531", "GSE95552")

affymetrix_series_ID = c("GSE110064", "GSE11877", "GSE1281", "GSE1282", "GSE1294", 
                         "GSE138861", "GSE1397", "GSE143885", "GSE149459", "GSE149460", 
                         "GSE149461", "GSE149462", "GSE149463", "GSE149464", "GSE149465", 
                         "GSE158376", "GSE158377", "GSE1611", "GSE16176", "GSE16676", 
                         "GSE16677", "GSE168111", "GSE17459", "GSE17760", "GSE1789", 
                         "GSE19680", "GSE19681", "GSE19836", "GSE20910", "GSE222355", 
                         "GSE30517", "GSE61804", "GSE35561", "GSE35665", "GSE36787", 
                         "GSE39159", "GSE4119", "GSE47014", "GSE48611", "GSE49050", 
                         "GSE49635", "GSE5390", "GSE59630", "GSE62538", "GSE6283", 
                         "GSE65055", "GSE70102", "GSE83449", "GSE84887", "GSE99135")

temp_file_location <- "Data/Metadata/temp_file.tsv"

get_metadata <- function(series_ID, file_location) {
  metadata <- getGEO(series_ID)[[1]] # retrieves metadata using GEOquery function
  
  metadata = as_tibble(pData(metadata))
  View(metadata)
 
  write_tsv(metadata, file_location) # writes metadata to a temporary file
}

get_metadata(new_series_ID, temp_file_location)

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
  
  metadata_filtered <- metadata %>% # drop columns that are not needed based on above criteria
    select(-cols_to_drop)
  
   # assign(paste0(series_ID, "_metadata_filtered"), metadata_filtered)
   # view(get(paste0(series_ID, "_metadata_filtered")))
  
  file.remove(temp_file_location) # remove temporary file
  
  file_location <- "Data/Metadata/"
  write_tsv(metadata_filtered, paste0(file_location, series_ID, "_metadata.tsv"))
}

process_metadata <- function(series_ID, temp_file_location) {
  if (file.exists(temp_file_location)) { # check if temporary file exists
    drop_cols(temp_file_location, series_ID) # if it does, drop columns
  } else {
    get_metadata(series_ID, temp_file_location) # if it doesn't, get metadata and drop columns
    drop_cols(temp_file_location, series_ID)
  }
}

# process_metadata(new_series_ID, temp_file_location)


#----------------- Main -----------------#

response = readline(prompt = "Type 'r' for RNA-seq or 'a' for Affymetrix: ")

if (response == "r") {
  series_ID_list <- RNA_series_ID
} else if (response == "a") {
  series_ID_list <- affymetrix_series_ID
} else {
  stop("Invalid response. Please type 'r' for RNA-seq or 'a' for Affymetrix.")
}
for (i in series_ID_list) { # loop through all series IDs
  process_metadata(i, temp_file_location)
}