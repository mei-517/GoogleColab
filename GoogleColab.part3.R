## Author: Mei Nagai


## Date:2026/08/31
## 第１部３章

## elephant_ipynb ####################################################

## import library
utils::install.packages("e1071")
library(e1071)


## def min_max
min_max <- function(x1,x2){
  x1 <- t(x1)
  x2 <- t(x2)
  min_val <- apply(x2,1,min)
  max_val <- apply(x2,1,max)
  
  result <- sweep(x1, 1, min_val, "-")
  result <- sweep(result, 1, max_val - min_val, "/")
  return(result)
}


## load data
setwd("E:/home/nagai/workspace/GoogleColab")
d <- read.table("elephant_data.txt",header=F)

## Xd:体長体重 yd:ラベル
Xd <- d[,1:(ncol(d)-1)]
yd <- d[,ncol(d)]

# head(Xd)
# head(yd)

draw_graph <- function(){
  ## マーカー
  markers <- c(1, 4, 2, 6, 5, 8, 3, 18)
  colors <- c("red", "blue", "green", "black","cyan", "magenta", "yellow", "grey")
  m <- 1
  ## 空の図
  plot(Xd[, 1], Xd[, 2], type = "n")
  ## 図示
  for (i in unique(yd)) {
    n <- which(yd == i)
    points(Xd[n, 1], Xd[n, 2], pch = markers[m], col = colors[m])
    m <- m + 1
  }
}

png("img1.png")
draw_graph()
dev.off()

pdf("img1.pdf")
draw_graph()
dev.off()