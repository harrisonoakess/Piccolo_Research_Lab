FROM bioconductor/bioconductor:RELEASE_3_20

ADD install_packages.R /

RUN Rscript /install_packages.R

WORKDIR /my_dir