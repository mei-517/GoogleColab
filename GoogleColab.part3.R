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
Xd <- d[,1:(ncol(d)-1)]
yd <- d[,ncol(d)]

# head(Xd)
# head(yd)


## 図をかく
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

## 