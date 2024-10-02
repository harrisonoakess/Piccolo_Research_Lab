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

cell_type_enum <- list(
  from_schema = "https://w3id.org/MySchema",
  permissible_values = list(
    adipocyte = list(description = "adipocyte", exact_mappings = c("EFO:0000136")),  # Replace with actual mapping
    "bone marrow cell" = list(description = "bone marrow cell", exact_mappings = c("EFO:0002092")),
    endothelial = list(description = "endothelial cell", exact_mappings = c("EFO:0000115")),
    epithelial = list(description = "epithelial cell", exact_mappings = c("EFO:0000066")),
    fibroblast = list(description = "fibroblast", exact_mappings = c("EFO:0000057")),
    "glial brain cell" = list(description = "glial brain cell", exact_mappings = c("EFO:1001464")),
    hematopoietic = list(description = "hematopoietic cell", exact_mappings = c("EFO:0000988")),
    "immortal cell line" = list(description = "immortal cell line cell", exact_mappings = c("EFO:0000019")),
    neoplastic = list(description = "neoplastic cell", exact_mappings = c("EFO:0001063")),
    "reproductive system" = list(description = "reproductive system cell", exact_mappings = c("EFO:0002955")),
    stem = list(description = "stem cell", exact_mappings = c("EFO:0000034")),
    stromal = list(description = "stromal cell", exact_mappings = c("EFO:0000499"))
  )
)

schema$enums$cell_type_enum <- cell_type_enum
View(schema)

writeLines(as.yaml(schema), "updated_schema.yaml")