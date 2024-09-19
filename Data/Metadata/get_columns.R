library(tidyverse)
# setwd("C:/Users/hoakes/Documents/Piccolo_Research_Lab/data/metadata")

col_headers = c()

RNA_series_ID <- c("GSE101942", "GSE114559", "GSE121065", "GSE124252", "GSE124513", "GSE126910", "GSE128614", "GSE128621", "GSE131249", "GSE144857", "GSE151282",
                   "GSE154418", "GSE160637", "GSE160690", "GSE166849", "GSE167021", "GSE183701", "GSE188568", "GSE190053", "GSE190305", "GSE201093", "GSE203257",
                   "GSE208575", "GSE222365", "GSE42142", "GSE52249", "GSE55504", "GSE79842", "GSE84531", "GSE95552")

# Assuming your files are named like "GSE121065_data.tsv"
for (id in RNA_series_ID) {
  filename <- paste0(id, "_metadata.tsv")
  if (file.exists(filename)) {
    tryCatch({
      data <- read_tsv(filename)
      cols_to_drop <- names(data)[grepl("contact", names(data)) | 
                                        grepl("library", names(data)) | 
                                        grepl("processing", names(data)) | 
                                        grepl("description", names(data)) |
                                        grepl("relation", names(data)) | 
                                        grepl("platform", names(data)) | 
                                        grepl("instrument", names(data)) | 
                                        grepl("protocol", names(data)) | 
                                        grepl("file", names(data)) | 
                                        grepl("date", names(data)) | 
                                        grepl("row", names(data)) | 
                                        grepl("status", names(data)) | 
                                        grepl("characteristics", names(data)) |
                                        grepl("time", names(data)) | 
                                        grepl("channel", names(data)) | 
                                        grepl("taxid", names(data))
      ]
      
      # view(cols_to_drop)
      
      data <- data %>% # drop columns that are not needed based on above criteria
        select(-cols_to_drop)
      col_headers = c(col_headers, names(data))
    }, error = function(e) {
      cat("Error reading", filename, ":", e$message, "\n")
    })
  } else {
    cat("File not found:", filename, "\n")
  }
}
col_headers_tibble = as.tibble(col_headers)
View(col_headers_tibble)

