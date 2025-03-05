# ----------Libraries----------
library(tidyverse)
# -----------------------------

quality_data <- read_tsv("Data/Affymetrix/quality_output_file.tsv", 
                 col_names = c("value", "path"))

data_processed <- data %>%
  mutate(
    platform = str_extract(path, "(?<=GSM\\d+_)\\d+"),
    form = str_extract(path, "(?<=-)[A-Z]+(?=\\.CEL\\.gz)")
  )

quality_plot = ggplot(data_processed, aes(x = value)) +
                geom_histogram(aes(y = ..density..), binwidth = 0.05, fill = "skyblue", color = "black") +
                geom_density(color = "red", size = 1) +
                facet_grid(platform ~ form) +
                labs(title = "Distribution of Values by Platform and Form",
                    x = "Value",
                    y = "Density") +
                theme_minimal() +
                theme(strip.background = element_rect(fill = "lightgray"),
                        strip.text = element_text(face = "bold"))
print(quality_plot)