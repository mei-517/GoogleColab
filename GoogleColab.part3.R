## Author: Mei Nagai


## Date:2026/08/31
## 第１部３章

## elephant_ipynb ####################################################


##test用
# graphics.off()



## import library
# utils::install.packages("e1071")
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
# setwd("E:/home/nagai/workspace/GoogleColab")
setwd("C:/GoogleColab")
d <- read.table("elephant_data.txt",header=F)

## xd:体長体重 yd:ラベル
xd <- d[,1:(ncol(d)-1)]
yd <- d[,ncol(d)]

# head(xd)
# head(yd)

## 図をかく
draw_graph1 <- function(){
  ## マーカー
  markers <- c(1, 4, 2, 6, 5, 8, 3, 18)
  colors <- c("red", "blue", "green", "black","cyan", "magenta", "yellow", "grey")
  m <- 1
  ## 空の図
  plot(xd[, 1], xd[, 2], type = "n")
  ## 図示
  for (i in unique(yd)) {
    n <- which(yd == i)
    points(xd[n, 1], xd[n, 2], pch = markers[m], col = colors[m])
    m <- m + 1
  }
}

draw_graph1()

## 図を保存
png("img1.png")
draw_graph1()
dev.off()

pdf("img1.pdf")
draw_graph1()
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

## img2 ########################################################################

draw_graph2 <-function(){
  
  ## マーカー
  markers <- c(1, 4, 2, 6, 5, 8, 3, 18)
  colors <- c("red", "blue", "green", "black","cyan", "magenta", "yellow", "grey")

  ## グラフ範囲
  x_min <- min(x[, 1])
  x_max <- max(x[, 1])
  y_min <- min(x[, 2])
  y_max <- max(x[, 2])
  
  ## 格子状
  x_seq <- seq(x_min, x_max, length.out = 200)
  y_seq <- seq(y_min, y_max, length.out = 200)
  grid <- expand.grid(x = x_seq, y = y_seq)
  
  ## SVM
  z <- predict(model,grid)
  
  
  z_num <- as.numeric(z) -1
  z_matrix <- matrix(z_num, nrow = length(x_seq), ncol = length(y_seq))
  
  ## 背景
  image(x_seq, y_seq, z_matrix, col = c("lightblue", "mistyrose"))
  
  ## 境界線
  contour(x_seq, y_seq, z_matrix, add = TRUE, drawlabels = FALSE)
  
  ## データを描画
  m <- 1
  
  for(i in unique(y)){
    n <- which(y == i)
    points(x[n,1], x[n,2], pch = markers[m], col = colors[m])
    
  m <- m+1
  }
}


draw_graph2()

png("img2.png")
draw_graph2()
dev.off()

pdf("img2.pdf")
draw_graph2()
dev.off()

## データ予測
x <- min_max(x_test, x_train)
y <- y_test

## 正解率
y_pred <- predict(model, x)
mean(y_pred == y)


## img3 #######################################################################


plot(x[, 1], x[, 2], type = "n")
## テストデータの分類結果を描く
draw_test_graph <- function(){
  
  ## マーカー
  markers <- c(1, 4, 2, 6, 5, 8, 3, 18)
  colors <- c(
    "red", "blue", "green", "black",
    "cyan", "magenta", "yellow", "grey"
  )
  
  ## 学習データを正規化
  x_train_norm <- min_max(x_train, x_train)
  
  ## テストデータを正規化
  x_test_norm <- min_max(x_test, x_train)
  
  ## グラフ範囲
  x_min <- min(x_train_norm[, 1])
  x_max <- max(x_train_norm[, 1])
  y_min <- min(x_train_norm[, 2])
  y_max <- max(x_train_norm[, 2])
  
  ## 格子状のデータを作る
  x_seq <- seq(x_min, x_max, length.out = 200)
  y_seq <- seq(y_min, y_max, length.out = 200)
  
  grid <- expand.grid(
    x = x_seq,
    y = y_seq
  )
  
  ## 学習済みSVMで格子点を予測
  z <- predict(model, grid)
  
  ## 数値に変換
  z_num <- as.numeric(z) - 1
  
  ## 行列に戻す
  z_matrix <- matrix(
    z_num,
    nrow = length(x_seq),
    ncol = length(y_seq)
  )
  
  ## 背景
  image(
    x_seq,
    y_seq,
    z_matrix,
    col = c("mistyrose", "lightblue")
  )
  
  ## 分類境界
  contour(
    x_seq,
    y_seq,
    z_matrix,
    add = TRUE,
    drawlabels = FALSE
  )
  
  ## テストデータを描画
  m <- 1
  
  for(i in unique(y_test)){
    
    n <- which(y_test == i)
    
    points(
      x_test_norm[n, 1],
      x_test_norm[n, 2],
      pch = markers[m],
      col = colors[m]
    )
    
    m <- m + 1
  }
}
draw_test_graph()