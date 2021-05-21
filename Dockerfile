FROM satijalab/seurat

LABEL Image for SEURAT

#miscellaneous
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    libhdf5-dev \   
    tabix \
    git \
    python3-dev \
    python3-pip \ 
    build-essential \
    cmake \
    git \
    libbamtools-dev \
    libboost-dev \
    libboost-iostreams-dev \
    libboost-log-dev \
    libboost-system-dev \
    libboost-test-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libz-dev \
    curl 



# R and bioconductor packages #

RUN \
R -e 'chooseCRANmirror(ind=52); install.packages(c("Rcpp","RcppArmadillo", "Matrix", "BiocManager", "mgcv", "abind","igraph","h5","Rtsne","cluster","data.table","RColorBrewer","alphahull"))'
RUN Rscript -e "install.packages('devtools')"
RUN Rscript -e "install.packages('remotes')"

## install bioconductor packages
ADD r-bioconductor.R /tmp/
RUN R -f /tmp/r-bioconductor.R


RUN Rscript -e "BiocManager::install('monocle')"


RUN Rscript -e "remotes::install_github('satijalab/seurat-wrappers')"
RUN Rscript -e 'devtools::install_github("velocyto-team/velocyto.R")'
RUN Rscript -e 'devtools::install_github("immunogenomics/harmony")'

## install useful packages
ADD r-misc.R /tmp/
RUN R -f /tmp/r-misc.R

RUN Rscript -e "install.packages('cowplot')"
RUN Rscript -e "install.packages('ggpubr')"

RUN pip3 install setuptools 

#ADD SCEPrep-master 
COPY SCEPrep-master /tmp/SCEPrep-master
RUN Rscript -e 'devtools::install("/tmp/SCEPrep-master")'
