# Run this line to get the Quality Data
docker run -i -t --rm -v "$(pwd)":/my_dir bioc_curation Rscript getting_affymatrix_data_root.R

# Run this data for the Quality Graphs
# docker run -i -t --rm -v "$(pwd)":/my_dir bioc_curation Rscript Quality_graphs.R


# docker run -i -t --rm -v "$(pwd)":/my_dir bioc_curation ls my_dir

# docker run -it --rm bioc_curation R -f /install_array_packages.R
