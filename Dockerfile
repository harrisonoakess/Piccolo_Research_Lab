FROM bioconductor/bioconductor:RELEASE_3_18

ADD install_core_packages.R /

RUN Rscript /install_core_packages.R

ADD install_array_packages.R /

RUN Rscript /install_array_packages.R

WORKDIR /my_dir