install.packages("RPMM")

if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install()

#source("https://bioconductor.org/biocLite.R")
#BiocInstaller::biocLite("RnBeads")

BiocManager::install("minfi") 
BiocManager::install("IlluminaHumanMethylationEPICanno.ilm10b2.hg19")
BiocManager::install("IlluminaHumanMethylationEPICmanifest")
BiocManager::install("wateRmelon")
BiocManager::install("DNAcopy")
BiocManager::install("sva") 
#BiocManager::install("AnnotationHub")
#BiocManager::install("ExperimentHub") # version = "devel", update = TRUE, ask = FALSE


# BiocManager::install("FlowSorted.Blood.EPIC") # version = "devel", update = TRUE, ask = FALSE

BiocManager::install(update = TRUE, ask = FALSE)

library(devtools)
install_github("perishky/meffil")
install("/install_scripts/CopyNumber450kData", quick=TRUE)
install_github("Bioconductor/AnnotationHub")
install_github("Bioconductor/ExperimentHub")


BiocManager::install("FlowSorted.Blood.450k")
# BiocManager::install("FlowSorted.Blood.EPIC") # version = "devel", update = TRUE, ask = FALSE
install("/install_scripts/FlowSorted.Blood.EPIC", quick=TRUE)

options(BIOCONDUCTOR_ONLINE_VERSION_DIAGNOSIS = FALSE)

# Preload data from ExperimentHub to cache
library(AnnotationHub)
library(ExperimentHub)
setExperimentHubOption("CACHE", "/data/cache/ExperimentHub")
# setExperimentHubOption("LOCAL", T)

hub <- ExperimentHub()
query(hub, "FlowSorted.Blood.EPIC")
FlowSorted.Blood.EPIC <- hub[["EH1136"]]

RGsetTargets <- FlowSorted.Blood.EPIC[,
             FlowSorted.Blood.EPIC$CellType == "MIX"]  
             
sampleNames(RGsetTargets) <- paste(RGsetTargets$CellType,
                            seq_len(dim(RGsetTargets)[2]), sep = "_")  
data(IDOLOptimizedCpGs) 
