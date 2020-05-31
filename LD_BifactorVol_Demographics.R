library(compare)
library(gdata)
library(plyr)
library(varhandle)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Appending Column names to .dat file#

variable_name <- sprintf('Cortical_Volume_Variable_names.txt',getwd())
variable_file <- sprintf('Cortical_Volume.dat',getwd())
variable <- read.table(variable_file, header = FALSE, sep = "", dec = ".")
variable_n <- scan(variable_name, what ="string")
colnames(variable) <- variable_n
subjData <- variable

###############################
#### Table 1: Demographics ####
###############################

#Total sample means
meanAge_total <- mean(subjData$age)
meanAge_total

#Total sample sd
sdAge_total <- sd(subjData$age)
sdAge_total

#Total number of males and females (0=male, 1=female)
sexTable_total <- table(subjData$FEMALE)
sexTable_total

#Percentage of females
female_number <-length(which(subjData$FEMALE==1))
percentfemale <- female_number/9672
percentfemale
male_number <-length(which(subjData$FEMALE==0))
percentmale <- male_number/9672
percentmale

#Total number of whites (1=non-hispanic white, 0=not)
whiteTable_total <- table(subjData$NHWHITE)
whiteTable_total

#Total number of hispanic (1=hispanic, 0=not)
hispanicTable_total <- table(subjData$HISPANIC)
hispanicTable_total

#Total number of african (1=african, 0=not)
africanTable_total <- table(subjData$AFRICAN)
africanTable_total

#Total number of other (1=other, 0=not)
otherraceTable_total <- table(subjData$OTHER)
otherraceTable_total

#Percentage of each race group
white_number <-length(which(subjData$NHWHITE==1))
percentwhite <- white_number/9672
percentwhite
hispanic_number <-length(which(subjData$HISPANIC==1))
percenthispanic <- hispanic_number/9672
percenthispanic
african_number <-length(which(subjData$AFRICAN==1))
percentafrican <- african_number/9672
percentafrican
otherrace_number <-length(which(subjData$OTHER==1))
percentotherrace <- otherrace_number/9672
percentotherrace

#Income Summary table
income_total<-table(subjData$income)
income_total

#Percentage of each income response
lessthanfivek_number <-length(which(subjData$income==1))
lessthanfivek_number
percentlessthanfivek <- lessthanfivek_number/9672
percentlessthanfivek
fivektotwelvek_number <-length(which(subjData$income==2))
fivektotwelvek_number
percentfivektotwelvek <- fivektotwelvek_number/9672
percentfivektotwelvek
twelvektosixteenk_number <-length(which(subjData$income==3))
twelvektosixteenk_number
percenttwelvektosixteenk <- twelvektosixteenk_number/9672
percenttwelvektosixteenk
sixteenktotwentyfivek_number <-length(which(subjData$income==4))
sixteenktotwentyfivek_number
percentsixteenktotwentyfivek <- sixteenktotwentyfivek_number/9672
percentsixteenktotwentyfivek
twentyfivektothirtyfivek_number <-length(which(subjData$income==5))
twentyfivektothirtyfivek_number
percenttwentyfivektothirtyfivek <- twentyfivektothirtyfivek_number/9672
percenttwentyfivektothirtyfivek
thirtyfivektofiftyk_number <-length(which(subjData$income==6))
thirtyfivektofiftyk_number
percentthirtyfivektofiftyk <- thirtyfivektofiftyk_number/9672
percentthirtyfivektofiftyk 
fiftyktoseventyfivek_number <-length(which(subjData$income==7))
fiftyktoseventyfivek_number
percentfiftyktoseventyfivek <- fiftyktoseventyfivek_number/9672
percentfiftyktoseventyfivek
seventyfivektohundredk_number <-length(which(subjData$income==8))
seventyfivektohundredk_number
percentseventyfivektohundredk <- seventyfivektohundredk_number/9672
percentseventyfivektohundredk
hundredktotwohundrek_number <-length(which(subjData$income==9))
hundredktotwohundrek_number
percenthundredktotwohundrek <- hundredktotwohundrek_number/9672
percenthundredktotwohundrek
overtwohundredk_number <-length(which(subjData$income==10))
overtwohundredk_number
percentovertwohundredk <- overtwohundredk_number/9672
percentovertwohundredk
missingincome_number <-length(which(subjData$income=="."))
missingincome_number
percentmissingincome <- missingincome_number/9672
percentmissingincome

#Parental Education Summary table
parentaledu_total<-table(parent_education)
parentaledu_total

#Percentage of each parental education response
neverorkindergarten_number <-length(which(parent_education==0))
neverorkindergarten_number

first_number <-length(which(parent_education==1))
first_number

second_number <-length(which(parent_education==2))
second_number

third_number <-length(which(parent_education==3))
third_number

fourth_number <-length(which(parent_education==4))
fourth_number

fifth_number <-length(which(parent_education==5))
fifth_number

sixth_number <-length(which(parent_education==6))
sixth_number

seventh_number <-length(which(parent_education==7))
seventh_number

eighth_number <-length(which(parent_education==8))
eighth_number

ninth_number <-length(which(parent_education==9))
ninth_number

tenth_number <-length(which(parent_education==10))
tenth_number

eleventh_number <-length(which(parent_education==11))
eleventh_number

percentnodegree <- (neverorkindergarten_number + first_number + second_number + third_number +
                      fourth_number + fifth_number + sixth_number + seventh_number + eighth_number +
                      ninth_number + tenth_number + eleventh_number)/9672
percentnodegree

highschoolgradGED_number <-length(which(parent_education==12))
highschoolgradGED_number
percenthighschoolgradGED <- highschoolgradGED_number/9672
percenthighschoolgradGED

somecollege_number <-length(which(parent_education==13))
somecollege_number
percentsomecoll <- somecollege_number/9672
percentsomecoll

associate_number <-length(which(parent_education==14))
associate_number
percentassociate <- associate_number/9672
percentassociate

bachelors_number <-length(which(parent_education==16))
bachelors_number
percentbach <- bachelors_number/9672
percentbach

masters_number <-length(which(parent_education==18))
masters_number
percentmasters <- masters_number/9672
percentmasters

profdocschool_number <-length(which(parent_education==20))
profdocschool_number
percentprofdocschool <- profdocschool_number/9672
percentprofdocschool



