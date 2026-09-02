## Author: Mei Nagai


## Date:2026/08/31
## 第１部３章

utils::install.packages("e1071")
library(e1071)

## dataを取得
setwd("E:/home/nagai/workspace/GoogleColab")
df <- read.table("elephant_data.txt",header=F)

## Xd:体長体重 yd:ラベル
Xd <- df[,1:2]
yd <- df[,3]

head(Xd)
head(yd)

## def min_max
min_max <- function(x1,x2){
  
  min_val <- apply(x2,2,min)
  max_val <- apply(x2,2,max)
  
  result <- (x1 - min_val)/(max_val - min_val)
  return(result)
  
}

min_max(Xd,Xd)

## def min_max python 通りver
## 後で確認################################################################

# x1 <- t(x1)
# x2 <- t(x2)
# min_max <- function(x1,x2){
# min_val <- apply(x2,1,min)
# max_val <- apply(x2,1,max)
# result <- (x1 - min_val)/(max_val - min_val)
# return(t(result))
# }