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

### 10/3/24 notes ###
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
