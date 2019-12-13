This document describes DNA-methilation data preprocessing pipeline used in UiT. It is inspired by DNAm scripts, written by Christian Page.
Link for the whole pipeline and docker image repo: https://github.com/nsh23/pachy-dnameth

- Whole pipeline is in R and consists of 7 steps:
1) Load dataset - load RGSet and samplesheet
2) Clean data - remove ghost and cross-hybrid probes
3) BMIQ normalization, background correction and cell counts estimation
4) CNV calculation based on algorithm implementation in CopyNumber450k package
5) SVA - factor and variable estimation
6) Quality control of clean data
7) Gene annotation to CpG sites

The following graph describes the processing flow in a pipeline and step dependencies:
![Pipeline graph](img/dnam_pachy_pipe.png)

- Requirements:
R, minfi, CopyNumber450k, IlluminaHumanMethylationEPICanno.ilm10b2.hg19, IlluminaHumanMethylationEPICmanifest,
wateRmelon, RPMM, parallel, ExperimentHub, FlowSorted.Blood.EPIC, FlowSorted.Blood.450k, sva, DNAcopy, meffil

- Additional notes:
The pipeline was exported to pachyderm framework and tested in HUNT cloud.
It took ~4 hours for a Torino_2017 NOWAC dataset.
