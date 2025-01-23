setwd("/my_dir")

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

#------------unique gse_platforms-----------------
human_geo_ids <- c( # these are all the human GSE's (hs)
  "GSE143885",
  "GSE19681",
  "GSE65055",
  "GSE47014",
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

platform_to_package_list = list()
for (geo_id in human_geo_ids){
    untar_and_delete(geo_id)
    # formatted string for the untar output
    tar_file_output_f = sprintf("affymetrix_data/%s_RAW", geo_id)
    # List all the .CEL files in the directory
    cel_files <- list.files(path = tar_file_output_f, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
    
    
    pkgName = InstallBrainArrayPackage(cel_files[1], "25.0.0", "hs", "entrezg")
    useable_platform = platform_list[[geo_id]]
    
    platform_to_package_list[[useable_platform]] = pkgName
}
for (geo_id in mouse_geo_ids){
    untar_and_delete(geo_id)
    # formatted string for the untar output
    tar_file_output_f = sprintf("affymetrix_data/%s_RAW", geo_id)
    # List all the .CEL files in the directory
    cel_files <- list.files(path = tar_file_output_f, pattern="^[^.]*\\.CEL\\.gz$", full.names= TRUE, ignore.case = TRUE)
    
    
    pkgName = InstallBrainArrayPackage(cel_files[1], "25.0.0", "mm", "entrezg")
    useable_platform = platform_list[[geo_id]]
    
    platform_to_package_list[[useable_platform]] = pkgName
}
unlink("affymetrix_data", recursive = TRUE)
dir.create("Data/BrainArrayPackage")
platform_to_package_list_tibble = tibble(name = names(platform_to_package_list), value = unlist(platform_to_package_list))
write_tsv(platform_to_package_list_tibble, "Data/BrainArrayPackage/platform_to_package_list", quote = "all")