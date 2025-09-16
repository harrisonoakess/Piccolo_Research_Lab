library(tidyverse)
# -----------------------------

quality_data <- read_tsv("Data/Affymetrix/quality_output_file.tsv", 
                 col_names = c("gsm_id", "platform", "geo_id", "passed"))

# Recode platform names
quality_data <- quality_data %>%
  mutate(platform = recode(platform,
                           "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)" = "[HG-U133_Plus_2]",
                           "[HG-U133_Plus_2 ] Affymetrix Human Genome U133 Plus ( GPL570)" = "[HG-U133_Plus_2]",
                           "HG-U133_Plus_2" = "[HG-U133_Plus_2]",
                           "[HG-U133A] Affymetrix Human Genome U133A Array (GPL96)" = "[HG-U133A]",
                           "HG-U133A" = "[HG-U133A]",
                           "[HG -U133_Plus ] Affymetrix Human Genome U133 Plus Array" = "[HG-U133_Plus_2]",
                           "[Hg -U1133a ] AFFYMETRIX HUMAN genome array" = "[HG-U133A]",
                           "[Hg -U1133_plus ] AFFYMETRIX HUMAN genome array" = "[HG-U133_Plus_2]",
                           "[Hugène -20_st ] AFFYMETRIX HUMAN gene array" = "[HuGene-2_0-st]",
                           "[HuGene -1 _st ] Affymetrix Human Gene ( GPL6244)" = "[HuGene-1_0-st]",
                           "[HuGene -1 _st ] Affymetrix Human Gene Array ( GPL6244)" = "[HuGene-1_0-st]",
                           "[HuEx -1 _st ] Affymetrix Human Exon Array ( GPL5175)" = "[HuEx-1_0-st]",
                           "[Huex -10_st ] AFFYMETRIX HUMAN exon array" = "[HuEx-1_0-st]",
                           "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)" = "[MoGene-1_0-st]",
                           "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [CDF: MoGene10stv1_Mm_ENTREZG_14.1.0] (GPL13730)" = "[MoGene-1_0-st]",
                           "[MoGene -1 _st ] Affymetrix Mouse Gene Array ( GPL6246)" = "[MoGene-1_0-st]",
                           "[MoGene -1 _st ] AffyMetriX MOUSE Gene Array" = "[MoGene-1_0-st]",
                           "[Mogène -10_st ] AFFYMETRIX MOUSE gene array" = "[MoGene-1_0-st]",
                           "[Mouse430_2] Affymetrix Mouse Genome 430 2.0 Array (GPL1261)" = "[Mouse430_2]",
                           "Mouse430_2" = "[Mouse430_2]",
                           "[Mouse430 ] Affymetrix Mouse Genome Array" = "[Mouse430_2]",
                           "[Clariom_S_Human] Affymetrix Clariom S Assay, Human (Includes Pico Assay) (GPL23159)" = "[Clariom_S_Human]",
                           "[Clariom_S_Mouse_HT] Affymetrix Clariom S Assay HT, Mouse (Includes Pico Assay) (GPL24242)" = "[Clariom_S_Mouse_HT]",
                           "[HTA-2_0] Affymetrix Human Transcriptome Array 2.0 [transcript (gene) version] (GPL17586)" = "[HTA-2_0]",
                           "[MG_U74Av2] Affymetrix Murine Genome U74A Version 2 Array (GPL81)" = "[MG_U74v2]",
                           "[MG_U74Bv2] Affymetrix Murine Genome U74B Version 2 Array (GPL82)" = "[MG_U74v2]",
                           "MG_U74Av2" = "[MG_U74v2]",
                           "MG_U74Bv2" = "[MG_U74v2]",
                           "HuGene-1_0-st-v1" = "[HuGene-1_0-st]",
                           "Mouse430A_2" = "[Mouse430_2]",
                           .default = platform))

# Calculate the number of unique platforms
num_facets <- length(unique(quality_data$platform))

# Get number of values above the treshold of 0.15
# above_threshold <- quality_data %>%
#   filter(value > 0.25) %>%
#   group_by(platform) %>%
#   summarise(count = n())

# total_above_threshold <- sum(above_threshold$count)

# total_values <- nrow(quality_data)
# Calculate the percentage of values above the threshold
# total_above_threshold_percentage <- (total_above_threshold / total_values) * 100

# Set the number of columns for the facets
ncol <- 4

# Calculate the number of rows needed
nrow <- ceiling(num_facets / ncol)

# Adjust the plot dimensions based on the number of facets
plot_width <- ncol * 3
plot_height <- nrow * 5
# print(quality_data)
# print(unique(quality_data$geo_id))
quality_data <- quality_data %>%
  mutate(facet_label = paste(geo_id, platform))

print(quality_data)

quality_plot <- ggplot(quality_data, aes(x = passed, fill = passed)) +
                  geom_bar() +
                  scale_fill_manual(values = c("TRUE" = "#0000FF", "FALSE" = "#FFA500"), 
                   labels = c("TRUE" = "Non-Outlier", "FALSE" = "Outlier")) +
                  labs(title = "Distribution of Quality Values (Outliers vs Non-Outliers)",
                  x = "Status",
                  y = "Count",
                  fill = "Status") +
                  theme_minimal() +
                  theme(strip.background = element_rect(fill = "lightgray"),
                  strip.text = element_text(face = "bold", size = 10),
                  )
                #   facet_wrap(~ facet_label, ncol = ncol, scales = "free_y")
                               


ggsave("Data/Graphs/QualityGraphs/quality_plot_GSE_total.png", plot = quality_plot, width = plot_width, height = plot_height)  # Adjust width and height as needed

# print(paste("Number of values above the treshold per platform:", above_threshold))
# print(paste("Unique platforms:", unique(quality_data$platform)))
# print(paste("Total number of values above the threshold:", total_above_threshold))
# print(paste("Total number of values:", total_values))
# print(paste("Percentage of values above the threshold:", total_above_threshold_percentage, "%"))