library(tidyverse)
library(yaml)

setwd("/Users/garrettwride/Piccolo_Research_Lab/Data/Metadata")

file_path <- "enriched_attributes_schema.yaml"
schema <- yaml.load_file(file_path)

schema$enums$sex_enum$permissible_values$male$exact_mappings <- "PATO:0000384"
schema$enums$sex_enum$permissible_values$female$exact_mappings <- "PATO:0000383"
schema$slots$ploidy$exact_mappings <- "PATO:0001374"
schema$enums$ploidy_enum$permissible_values$disomic$exact_mappings <- "PATO:0001387"
schema$enums$ploidy_enum$permissible_values$trisomic$exact_mappings <- "PATO:0001389"

# new_enum <- list(
#   ploidy_enum = list(
#     permissible_valies = list(
#       trisomy = list(description = "trisomy", exact_mappings = "PATO:0001389"),
#       disomy = list(description = "disomy", exact_mappings = "PATO:0001387")
#     )
#   )
# )
# 
# schema$enums <- c(schema$enums, new_enum)

View(schema)
