# docker run -i -t --rm -v "$(pwd)":/my_dir --user $(id -u):$(id -g) bioc_curation R

docker run -i -t --rm -v "$(pwd)":/my_dir --user $(id -u):$(id -g) bioc_curation Rscript GettingData/getting_affymetrix_data_docker_file.R
