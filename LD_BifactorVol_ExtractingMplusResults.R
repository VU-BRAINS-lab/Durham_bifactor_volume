setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(MplusAutomation)

# read mplus output file
modelResults <- readModels("OUTPUT FILE NAME")

# read standardized results
standardizedResults <- modelResults[["parameters"]][["stdyx.standardized"]]

# read the index of regression results (can find in "paramHeader" column ending in ".ON")
RegI=grep(".ON", standardizedResults$paramHeader)

# read the index of regression results with "GENERAL" factor (can find in "param" column)
GenI=grep("GENERAL", standardizedResults$param)
# read the index of regression results with "EXT" factor
ExtI=grep("EXT", standardizedResults$param)
# read the index of regression results with "INT" factor
IntI=grep("INT", standardizedResults$param)
# read the index of regression results with "ADHD" factor
ADHDI=grep("ADHD", standardizedResults$param)

# Find the index of regression results for each factor
RegGen=intersect(RegI, GenI)
RegExt=intersect(RegI, ExtI)
RegInt=intersect(RegI, IntI)
RegADHD=intersect(RegI, ADHDI)

# Find the p value of regression results for each factor
Gen_p=standardizedResults$pval[RegGen]
Ext_p=standardizedResults$pval[RegExt]
Int_p=standardizedResults$pval[RegInt]
ADHD_p=standardizedResults$pval[RegADHD]

# Adjust length if needed by adding -# at the end if you want to cut off some numbers
Gen_p <- Gen_p[1:(length(Gen_p))]
Ext_p <- Ext_p[1:(length(Ext_p))]
Int_p <- Int_p[1:(length(Int_p))]
ADHD_p <- ADHD_p[1:(length(ADHD_p))]

# Perform fdr
Gen_p_fdr <- p.adjust(Gen_p, method="fdr")
Ext_p_fdr <- p.adjust(Ext_p, method="fdr")
Int_p_fdr <- p.adjust(Int_p, method="fdr")
Adhd_p_fdr <- p.adjust(ADHD_p, method="fdr")

#Convert to data frame
Gen_p_fdr <- as.data.frame(Gen_p_fdr)
Ext_p_fdr <- as.data.frame(Ext_p_fdr)
Int_p_fdr <- as.data.frame(Int_p_fdr)
Adhd_p_fdr <- as.data.frame(Adhd_p_fdr)

#Print fdr-corrected p-values to three decimal places
Gen_p_fdr_round <- round(Gen_p_fdr,3)
Ext_p_fdr_round <- round(Ext_p_fdr,3)
Int_p_fdr_round <- round(Int_p_fdr,3)
Adhd_p_fdr_round <- round(Adhd_p_fdr,3)

#create dataframe to store Gen data
Gen <- data.frame(
  Factor = "Gen",
  est = standardizedResults$est[RegGen],
  se = standardizedResults$se[RegGen],
  est_se = standardizedResults$est_se[RegGen],
  pval = standardizedResults$pval[RegGen],
  FDR_pval = Gen_p_fdr_round,
  stringsAsFactors = FALSE
)

#create dataframe to store Ext data
Ext <- data.frame(
  Factor = "Ext",
  est = standardizedResults$est[RegExt],
  se = standardizedResults$se[RegExt],
  est_se = standardizedResults$est_se[RegExt],
  pval = standardizedResults$pval[RegExt],
  FDR_pval = Ext_p_fdr_round,
  stringsAsFactors = FALSE
)

#create dataframe to store Int data
Int <- data.frame(
  Factor = "Int",
  est = standardizedResults$est[RegInt],
  se = standardizedResults$se[RegInt],
  est_se = standardizedResults$est_se[RegInt],
  pval = standardizedResults$pval[RegInt],
  FDR_pval = Int_p_fdr_round,
  stringsAsFactors = FALSE
)

#create dataframe to store ADHD data
Adhd <- data.frame(
  Factor = "Adhd",
  est = standardizedResults$est[RegADHD],
  se = standardizedResults$se[RegADHD],
  est_se = standardizedResults$est_se[RegADHD],
  pval = standardizedResults$pval[RegADHD],
  FDR_pval = Adhd_p_fdr_round,
  stringsAsFactors = FALSE
)

#write data to csv
write.table(Gen, "Desikan_data.csv", quote = FALSE, sep = ",", row.names=FALSE)
write.table(Ext, "Desikan_data.csv", append = TRUE, quote = FALSE, sep = ",", row.names=FALSE, col.names = FALSE)
write.table(Int, "Desikan_data.csv", append = TRUE, quote = FALSE, sep = ",", row.names=FALSE, col.names = FALSE)
write.table(Adhd, "Desikan_data.csv", append = TRUE, quote = FALSE, sep = ",", row.names=FALSE, col.names = FALSE)


