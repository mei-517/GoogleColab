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
  return(t(result))
}


## load data
setwd("E:/home/nagai/workspace/GoogleColab")
d <- read.table("elephant_data.txt",header=F)

## Xd:体長体重 yd:ラベル
xd <- d[,1:(ncol(d)-1)]
yd <- d[,ncol(d)]

# head(Xd)
# head(yd)


## 図をかく
draw_graph <- function(){
  ## マーカー
  markers <- c(0, 1, 2, 3, 4, 5, 6 ,7)
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

draw_graph

## 図を保存
png("img1.png")
draw_graph()
dev.off()

pdf("img1.pdf")
draw_graph()
dev.off()


## 学習用とテスト用に分ける
set.seed(5)

train_index <- sample(1:nrow(xd), size = 0.8*nrow(xd))

x_train <- xd[train_index, ]
x_test <- xd[-train_index, ]
y_train <- yd[train_index]
y_test <- yd[-train_index]


## 正規化
x <- min_max(x_train, x_train)
y <- y_train

## SVMによる学習
model <- svm(x =x, y = as.factor(y))

## 学習データを予測
y_pred <- predict(model, x)

## 正解率
mean(y_pred == y)

## 境界線をかく########################################

draw_graph_withline(){
  
  ## マーカー
  markers <- c(0, 1, 2, 3, 4, 5, 6 ,7)
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
  
  ## グラフ範囲
  x_min <- min(X[, 1])
  x_max <- max(X[, 1])
  y_min <- min(X[, 2])
  y_max <- max(X[, 2])
  
  ## 格子状
  x_seq <- seq(x_min, x_max, length.out = 200)
  y_seq <- seq(y_min, y_max, length.out = 200)
  grid <- expand.grid(x = x_seq, y = y_seq)
  
  ## SVM
  z <- predict(model,grid)
  
  
  z_num <- as.numetric(z) -1
  z_matrix <- matrix(z_num, nrow = length(x_seq), ncol = length(y_seq))
  
  ## 背景
  image(x_seq, y_seq, z_matrix, col = c)
  
}

