total_start_time = Sys.time()
options(timeout = max(300, getOption("timeout")))
#--------------------libraries--------------------
library(GEOquery)
library(affy)
library(tidyverse)
library(BiocManager)
library(tidyverse)
library(SCAN.UPC) 
library(lubridate)
library(arrayQualityMetrics)


# if (!require("BiocManager", quietly = TRUE)) 
  install.packages("arrayQualityMetrics")
# BiocManager::install("SCAN.UPC")
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("GEOquery")
  # if (!require("BiocManager", quietly = TRUE))
  #   install.packages("BiocManager")
  BiocManager::install("clariomshumancdf")
  # 
  # BiocManager::install("arrayQualityMetrics")

#--------------------data--------------------
geofiles = c("GSE143885")

# geofiles = c('GSE1397', 'GSE138861', "GSE143885", "GSE149459", "GSE149460")

# geofiles = c("GSE110064", "GSE11877", "GSE1281", "GSE1282", "GSE1294", "GSE138861", "GSE1397", "GSE143885", "GSE149459", "GSE149460",
# "GSE149461", "GSE149462", "GSE149463", "GSE149464", "GSE149465", "GSE158376", "GSE158377", "GSE1611", "GSE16176", "GSE16676",
# "GSE16677", "GSE168111", "GSE17459", "GSE17760", "GSE1789", "GSE19680", "GSE19681", "GSE19836", "GSE20910", "GSE222355",
# "GSE30517", "GSE61804", "GSE35561", "GSE35665", "GSE36787", "GSE39159", "GSE4119", "GSE47014", "GSE48611", "GSE49050",
# "GSE49635", "GSE5390", "GSE59630", "GSE62538", "GSE6283", "GSE65055", "GSE70102", "GSE83449", "GSE84887", "GSE99135")

#------------list of GEOs and Platforms----------
platform_list <- list(
  "E-MEXP-3355" = "Affymetrix GeneChip Mouse Gene 1.0 ST Array [MoGene-1_0-st-v1]",
  "E-MEXP-409" = "Affymetrix GeneChip Human Genome HG-U133A [HG-U133A]",
  "E-MEXP-654" = "Affymetrix GeneChip Murine Genome U74Av2 [MG_U74Av2]",
  "E-MEXP-72" = "Affymetrix GeneChip Human Genome HG-U133A [HG-U133A]",
  "E-MTAB-1238" = "Affymetrix GeneChip Human Genome U133 Plus 2.0 [HG-U133_Plus_2]",
  "E-MTAB-312" = "Affymetrix GeneChip Human Genome U133A 2.0 [HG-U133A_2]",
  "GSE110064" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE11877" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE1281" = "[MG_U74Av2] Affymetrix Murine Genome U74A Version 2 Array (GPL81)",
  "GSE1282" = "[MG_U74Bv2] Affymetrix Murine Genome U74B Version 2 Array (GPL82)",
  "GSE1294" = "[MG_U74Av2] Affymetrix Murine Genome U74A Version 2 Array (GPL81)",
  "GSE138861" = "[Clariom_S_Human] Affymetrix Clariom S Assay, Human (Includes Pico Assay) (GPL23159)",
  "GSE1397" = "[HG-U133A] Affymetrix Human Genome U133A Array (GPL96)",
  "GSE143885" = "[Clariom_S_Human] Affymetrix Clariom S Assay, Human (Includes Pico Assay) (GPL23159)",
  "GSE149459" = "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)",
  "GSE149460" = "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)",
  "GSE149461" = "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)",
  "GSE149462" = "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)",
  "GSE149463" = "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)",
  "GSE149464" = "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)",
  "GSE149465" = "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)",
  "GSE158376" = "[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [CDF: MoGene10stv1_Mm_ENTREZG_14.1.0] (GPL13730)",
  "GSE158377" = "[HTA-2_0] Affymetrix Human Transcriptome Array 2.0 [transcript (gene) version] (GPL17586)",
  "GSE1611" = "[MG_U74Av2] Affymetrix Murine Genome U74A Version 2 Array (GPL81)",
  "GSE16176" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE16676" = "[Mouse430_2] Affymetrix Mouse Genome 430 2.0 Array (GPL1261)",
  "GSE16677" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE168111" = "[HTA-2_0] Affymetrix Human Transcriptome Array 2.0 [transcript (gene) version] (GPL17586)",
  "GSE17459" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE17760" = "[Mouse430_2] Affymetrix Mouse Genome 430 2.0 Array (GPL1261)",
  "GSE1789" = "[HG-U133A] Affymetrix Human Genome U133A Array (GPL96)",
  "GSE19680" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE19681" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE19836" = "[Mouse430_2] Affymetrix Mouse Genome 430 2.0 Array (GPL1261)",
  "GSE20910" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  
  "GSE222355"=	"[Clariom_S_Mouse_HT]	Affymetrix Clariom S Assay HT, Mouse	(Includes Pico Assay)	(GPL24242)",	
  "GSE30517"=	"[HG-U133A]	Affymetrix Human Genome U133A	Array	(GPL96)",	
  "GSE61804"=	"[HG-U133_Plus_2 ]	Affymetrix Human Genome	U133 Plus	( GPL570)",	
  "GSE35561"=	"[HuGene -1 _st ]	Affymetrix	Human	Gene	( GPL6244)",	
  "GSE35665"=	"[HuEx -1 _st ]	Affymetrix	Human Exon	Array	( GPL5175)",	
  "GSE36787"=	"[HuGene -1 _st ]	Affymetrix	Human	Gene	Array	( GPL6244)",	
  "GSE39159"=	"[MoGene -1 _st ]	Affymetrix	Mouse	Gene	Array	( GPL6246)",	
  "GSE4119"=	"[HG -U133A ]	Affymetrix	Human	Genome	Array	( GPL96)",	
  "GSE47014"=	"[PrimeView ]	Affymetrix	Human	Gene Expression	Array	( GPL15207)",	
  "GSE48611"=	"[HG -U133_Plus ]	Affymetrix	Human	Genome	U133 Plus	Array",	
  "GSE49050"=	"[Mouse430 ]	Affymetrix	Mouse	Genome	Array",	
  "GSE49635"=	"[MoGene -1 _st ]	AffyMetriX	MOUSE	Gene	Array",	
  "GSE539"=	"[Hg -U1133a ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE59630"=	"[Huex -10_st ]	AFFYMETRIX	HUMAN	exon	array",	
  "GSE62538"=	"[Mogène -10_st ]	AFFYMETRIX	MOUSE	gene	array",	
  "GSE6283"=	"[Hg -U1133_plus ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE65055"=	"[Hugène -20_st ]	AFFYMETRIX	HUMAN	gene	array",	
  "GSE70102"=	"[Hg -U1133_plus ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE83449"=	"[Hg -U1133a ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE84887"=	"[Hg -U1133_plus ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE99135"=	"[Mogène -10_st ]	AFFYMETRIX	MOUSE	gene	array"
)

print(platform_list$"GSE99135")


#------------unique gse_platforms-----------------
# target_geo_ids <- c( # combined list of Human and Mouse GSE's
#   "GSE143885", 
#   "GSE1282", 
#   "GSE1281", 
#   "GSE19681", 
#   "GSE65055", 
#   "GSE47014", 
#   "GSE35665", 
#   "GSE36787", 
#   "GSE222355", 
#   "GSE16676", 
#   "GSE168111", 
#   "GSE158376", 
#   "GSE39159", 
#   "GSE5390"
# )

target_geo_ids <- c( # these are all the human GSE's (hs)
  "GSE143885",
  "GSE19681",
  "GSE65055",
  "GSE47014",
  "GSE35665",
  "GSE36787",
  "GSE168111",
  "GSE30517"
)

# target_geo_ids <- c("GSE1282", # These are all the Mouse GSE's (mu)
#                     "GSE1281", 
#                     "GSE222355", 
#                     "GSE16676", 
#                     "GSE158376", 
#                     "GSE39159"
# )

#------------------functions----------------------

quality_control_removal <- function(cel_dir_path){
  cel_file_paths = list.celfiles(cel_dir_path, listGzipped = TRUE, full.name = TRUE)
  cel_files = read.celfiles(cel_file_paths)
  test_results = arrayQualityMetrics(expressionset = cel_files)
}

clean_normalized <- function(normalized){ # I dont think this is needed
  normalized_tibble = as.tibble(normal)
}

get_brain_array_packages <- function(target_geo_ids, platform_list){
  if (!file.exists("Data/BrainArrayPackage")){
    platform_to_package_list = list()
    for (geo_id in target_geo_ids){
      untar_and_delete(geo_id)
      # formatted string for the untar output
      tar_file_output_f = sprintf("affymetrix_data/%s_RAW", geo_id)
      # List all the .CEL files in the directory
      cel_files <- list.files(path = tar_file_output_f, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
      
      pkgName = InstallBrainArrayPackage(cel_files[1], "25.0.0", "hs", "entrezg")
      # print(pkgName)
      useable_platform = platform_list[[geo_id]]
      # print(platform_to_package_list)
      
      platform_to_package_list[[useable_platform]] = pkgName
    }
    unlink("affymetrix_data", recursive = TRUE)
    dir.create("Data/BrainArrayPackage")
    platform_to_package_list_tibble = tibble(name = names(platform_to_package_list), value = unlist(platform_to_package_list))
    write_tsv(platform_to_package_list_tibble, "Data/BrainArrayPackage/platform_to_package_list", quote = "all")
    return(platform_to_package_list)
  }
  else{
    print("test")
    platform_to_package_tibble_from_tsv = read_tsv("Data/BrainArrayPackage/platform_to_package_list", 
                                                   col_types = cols(.default = col_character()), quote = "\"")
    platform_to_package_list_from_tsv = setNames(as.list(platform_to_package_tibble_from_tsv$value), platform_to_package_tibble_from_tsv$name)
    return (platform_to_package_list_from_tsv)
  }
}

untar_and_delete <- function(geo_id) {
  
  if (!file.exists(geo_id)){
    # Download supplementary files
    print(paste("Downloading", geo_id))
    getGEOSuppFiles(geo_id)
    print("Download Successful")
  }
  
  # formated string for the untar
  tar_file_f = sprintf("%s/%s_RAW.tar", geo_id, geo_id)
  
  # formated string for the untar output
  tar_file_output_f = sprintf("affymetrix_data/%s_RAW", geo_id)
  
  if (length(list.files(geo_id)) == 0){
    unlink(geo_id, recursive = TRUE)
    unlink(tar_file_output_f, recursive = TRUE)
    return()
  }
  
  # Extract the tar file
  untar(tar_file_f, exdir = tar_file_output_f)
  print("Unzip Successfull")
  
  # Deletes the file with the zipped files
  unlink(geo_id, recursive = TRUE)
  
  # List all the .CEL files in the directory
  cel_files <- list.files(path = tar_file_output_f, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
  
  # Make a list of the first 10 files
  cel_files = c(cel_files[1:10])
  
  # Makes a list of all files that are not in the above cel_files vector
  files_to_delete <- setdiff(list.files(tar_file_output_f, full.names= TRUE), cel_files)
  
  # print(files_to_delete)
  
  # Deletes all files in the files_to_delete
  if (length(files_to_delete) > 0) {
    file.remove(files_to_delete)
  }
}

get_scan_upc_files <- function(geo_id, platform_to_package_list){
  # formated string for the untar
  tar_file_f = sprintf("%s/%s_RAW.tar", geo_id, geo_id)
  
  # formated string for the untar output
  tar_file_output_f = sprintf("affymetrix_data/%s_RAW", geo_id)
  
  if (!file.exists(tar_file_output_f)){
    untar_and_delete(geo_id)
    print('untar successful')
  }
  
  # Sets the file pattern to .CEL, so scan pulls everything with that ending
  celFilePattern <- file.path(tar_file_output_f, "*.CEL.gz")
  
  # formated string for the SCAN output
  scan_output_file_f = sprintf("affymetrix_data/%s_SCAN", geo_id)
  # print('test')
  
  # List all the .CEL files in the directory
  cel_files <- list.files(path = tar_file_output_f, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
  
  # This cleans up the data and removes outliers
  quality_control_removal(tar_file_output_f)
  
  # Make a list of the first 10 files
  cel_files = c(cel_files[1:10])
  
  # pkgName = InstallBrainArrayPackage(cel_files[1], "25.0.0", "hs", "entrezg")
  # print(pkgName)
  
  # print(platform_to_package_list)
  
  platform = platform_list[[geo_id]]
  # print(platform_list)
  # print(platform)
  pkgName = platform_to_package_list[[platform]]
  # print('test2') 
  # print(pkgName)
  # last step to converting the information
  normalized = SCAN(celFilePattern, convThreshold = .9, probeLevelOutDirPath = NA, probeSummaryPackage=pkgName)
  # clean_normalized(normalized)
  # View(normalized)
  # print('test3')
  
  # Delete the RAW file
  # unlink(tar_file_output_f, recursive = TRUE)
  return (normalized)
  
}

format_time_diff <- function(time_diff) {
  hours <- floor(as.numeric(time_diff, units="hours"))
  minutes <- floor(as.numeric(time_diff, units="mins") %% 60)
  seconds <- floor(as.numeric(time_diff, units="secs") %% 60)
  milliseconds <- round((as.numeric(time_diff, units="secs") %% 1) * 1000)
  
  sprintf("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
}

save_normalized_file <- function(geo_id, normalized){
  normalized_tibble = as_tibble(normalized)
  normalized_tibble = normalized_tibble %>%
  rename_with(
    ~str_extract(., "\\d+"),
    everything()
  )

  test_dataframe = as.data.frame(normalized)
  normalized_row_names = c(rownames(test_dataframe))
  new_names = str_extract(normalized_row_names, "GSM\\d+")

  final_tibble = normalized_tibble %>%
    add_column("Sample_ID" = new_names, .before = 1)
  tibble_file_location = paste0("Data/Affymetrix/", geo_id, ".tsv.gz")
  write_tsv(final_tibble, tibble_file_location)
}

#-------------------Script-------------------------
platform_to_package_list = get_brain_array_packages(target_geo_ids, platform_list)
# print(platform_to_package_list)
for (geo_id in geofiles){
  file_start_time = Sys.time()
  normalized = get_scan_upc_files(geo_id, platform_to_package_list)
  save_normalized_file(geo_id, normalized)
  # unlink("affymetrix_data", recursive = TRUE)
  file_end_time = Sys.time()
  total_file_time = file_end_time - file_start_time
  print(paste('File download time: ', format_time_diff(total_file_time)))
}
total_end_time = Sys.time()
total_time = total_end_time - total_start_time
print(paste('Total time: ', format_time_diff(total_time)))

# print(get_brain_array_packages(target_geo_ids, platform_list))

# BiocManager::install("pd.clariom.s.human")
# 
# install.packages("cli", type = "binay")

# cel_dir_path = "affymetrix_data/GSE143885_RAW"
#cel_file_paths = list.files(cel_dir_path)

# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("pd.clariom.s.human")

# cel_file_paths = list.celfiles(cel_dir_path, listGzipped = TRUE, full.name = TRUE)
# cel_files = read.celfiles(cel_file_paths)
# test_results = arrayQualityMetrics(expressionset = cel_files)#, outdir = )
