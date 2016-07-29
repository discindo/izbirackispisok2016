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

all$MUN[Match1] ## i kako sega da se izbrisat od all tie sto nemaat 18-22

##formula za procent
##perc <- 100/(all/teens)

