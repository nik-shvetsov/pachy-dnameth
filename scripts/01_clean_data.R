# 01_clean_data
library(minfi)

args <- commandArgs(trailingOnly = TRUE)
opt <- list()
opt$input <- args[1]
opt$output <- args[2]
opt$cross <- args[3]

meta.crossHybrid.file <- gsub("//","/",file.path(opt$cross, "crossHybrid.txt"))

meta.bmat.file <- gsub("//","/",file.path(opt$output, "bmat.rds"))
meta.detection.pval.file <- gsub("//","/",file.path(opt$output, "detecion_pval.rds"))
meta.RGset.clean.file <- gsub("//","/",file.path(opt$output, "rgset_clean.rds"))
meta.RGset.bg.clean.file <- gsub("//","/",file.path(opt$output, "rgset_bg_clean.rds"))

RGset <- readRDS(file.path(opt$input, 'rgset.rds'))
annotation <- readRDS(file.path(opt$input, 'annotation.rds'))

OOB <- getOOB(RGset)
# Remove probes above the 99% quantile of gost probes in both color chanels
cg.out.of.band <- unique(Reduce(union,list(
                  Red = rownames(OOB$Red)[rowSums(OOB$Red) > quantile(rowSums(OOB$Red),.99)],
                  Grn = rownames(OOB$Grn)[rowSums(OOB$Grn) > quantile(rowSums(OOB$Grn),.99)])))

## McCartney, Daniel L., et al. "Identification of polymorphic and off-target probe binding sites
## on the Illumina Infinium MethylationEPIC BeadChip." Genomics Data 9 (2016): 22-24.

cg.cross <- read.table(meta.crossHybrid.file, stringsAsFactor = FALSE, header = FALSE)$V1
cg.chrY <- subset(annotation$Name, annotation$chr == "chrY")
cg.rm	<- intersect(c(cg.out.of.band, cg.cross, cg.chrY),rownames(RGset))

RGset.clean <- RGset[!rownames(RGset) %in% cg.rm, ]
detectionPval <- detectionP(RGset.clean)

RGset.bg <- preprocessNoob(RGset)
RGset.bg.clean <- RGset.bg[!rownames(RGset.bg) %in% cg.rm,]
bmat <- getBeta(RGset.bg.clean)

saveRDS(RGset.clean, file = meta.RGset.clean.file)
saveRDS(RGset.bg.clean, file = meta.RGset.bg.clean.file)
saveRDS(detectionPval, file = meta.detection.pval.file)
saveRDS(bmat, file = meta.bmat.file)
# END 01_clean_data

