# 06_make_cg_gene
library(parallel)
#
args <- commandArgs(trailingOnly = TRUE)
opt <- list()
opt$input <- args[1]
opt$output <- args[2]
opt$anno <- args[3]

meta.geneCG.file <- gsub("//","/",file.path(opt$output, "geneCG.rds"))

bmat <- readRDS(file.path(opt$input, 'bmat_bmiq.rds'))

annotation <- readRDS(file.path(opt$anno, 'annotation.rds'))
## outdated: see LINE-1 protocol for a considrably faster way to do the same thing

cg <- intersect(rownames(annotation), rownames(bmat))
gg <- strsplit(annotation[cg, "UCSC_RefGene_Name"], ";")
gg <- lapply(gg, unique)
names(gg) <- cg
gg <- gg[sapply(gg, length) > 0]
rr <- names(gg)
gene <- unique(unlist(gg))

print ("Starting cluster...")
cl <- makeCluster(16, "PSOCK")
gene.cg <- parSapplyLB(cl, gene, function(g,rr,gg) rr[sapply(gg, function(x,g) any(g %in% x), g = g)], rr = rr, gg = gg)
stopCluster(cl)
print ("Stopping cluster...")
saveRDS(gene.cg, file = meta.geneCG.file)
# END 06_make_cg_gene
