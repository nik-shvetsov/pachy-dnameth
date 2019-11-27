# 04_sva
library(sva)

args <- commandArgs(trailingOnly = TRUE)
opt <- list()
opt$input <- args[1]
opt$output <- args[2]

bmat.bmiq <- readRDS(gsub("//", "/", file.path(opt$input, 'bmat_bmiq.rds')))
pdata <- readRDS(gsub("//", "/", file.path(opt$input, 'pdata.rds')))
meta.sva.file <- gsub("//","/",file.path(opt$output, "sva_"))

bmat.noNA <- na.omit(bmat.bmiq)

cohortSVA <- function(ss, bmat, cohort) {
	pdata_cohort <- ss[which(ss$Cohort==cohort), ]
	# pdata_cohort <- na.omit(pdata_cohort, cols=c("CaseControl")) # not working as intented
	pdata_cohort <- pdata_cohort[which(!is.na(pdata_cohort$CaseControl)), ]
	caseCnt_cohort <- pdata_cohort$CaseControl
	# TODO: fix if that info is anavailable

	sampleid_cohort <- pdata_cohort$Sample_ID
	bmat.noNA_cohort <- bmat[, which(colnames(bmat) %in% pdata_cohort$Sample_ID)]
	
	mod <- model.matrix(~as.factor(caseCnt_cohort), data = pdata_cohort)
	mod0 <- model.matrix(~1, data = pdata_cohort)
	num.sva <- num.sv(bmat.noNA_cohort, mod = mod)
	sva <- sva(bmat.noNA_cohort, mod, mod0 = mod0, n.sv = num.sva)

	saveRDS(sva, file = paste0(meta.sva.file, cohort, ".rds"))
	print (paste0("Done for ", cohort))
}

pdata_df <- as.data.frame(pdata, stringsAsFactor=FALSE)
pdata_df[pdata_df==""] <- NA
cohorts <- unique(pdata_df$Cohort)[!is.na(unique(pdata_df$Cohort))]

print ("Available cohorts:")
print (cohorts)

for (cohort in cohorts) {
	cohortSVA(pdata_df, bmat.noNA, cohort)
	print (paste("Done for", cohort, "cohort"))
}
# END 04_sva
