### Getting Ploidy, Cell Type, and Sex ###

Our goal here is to pull the three types of infomration. The problem is that they are in different columns depending on the file. The following steps will be taken to copmlete this goal.

- **First:** Create a new Tibble with the information we want to keep (Sex, Ploidy, Cell Type)

- **Second:** Read each row of the tibble that contains the research data, if it contains a key word (Trisomony, disomony, F, M , Female, Male) then it will append to the new tibble we made
  indicating that the information is present.
  - We will use regex to go through the lines, and if there is no matches (There will be some files without the needed matches), then it will be auto filled to NA

ex. 

![image](https://github.com/user-attachments/assets/a3815c0c-abe6-48a2-b753-a2e178c003e2)

### 9/26/24 notes ###

- We want to get only EOF in the yaml file, but we may need to write a script to go thorugh line by line and replace anything that is not EOF (ex. PATO works, but we want to avoid using different libraries, CHEBI is innacurate and not what we want)
- For cell type, we want to get the ontology reference in the column with the original data. This way there is a reference to the original collected data, while createing a standardized way to find data.

## 10/3/24 notes ##
- Entrez
- GSE110064
- GSE11877
- only keep CEL.gz and get rid of CHP
- geoquery
- use geoquery to download the package use code from wishbuilder as an example, after we have the cell package use SCAN.UPC (biocunducter) package by Piccolo
- read the primer and understand how it works, use scan.upc to normalize the documents, but not to get the data from the website, use geoquery to get the data and filter out.
- We will have to download all the files, unzip it, and figure out what we want to keep cel vs chp
- start with the first 10ish files and get it working, then as it starts to work, move to dojo to counter the speed
- when you run scan there is a setting maybe convergence default is .01 change to 1 and it will process faster
- processing the meta data for other types of data could fill the time while waiting for large data sets to process
- after we process the meta data lets figure out how we will expand it to other meta data variables

  ## 10/10/24 notes ##

  ### Questions ###
  - What is the best way to oragnized downloaded files without having to commit everything to github?
  - ask about the order of the download/zip and why its not deleting (probably because the file is running in the background)
  - What is the best way to read in the CEL files, at what point do we use the SCAN.UPC package
 
## 10/17/24 notes ##
- make it so the libraries do not donwload everytime
- after we load the libraries, we want to donwload the smallest dataset representing each unique platform that is found in each dataset, then install brain array package for each of those, then save the package name into a list for each of those.
- Make a conditional to check what kind of platform it is, then run scan with a specific probsummarypackage.
- finish writing the script so normalized is saved as a file, use expr() to get a matrix from normalized, then we can edit column names, and the row names. We want to remove everything after the GSE ID. Then from there we can save it into a TSV.
- Then use Bioconductor quality control library, which rates the quality of the files, then we can have a tsv of each file, and what the quality is. This would be put into the code before SCAN.
- Use the google sheets from Dr. Piccolo to figure out what files are good and which ones are bad and to figure out the different platforms (see above)
- Docker container... good luck

 Unique platforms and smallest dataset:
Affymetrix GeneChip Human Genome U133A 2.0 [HG-U133A_2]
[HG-U133_Plus_2] Affymetrix Human Genome U133 Plus 2.0 Array (GPL570)
[MG_U74Av2] Affymetrix Murine Genome U74A Version 2 Array (GPL81)
[MG_U74Bv2] Affymetrix Murine Genome U74B Version 2 Array (GPL82)
[Clariom_S_Human] Affymetrix Clariom S Assay, Human (Includes Pico Assay) (GPL23159)
[HG-U133A] Affymetrix Human Genome U133A Array (GPL96)
[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [transcript (gene) version] (GPL6246)
[MoGene-1_0-st] Affymetrix Mouse Gene 1.0 ST Array [CDF: MoGene10stv1_Mm_ENTREZG_14.1.0] (GPL13730)
[HTA-2_0] Affymetrix Human Transcriptome Array 2.0 [transcript (gene) version] (GPL17586)
[Mouse430_2] Affymetrix Mouse Genome 430 2.0 Array (GPL1261)
[Clariom_S_Mouse_HT] Affymetrix Clariom S Assay HT, Mouse (Includes Pico Assay) (GPL24242)
[HuGene-1_0-st] Affymetrix Human Gene 1.0 ST Array [transcript (gene) version] (GPL6244)
[HuEx-1_0-st] Affymetrix Human Exon 1.0 ST Array [transcript (gene) version] (GPL5175)
[PrimeView] Affymetrix Human Gene Expression Array (GPL15207)
[HuGene-2_0-st] Affymetrix Human Gene 2.0 ST Array [HuGene20stv1_Hs_ENTREZG_17.0.0] (GPL17930)
GSE65055





