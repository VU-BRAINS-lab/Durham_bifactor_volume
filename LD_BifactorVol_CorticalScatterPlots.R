library(compare)
library(gdata)
library(mgcv)
library(mgcViz)
library(visreg)
library(ggplot2)
library(cowplot)
library(RColorBrewer)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#LOAD MPLUS DAT FILE WITH EXTRACTED FACTORS
bifactor_variables <- c("CBCL01", "CBCL03", "CBCL04", "CBCL07", "CBCL09", "CBCL10", "CBCL13", "CBCL15", "CBCL16", "CBCL17", 
                        "CBCL19", "CBCL22", "CBCL23", "CBCL25", "CBCL26", "CBCL27", "CBCL28", "CBCL30", "CBCL31", "CBCL32", 
                        "CBCL33", "CBCL34", "CBCL35", "CBCL37", "CBCL39", "CBCL41", "CBCL43", "CBCL46", "CBCL50", "CBCL51", 
                        "CBCL52", "CBCL56A", "CBCL56B", "CBCL56C", "CBCL56F", "CBCL56G", "CBCL57", "CBCL61", "CBCL62", 
                        "CBCL66", "CBCL68", "CBCL71", "CBCL72", "CBCL74", "CBCL75", "CBCL80", "CBCL81", "CBCL82", "CBCL84", 
                        "CBCL85", "CBCL86", "CBCL87", "CBCL88", "CBCL89", "CBCL90", "CBCL94", "CBCL95", "CBCL97", "CBCL102", 
                        "CBCL103", "CBCL106", "CBCL109", "CBCL111", "CBCL112", "ATTEND", "DESTROY", "GENERAL", "GENERAL_SE", 
                        "EXT", "EXT_SE", "ADHD", "ADHD_SE", "INT", "INT_SE", "PSWEIGHT", "subnum_char", "SITEN", "FAMID")
bifactor_data <- read.table("BifactorScores.dat", header = FALSE)
colnames(bifactor_data) = bifactor_variables

#CONDENSE MPLUS DAT FILE: delete all data except for subject number and factor scores 
factorscores <- bifactor_data[c(grep("subnum_char|^GENERAL$|^EXT$|^ADHD$|^INT$", names(bifactor_data)))]

#LOAD CORTICAL VOLUME DAT FILE: merge column names with dat file
dat_name <- sprintf('Cortical_Volume_Variable_names.txt',getwd())
dat_file <- sprintf('Cortical_Volume.dat',getwd())
dat <- read.table(dat_file, header = FALSE, sep = "", dec = ".", na.strings = ".")
dat_n <- scan(dat_name, what ="string")
colnames(dat) <- dat_n

#MERGE THE TWO DAT FILES
dataMerge <-merge(dat, factorscores, by=c("subnum_char"), all=TRUE) 

##CORTICAL REGIONS: creating a vector with all cortical regions, then creating a sum variable, then into cubic cm from cubic mm##
cortical_regions <- c("vol_1", "vol_2", "vol_3", "vol_4", "vol_5", "vol_6", "vol_7", "vol_8", "vol_9", "vol_10", 
                      "vol_11", "vol_12", "vol_13", "vol_14", "vol_15", "vol_16", "vol_17", "vol_18", "vol_19", "vol_20", 
                      "vol_21", "vol_22", "vol_23", "vol_24", "vol_25", "vol_26", "vol_27", "vol_28", "vol_29", "vol_30", 
                      "vol_31", "vol_32", "vol_33", "vol_34", "vol_35", "vol_36", "vol_37", "vol_38", "vol_39", "vol_40",
                      "vol_41", "vol_42", "vol_43", "vol_44", "vol_45", "vol_46", "vol_47", "vol_48", "vol_49", "vol_50", 
                      "vol_51", "vol_52", "vol_53", "vol_54", "vol_55", "vol_56", "vol_57", "vol_58", "vol_59", "vol_60",
                       "vol_61", "vol_62", "vol_63", "vol_64", "vol_65", "vol_66", "vol_67", "vol_68")

dataMerge$cortical_regions_sum <- rowSums(subset(dataMerge, select = cortical_regions))
dataMerge$cortical_regions_sum_cm <- dataMerge$cortical_regions_sum/1000

##CREATE GROUPED VARIABLES FOR COIL AND RACE
dataMerge$RACE <- names(dataMerge[10:13])[max.col(dataMerge[10:13])]
dataMerge$COIL <- names(dataMerge[122:126])[max.col(dataMerge[122:126])]

##DEFINE COVARIATES AS FACTORS OR NUMERIC
dataMerge$FEMALEFACTOR <- as.factor(dataMerge$FEMALE)
dataMerge$RACEFACTOR <- as.factor(dataMerge$RACE)
dataMerge$COILFACTOR <- as.factor(dataMerge$COIL)
dataMerge$ageNUMERIC <- as.numeric(dataMerge$age)
dataMerge$generalNUMERIC <- as.numeric(dataMerge$GENERAL)
dataMerge$extNUMERIC <- as.numeric(dataMerge$EXT)
dataMerge$intNUMERIC <- as.numeric(dataMerge$INT)
dataMerge$adhdNUMERIC <- as.numeric(dataMerge$ADHD)

#RUN GAM MODELS
attach(dataMerge)

corticalGam <- gam(cortical_regions_sum_cm ~ ageNUMERIC + FEMALEFACTOR + COILFACTOR + RACEFACTOR +
                     generalNUMERIC + extNUMERIC + intNUMERIC + adhdNUMERIC, method="REML")
summary(corticalGam)

#Convert the fitted object to the gamViz class to use the tools in mgcViz
corticalGamViz <- getViz(corticalGam)

############ SCATTER PLOTS ###########

#cortical and general psychopathology
plot(corticalGamViz, allTerms = TRUE, select = 5) + 
  labs(x = "General Psychopathology", y = "Cortical Volume") +
  l_points(shape=19, size=0.7, color= "#17b050") +
  l_fitLine(colour = "black", size=1) +
  l_ciLine(mul = 5, colour = "black", linetype = 2, size=0.5) +
  theme(axis.title.x=element_text(size=11, colour = "#17b050"),
        axis.title.y=element_text(size=11, colour = "black"),
        axis.text.x=element_text(size=10, colour="black"),
        axis.text.y=element_text(size=10, colour="black")) +
  theme(legend.position = "none")

ggsave(file="ScatterplotCorticalGen.png", width = 3, height = 3, units = 'in', dpi = 300)

#cortical and conduct
plot(corticalGamViz, allTerms = TRUE, select = 6) + 
  labs(x = "Conduct Problems", y = "Cortical Volume") +
  l_points(shape=19, size=0.7, color= "#c00000") +
  l_fitLine(colour = "black", size=1) +
  l_ciLine(mul = 5, colour = "black", linetype = 2, size=0.5) +
  theme(axis.title.x=element_text(size=11, colour = "#c00000"),
        axis.title.y=element_text(size=11, colour = "black"),
        axis.text.x=element_text(size=10, colour="black"),
        axis.text.y=element_text(size=10, colour="black")) +
  theme(legend.position = "none")

ggsave(file="ScatterplotCorticalCon.png", width = 3, height = 3, units = 'in', dpi = 300)

#cortical and adhd
plot(corticalGamViz, allTerms = TRUE, select = 8) + 
  labs(x = "ADHD", y = "Cortical Volume") +
  l_points(shape=19, size=0.7, color= "#ed7d31") +
  l_fitLine(colour = "black", size=1) +
  l_ciLine(mul = 5, colour = "black", linetype = 2, size=0.5) +
  theme(axis.title.x=element_text(size=11, colour = "#ed7d31"),
        axis.title.y=element_text(size=11, colour = "black"),
        axis.text.x=element_text(size=10, colour="black"),
        axis.text.y=element_text(size=10, colour="black")) +
  theme(legend.position = "none")

ggsave(file="ScatterplotCorticalAdhd.png", width = 3, height = 3, units = 'in', dpi = 300)

#cortical and internalizing
plot(corticalGamViz, allTerms = TRUE, select = 7) + 
  labs(x = "Internalizing", y = "Cortical Volume") +
  l_points(shape=19, size=0.7, color= "#702fa0") +
  l_fitLine(colour = "black", size=1) +
  l_ciLine(mul = 5, colour = "black", linetype = 2, size=0.5) +
  theme(axis.title.x=element_text(size=11, colour = "#702fa0"),
        axis.title.y=element_text(size=11, colour = "black"),
        axis.text.x=element_text(size=10, colour="black"),
        axis.text.y=element_text(size=10, colour="black")) +
  theme(legend.position = "none")

ggsave(file="ScatterplotCorticalInt.png", width = 3, height = 3, units = 'in', dpi = 300)
