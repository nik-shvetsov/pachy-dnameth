# 02_bmiq
options(BIOCONDUCTOR_ONLINE_VERSION_DIAGNOSIS = FALSE)

library(minfi)
library(wateRmelon)
library(dplyr)
library(RPMM)
library(parallel)
library(ExperimentHub)
library(FlowSorted.Blood.EPIC)
library(FlowSorted.Blood.450k)

args <- commandArgs(trailingOnly = TRUE)
opt <- list()
opt$input <- args[1]
opt$output <- args[2]
opt$anno <- args[3]
opt$ehub <- args[4]

meta.pdata.file <- gsub("//","/",file.path(opt$output, "pdata.rds"))
meta.bmat.bmiq.file <- gsub("//","/",file.path(opt$output, "bmat_bmiq.rds"))
meta.estimatedAge.file <- gsub("//","/",file.path(opt$output, "estimatedAge.rds"))
meta.Ill.rgset.cn.bg.file <- gsub("//","/",file.path(opt$output, "rgset_cn_bg.rds"))
meta.omega.conv450k.file <- gsub("//","/",file.path(opt$output, "omega.conv450k.rds"))
meta.omega.file <- gsub("//","/",file.path(opt$output, "omega.rds"))

bmat <- readRDS(file.path(opt$input, 'bmat.rds'))
RGset.bg.clean <- readRDS(file.path(opt$input, 'rgset_bg_clean.rds'))
RGset.clean <- readRDS(file.path(opt$input, 'rgset_clean.rds'))
annotation <- readRDS(file.path(opt$anno, 'annotation.rds'))
#eh1136 <- readRDS(file.path(opt$ehub, 'EH1136.rds'))
#eh2256 <- readRDS(file.path(opt$ehub, 'EH2256.rds'))

design.v <- as.integer(as.factor(annotation[rownames(RGset.bg.clean), 9]))

print ('pData')
pdata <- pData(RGset.bg.clean)

print ('Using cluster...')
# CPU and RAM intensive. Consider using makeCluster()

cl <- makeCluster(16, "PSOCK")
clusterEvalQ(cl, library(wateRmelon))
bmat.bmiq <- parApply(cl, bmat, 2, function(x,v) BMIQ(x, design.v = v, pri = FALSE, plots = FALSE)$nbeta, v = design.v)
# library (pbapply); bmat.bmiq <- pbapply(bmat, 2, function(x,v) BMIQ(x, design.v = v, pri = FALSE)$nbeta, v = design.v)
stopCluster(cl)
print ('Stopping cluster...')

print ('agep')
estimatedAge <- agep(bmat.bmiq)

print ('preprocessIllumina')
# preprocessIllumina returns a MethylSet, while bgcorrect.illumina and
# normalize.illumina.control both return a RGChannelSet with corrected color channels

# RGset.CN.bg <- preprocessIllumina(RGset.clean, bg.correct = TRUE, normalize = "controls")
RGset.CN <- normalize.illumina.control(RGset.clean, reference = 1)
RGset.CN.bg <- bgcorrect.illumina(RGset.CN)
# pdata <- pData(RGset.CN.bg)

## Calculate Omega, age based on RGset.control.norm
print ('estimateCellCounts')
# estimateCellCounts(RGset.CN.bg) ? (RGset.bg.clean)

print ('estiamteCellCounts with converting to 450k')
blood.subset <- RGset.CN.bg %>%
  convertArray("IlluminaHumanMethylationEPIC") %>%
  convertArray("IlluminaHumanMethylation450k")
omega.conv450k <- estimateCellCounts(blood.subset, returnAll=TRUE)

# Using refs from Experiment Hub and FlowSorted.Blood.EPIC

# NOTE: using modified version of FlowSorted.Blood.EPIC, it has .rds locally
print ("estimateCellCounts2")
omega <- estimateCellCounts2(RGset.CN.bg, opt$ehub,
	compositeCellType = "Blood",
	processMethod = "auto", probeSelect = "auto",
	cellTypes = c("CD8T", "CD4T", "NK", "Bcell", "Mono", "Neu"),
	referencePlatform = "IlluminaHumanMethylationEPIC", verbose = TRUE)

saveRDS(pdata, file = meta.pdata.file)
saveRDS(bmat.bmiq, file = meta.bmat.bmiq.file)
saveRDS(estimatedAge, file = meta.estimatedAge.file)
saveRDS(RGset.CN.bg, file = meta.Ill.rgset.cn.bg.file)
saveRDS(omega.conv450k, file = meta.omega.conv450k.file)
saveRDS(omega, file = meta.omega.file)
# END 02_bmiq
