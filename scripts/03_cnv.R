# 03_cnv
library(DNAcopy)
library(CopyNumber450kData)
library(meffil)

# options(mc.cores=16)

args <- commandArgs(trailingOnly = TRUE)
opt <- list()
opt$input <- args[1]
opt$output <- args[2]

meta.samplesheet.dir <- opt$input

meta.cnv.file <- gsub("//","/",file.path(opt$output, "cnv.rds"))

samplesheet <- meffil.create.samplesheet(meta.samplesheet.dir)
data(RGcontrolSetEx)
controls <- meffil.add.copynumber450k.references()
cnv_values <- meffil.calculate.cnv(samplesheet, cnv.reference = "copynumber450k-common", chip = "epic", verbose = T)
cnv <- meffil.cnv.matrix(cnv_values, "epic")

saveRDS(cnv, file = meta.cnv.file)
# END 03_cnv
