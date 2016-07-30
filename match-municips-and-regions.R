library(dplyr)

A <- read.csv("mun1.csv",header=TRUE)
B <- read.csv("regioni-opstini.csv", header=TRUE)
colnames(B) <- c("REG", "MUN")
A$MUN <- toupper(A$MUN)
B$MUN <- toupper(B$MUN)

nrow(A)
nrow(B)

head(A)
head(B)

unA <- unique(A$MUN) %>% sort
unB <- unique(B$MUN) %>% sort

Match <- unA %in% unB
unA[!Match]

C <- inner_join(A, B, by="MUN") 
C$AGE <- 2016-C$YoB
tail(C)
glimpse(C)
nrow(C)

write.csv(C, file="Voters.csv")

## find out which municipalites have biggest % of young problematic entries

teens <- C %>% filter(AGE %in% 18:22) %>% group_by(MUN) %>% summarise_each(funs(length(.)))
all <- C %>%  group_by(MUN) %>% summarise_each(funs(length(.)))

Match1 <- all$MUN %in% teens$MUN

all2 <- all[Match1,] # subset the rows based on true/false in Match2

##percent
## doesn't matter which variable is used, as the length 
#(number of voters in each municipality) is the same for all variables
teens$Percent <- 100/(all2$AGE/teens$AGE)
teens %>% arrange(desc(Percent))

# wrapper function to do the above for arbitrary age range

getPercentOfAge <- function(DataFrame=C, AgeRange=c(18:22)) {
  library("dplyr")
  teens <- DataFrame %>% filter(AGE %in% AgeRange) %>% group_by(MUN) %>% summarise_each(funs(length(.)))
  all <- DataFrame %>% group_by(MUN) %>% summarise_each(funs(length(.)))
  Match1 <- all$MUN %in% teens$MUN
  all2 <- all[Match1,] 
  teens$Percent <- 100/(all2$AGE/teens$AGE)
  teens %>% arrange(desc(Percent))
  return(teens)
}

getPercentOfAge(DataFrame = C, AgeRange = 30:35)
