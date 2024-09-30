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
