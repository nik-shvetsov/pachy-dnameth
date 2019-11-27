# 00_load_data
library(minfi)
library(IlluminaHumanMethylationEPICanno.ilm10b2.hg19)
library(IlluminaHumanMethylationEPICmanifest)

args <- commandArgs(trailingOnly = TRUE)
opt <- list()
opt$input <- args[1]
opt$output <- args[2]

meta.base.idat.dir <- opt$input #"/pfs/input_idat"
meta.samplesheet.dir <- opt$input #"/pfs/input_idat"

meta.output.rgset.file <- gsub("//","/",file.path(opt$output, "rgset.rds"))
meta.output.manifest.file <- gsub("//","/",file.path(opt$output, "manifest.rds"))
meta.output.annotation.file <- gsub("//","/",file.path(opt$output, "annotation.rds"))

## "Find" sample sheet
targets <- read.metharray.sheet(meta.samplesheet.dir)

## Read iDat files
RGset <- read.metharray.exp(targets = targets, verbose = TRUE, force = TRUE)
                            # base = meta.base.idat.dir

## Get manifest
manifest <- getManifest(RGset)
annotation <- as.data.frame(getAnnotation(RGset))

saveRDS(RGset, file = meta.output.rgset.file)
saveRDS(manifest, file = meta.output.manifest.file)
saveRDS(annotation, file = meta.output.annotation.file)
# END 00_load_data
