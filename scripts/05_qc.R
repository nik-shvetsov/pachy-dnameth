# 05_qc
library(minfi)
#
args <- commandArgs(trailingOnly = TRUE)
opt <- list()
opt$input <- args[1]
opt$output <- args[2]

meta.qcOutput.file <- gsub("//","/",file.path(opt$output, "qcReport.pdf"))

RGset.clean <- readRDS(file.path(opt$input, 'rgset_clean.rds'))

# RGset.CN.bg
qcReport(RGset.clean, pdf = meta.qcOutput.file)
# END 05_qc
