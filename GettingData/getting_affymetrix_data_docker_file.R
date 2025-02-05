# setwd("/my_dir")
total_start_time = Sys.time()
options(timeout = max(300, getOption("timeout")))
#--------------------libraries--------------------
library(GEOquery)
library(affy)
library(tidyverse)
library(BiocManager)
library(SCAN.UPC) 
library(lubridate)
library(arrayQualityMetrics)
#--------------------data--------------------

geofiles = c("GSE143885")

# error_geo_files(, GSE17459, GSE84887, GSE1294, GSE19836, -> All the CEL files must be of the same type.
# Error in read.celfiles(cel_file_paths) : 
#   checkChipTypes(filenames, verbose, "affymetrix", TRUE) is not TRUE,
#                 GSE47014->


# geofiles = c("GSE110064", "GSE11877", "GSE1281", "GSE1282", "GSE138861", "GSE143885", "GSE149459", "GSE149460",
#              "GSE149461", "GSE149462", "GSE149463", "GSE149464", "GSE149465", "GSE158376", "GSE158377", "GSE1611", "GSE16176", "GSE16676",
#              "GSE16677", "GSE168111", "GSE17760", "GSE1789", "GSE19680", "GSE19681", "GSE20910", "GSE222355",
#              "GSE30517", "GSE61804", "GSE35561", "GSE35665", "GSE36787", "GSE39159", "GSE48611", "GSE49050",
#              "GSE49635", "GSE5390", "GSE59630", "GSE62538", "GSE6283", "GSE65055", "GSE70102", "GSE83449", "GSE99135")

# geofiles = c("GSE110064", "GSE11877", "GSE1281", "GSE1282", "GSE1294", "GSE138861", "GSE143885", "GSE149459", "GSE149460",
#              "GSE149461", "GSE149462", "GSE149463", "GSE149464", "GSE149465", "GSE158376", "GSE158377", "GSE1611", "GSE16176", "GSE16676",
#              "GSE16677", "GSE168111", "GSE17459", "GSE17760", "GSE1789","GSE47014", "GSE19680", "GSE19681", "GSE19836", "GSE20910", "GSE222355",
#              "GSE30517", "GSE61804", "GSE35561", "GSE35665", "GSE36787", "GSE39159", "GSE48611", "GSE49050",
#              "GSE49635", "GSE5390", "GSE59630", "GSE62538", "GSE6283", "GSE65055", "GSE70102", "GSE83449", "GSE84887", "GSE99135")

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
  "GSE1294" = c("[MG_U74Av2] Affymetrix Murine Genome U74A Version 2 Array (GPL81)", "[HuGene-1_0-st] Affymetrix Human Gene 1.0 ST Array [transcript (gene) version] (GPL6244)"),
  "GSE138861" = "[Clariom_S_Human] Affymetrix Clariom S Assay, Human (Includes Pico Assay) (GPL23159)",
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
  "GSE17459" = c("[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)", "[HG-U133A] Affymetrix Human Genome U133A Array (GPL96)"),
  "GSE17760" = "[Mouse430_2] Affymetrix Mouse Genome 430 2.0 Array (GPL1261)",
  "GSE1789" = "[HG-U133A] Affymetrix Human Genome U133A Array (GPL96)",
  "GSE19680" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE19681" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE19836" = c("[Mouse430_2] Affymetrix Mouse Genome 430 2.0 Array (GPL1261)", "GPL8321	[Mouse430A_2] Affymetrix Mouse Genome 430A 2.0 Array"),
  "GSE20910" = "[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)",
  "GSE222355"=	"[Clariom_S_Mouse_HT]	Affymetrix Clariom S Assay HT, Mouse	(Includes Pico Assay)	(GPL24242)",	
  "GSE30517"=	"[HG-U133A]	Affymetrix Human Genome U133A	Array	(GPL96)",	
  "GSE61804"=	"[HG-U133_Plus_2 ]	Affymetrix Human Genome	U133 Plus	( GPL570)",	
  "GSE35561"=	"[HuGene -1 _st ]	Affymetrix	Human	Gene	( GPL6244)",	
  "GSE35665"=	"[HuEx -1 _st ]	Affymetrix	Human Exon	Array	( GPL5175)",	
  "GSE36787"=	"[HuGene -1 _st ]	Affymetrix	Human	Gene	Array	( GPL6244)",	
  "GSE39159"=	"[MoGene -1 _st ]	Affymetrix	Mouse	Gene	Array	( GPL6246)",	
  "GSE47014"=	"[PrimeView ]	Affymetrix	Human	Gene Expression	Array	( GPL15207)",	
  "GSE48611"=	"[HG -U133_Plus ]	Affymetrix	Human	Genome	U133 Plus	Array",	
  "GSE49050"=	"[Mouse430 ]	Affymetrix	Mouse	Genome	Array",	
  "GSE49635"=	"[MoGene -1 _st ]	AffyMetriX	MOUSE	Gene	Array",	
  "GSE5390"=	"[Hg -U1133a ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE59630"=	"[Huex -10_st ]	AFFYMETRIX	HUMAN	exon	array",	
  "GSE62538"=	"[Mogène -10_st ]	AFFYMETRIX	MOUSE	gene	array",	
  "GSE6283"=	"[Hg -U1133_plus ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE65055"=	"[Hugène -20_st ]	AFFYMETRIX	HUMAN	gene	array",	
  "GSE70102"=	"[Hg -U1133_plus ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE83449"=	"[Hg -U1133a ]	AFFYMETRIX	HUMAN	genome	array",	
  "GSE84887"=	c("[Hg -U1133_plus ]	AFFYMETRIX	HUMAN	genome	array", "[HuGene-1_0-st] Affymetrix Human Gene 1.0 ST Array [transcript (gene) version] (GPL6244)"),	
  "GSE99135"=	"[Mogène -10_st ]	AFFYMETRIX	MOUSE	gene	array"
)

#------------unique gse_platforms-----------------
human_geo_ids <- c( # these are all the human GSE's (hs)
  "GSE143885",
  "GSE19681",
  "GSE65055",
  # "GSE47014",
  "GSE35665",
  "GSE36787",
  "GSE168111",
  "GSE30517"
)

mouse_geo_ids <- c("GSE1282", # These are all the Mouse GSE's (mm)
                   "GSE1281",
                   "GSE222355",
                   "GSE16676",
                   "GSE158376",
                   "GSE39159"
)

#------------------functions----------------------

quality_control_removal <- function(cel_dir_path){
  threshold = 0.15
  # cel_file_paths = list.celfiles(cel_dir_path, pattern = "*", full.name = TRUE)
  cel_file_paths = list.files(cel_dir_path, pattern = "*", full.name = TRUE)
  cel_files = read.celfiles(cel_file_paths)
  print(cel_files)
  test_results = arrayQualityMetrics(expressionset = cel_files, force = TRUE, outdir = "quality_output_file")
  # print(test_results)
  unlink("quality_output_file", recursive = TRUE)
  statistic_list = test_results$modules$maplot@outliers@statistic
  statistic_tibble = as_tibble(statistic_list)
  statistic_tibble = add_column(statistic_tibble, cel_file = cel_file_paths)
  
  print(dir.exists("Data/"))
  write_tsv(statistic_tibble, "Data/Affymetrix/quality_output_file.tsv", append = TRUE, col_names = FALSE)
  
  # Here we need to go into the file and delete the files based off the integers that are returned probably in a for loop
  # for (row in 1:nrow(statistic_tibble)){
    
  #   if (statistic_tibble[row, "value"] > threshold){
  #     file_for_delete = cel_file_paths[row]
  #     file.remove(file_for_delete)
  #   }
  # }
}

# get_brain_array_packages <- function(human_geo_ids, mouse_geo_ids, platform_list){
#   if (!file.exists("Data/BrainArrayPackage")){
#     platform_to_package_list = list()
#     for (geo_id in human_geo_ids){
#       untar_and_delete(geo_id)
#       # formatted string for the untar output
#       tar_file_output_f = sprintf("affymetrix_data/%s_RAW", geo_id)
#       # List all the .CEL files in the directory
#       cel_files <- list.files(path = tar_file_output_f, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
      
      
#       pkgName = InstallBrainArrayPackage(cel_files[1], "25.0.0", "hs", "entrezg")
#       useable_platform = platform_list[[geo_id]]
      
#       platform_to_package_list[[useable_platform]] = pkgName
#     }
#     for (geo_id in mouse_geo_ids){
#       untar_and_delete(geo_id)
#       # formatted string for the untar output
#       tar_file_output_f = sprintf("affymetrix_data/%s_RAW", geo_id)
#       # List all the .CEL files in the directory
#       cel_files <- list.files(path = tar_file_output_f, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
      
      
#       pkgName = InstallBrainArrayPackage(cel_files[1], "25.0.0", "mm", "entrezg")
#       useable_platform = platform_list[[geo_id]]
      
#       platform_to_package_list[[useable_platform]] = pkgName
#     }
#     unlink("affymetrix_data", recursive = TRUE)
#     dir.create("Data/BrainArrayPackage")
#     platform_to_package_list_tibble = tibble(name = names(platform_to_package_list), value = unlist(platform_to_package_list))
#     write_tsv(platform_to_package_list_tibble, "Data/BrainArrayPackage/platform_to_package_list", quote = "all")
#     return(platform_to_package_list)
#   }
#   else{
#     platform_to_package_tibble_from_tsv = read_tsv("Data/BrainArrayPackage/platform_to_package_list", 
#                                                    col_types = cols(.default = col_character()), quote = "\"")
#     platform_to_package_list_from_tsv = setNames(as.list(platform_to_package_tibble_from_tsv$value), platform_to_package_tibble_from_tsv$name)
#     return (platform_to_package_list_from_tsv)
#   }
# }
untar_and_delete <- function(geo_id) {
  if (!(geo_id %in% names(platform_list))) {
    stop(paste(geo_id, "not found in platform_list"))
  }

  if (file.exists("affymetrix_data")){
    unlink("affymetrix_data", recursive = TRUE)
  }

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
  
  # Makes a list of all files that are not in the above cel_files vector
  files_to_delete <- setdiff(list.files(tar_file_output_f, full.names= TRUE), cel_files)
  
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
    print('Untar Successful')
  }
  
  # Sets the file pattern to .CEL, so scan pulls everything with that ending
  celFilePattern <- file.path(tar_file_output_f, "*.CEL.gz")
  
  # formated string for the SCAN output
  scan_output_file_f = sprintf("affymetrix_data/%s_SCAN", geo_id)
  
  # List all the .CEL files in the directory
  cel_files <- list.files(path = tar_file_output_f, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
  
  # This cleans up the data and removes outliers
  quality_control_removal(tar_file_output_f)
  platform = platform_list[[geo_id]]
  pkgName = platform_to_package_list[[platform]]
  print(pkgName)
  
  # last step to converting the information
  # normalized = SCAN(celFilePattern, convThreshold = .9, probeLevelOutDirPath = NA, probeSummaryPackage=pkgName)
  
  # return (normalized)
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
# platform_to_package_list = get_brain_array_packages(human_geo_ids, mouse_geo_ids, platform_list)


platform_to_package_tibble_from_tsv = read_tsv("/package_info/platform_to_brain_array.tsv", 
                                                col_types = cols(.default = col_character()), quote = "\"")
platform_to_package_list = setNames(as.list(platform_to_package_tibble_from_tsv$value), platform_to_package_tibble_from_tsv$name)


if (!file.exists("Data/Affymetrix")){
  dir.create("Data/Affymetrix")
}
for (geo_id in geofiles){
  print("first for loop")
  file_start_time = Sys.time()
  split_geo_ids = c()
  if (length(platform_list[[geo_id]]) > 1){
    # if the list is a vector then it will split so it can run the for loop below
    print("maybe its here")



  }else{
    print('It got to the else')
    # if its a string, it will just add the the vector for splitting.
    split_geo_ids = c(geo_id)
  }
  for (split_id in split_geo_ids){
    print('It got to the for loop')
    
    get_scan_upc_files(geo_id, platform_to_package_list)

    # normalized = get_scan_upc_files(geo_id, platform_to_package_list)
    # save_normalized_file(geo_id, normalized)
  }
  unlink("affymetrix_data", recursive = TRUE)
  file_end_time = Sys.time()
  total_file_time = file_end_time - file_start_time
  print(paste('File download time: ', format_time_diff(total_file_time))) 
}
total_end_time = Sys.time()
total_time = total_end_time - total_start_time
print(paste('Total time: ', format_time_diff(total_time)))
