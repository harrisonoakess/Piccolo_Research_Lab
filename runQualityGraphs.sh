# docker run -i -t --rm -v "$(pwd)":/my_dir --user $(id -u):$(id -g) bioc_curation Rscript GettingData/GettingGraphs/QualityGraphs/PlatformQuality

docker run -i -t --rm -v "$(pwd)":/my_dir --user $(id -u):$(id -g) bioc_curation Rscript GettingData/GettingGraphs/QualityGraphs/GSEQuality
# docker run -i -t --rm -v "$(pwd)":/my_dir --user $(id -u):$(id -g) bioc_curation Rscript GettingData/GettingGraphs/QualityGraphs/TotalQuality.R


# docker run -i -t --rm -v "$(pwd)":/my_dir --user $(id -u):$(id -g) bioc_curation Rscript GettingData/GettingGraphs/QualityGraphs/GSEQuality && \
# docker run -i -t --rm -v "$(pwd)":/my_dir --user $(id -u):$(id -g) bioc_curation Rscript GettingData/GettingGraphs/QualityGraphs/PlatformQuality
