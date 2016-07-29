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
