FROM nikshv/p-r-base:3.6

LABEL base="p-r-base"
LABEL version="3.6"
LABEL software="DNAmeth-pipeline"
LABEL software.version="1.0"
LABEL description="R environment for working DNA methilation processing scripts"
LABEL website=""
LABEL documentation=""
LABEL licence="https://www.r-project.org/Licenses/"

MAINTAINER Shvetsov Nikita <shvetsov.nikita@uit.no>

RUN mkdir /install_scripts
COPY install.R /install_scripts/install.R
COPY FlowSorted.Blood.EPIC /install_scripts/FlowSorted.Blood.EPIC

ENV CNDVER 1.10.0

RUN wget http://bioconductor.riken.jp/packages/3.4/data/experiment/src/contrib/CopyNumber450kData_${CNDVER}.tar.gz && \
tar -zxvf CopyNumber450kData_${CNDVER}.tar.gz && \
mv CopyNumber450kData /install_scripts/ && \
rm -rf CopyNumber450kData_${CNDVER}.tar.gz && \
# mkdir -p ~/.cache/ExperimentHub
mkdir -p /data/cache/ExperimentHub


RUN Rscript /install_scripts/install.R && rm -rf /install_scripts

COPY ./scripts/* /tools/
COPY dnameth.py /tools/

CMD ["R"]
