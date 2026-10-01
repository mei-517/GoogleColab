## Author: Mei Nagai


## Date:2026/08/31-2026/10/01
## 第１部３章


# graphics.off()


## elephant_ipynb ##############################################################

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
# d <- read.table("elephant_data_3k.txt",header=F)
# d <- read.table("elephant_data_4d.txt",header=F)


## xd:体長体重 yd:ラベル
xd <- d[,1:(ncol(d)-1)]
yd <- d[,ncol(d)]

# head(xd)
# head(yd)





## img1 #####

## graph1
draw_graph1 <- function(){
  ## マーカー
  markers <- c(1, 4, 2, 6, 5, 8, 3, 18)
  colors <- c("red", "blue", "green", "black","cyan", "magenta", "yellow", "grey")
  m <- 1
  ## 空の図
  plot(xd[, 1], xd[, 2], type = "n")
  ## 図示
  for (i in sort(unique(yd))){
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





## img2 #####

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

## graph2
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
  image(x_seq, y_seq, z_matrix, col = c("lightblue", "mistyrose", "grey"))
  
  ## 境界線
  contour(x_seq, y_seq, z_matrix, add = TRUE, drawlabels = FALSE)
  
  ## データを描画
  m <- 1
  
  for(i in sort(unique(y))){
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





## img3 #####

## データ予測
x <- min_max(x_test, x_train)
y <- y_test

## 正解率
y_pred <- predict(model, x)
mean(y_pred == y)


## graph3
draw_graph3 <- function(){
  
  ## 空の図
  plot(x[, 1], x[, 2], type = "n")
  
  ## マーカー
  markers <- c(1, 4, 2, 6, 5, 8, 3, 18)
  colors <- c("red", "blue", "green", "black","cyan", "magenta", "yellow", "grey")
  
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
  
  grid <- expand.grid(x = x_seq, y = y_seq)
  
  ## 学習済みSVMで格子点を予測
  z <- predict(model, grid)
  
  ## 数値に変換
  z_num <- as.numeric(z) - 1
  
  ## 行列に戻す
  z_matrix <- matrix(z_num, nrow = length(x_seq), ncol = length(y_seq))
  
  ## 背景
  image(x_seq, y_seq, z_matrix, col = c("lightblue", "mistyrose", "grey"))
  
  ## 境界
  contour(x_seq, y_seq, z_matrix, add = TRUE, drawlabels = FALSE)
  
  ## テストデータを描画
  m <- 1
  
  for(i in sort(unique(y_test))){
    n <- which(y_test == i)
    points(x_test_norm[n, 1], x_test_norm[n, 2], pch = markers[m], col = colors[m])
    m <- m + 1
  }
}

draw_graph3()

png("img3.png")
draw_graph3()
dev.off()

pdf("img3.pdf")
draw_graph3()
dev.off()



## random_plot.ipynb ###########################################################

## 乱数を固定
set.seed(0)

## dataを用意
n <- 50

## x1,y1を用意
x1 <- matrix(runif(n * 2, min = -1, max = 1), nrow = n, ncol = 2)
y1 <- rep(0, n)

## x2,y2を用意
x2 <- matrix(runif(n * 2, min = -1, max = 1), nrow = n, ncol = 2)
y2 <- rep(1, n)

## xd,ydに結合する
xd <- rbind(x1, x2)
yd <- c(y1, y2)

## x,yに代入(引数の用意)
x <- xd
y <- yd

## 学習1
clf <- svm(x, y, type = "C-classification", kernel = "radial", cost = 100.0, gamma = 20.0)

## 予測1
y_pred <- predict(clf, x)

## 正解率1
mean(y_pred == y)

## img #####
draw_graph <- function(x, y, clf){
  
  ## Xの範囲
  x_min <- min(x[, 1])
  x_max <- max(x[, 1])
  y_min <- min(x[, 2])
  y_max <- max(x[, 2])
  
  ## 格子を作る
  x_seq <- seq(x_min, x_max, length.out = 200)
  y_seq <- seq(y_min, y_max, length.out = 200)
  grid <- expand.grid(x = x_seq, y = y_seq)
  
  ## 格子上の各点をSVMで予測
  z <- predict(clf, grid)
  z <- as.numeric(as.character(z))
  
  ## 予測結果を格子状に戻す
  z <- matrix(z, nrow = length(x_seq), ncol = length(y_seq))
  z <- t(z)
  
  ## 背景を描く
  image(x_seq, y_seq, z, col = c("lightblue", "lightpink"), xlim = c(x_min, x_max), ylim = c(y_min, y_max), xlab = "", ylab = "", axes = FALSE)
  
  ## 決定境界
  contour(x_seq, y_seq, z, add = TRUE, drawlabels = FALSE)
  
  ## 元のデータを描く
  points(x[y == 0, 1], x[y == 0, 2], pch = 16, col = "red")
  points(x[y == 1, 1], x[y == 1, 2], pch = 4, col = "blue")
}


## 散布図１
draw_graph(x, y, clf)

png("img.png")
draw_graph(x, y, clf)
dev.off()

pdf("img.pdf")
draw_graph(x, y, clf)
dev.off()


## train用とtest用に分ける
set.seed(5)
train_idx <- sample(1:nrow(xd), size = 0.8 * nrow(xd))

x_train <- xd[train_idx, ]
x_test  <- xd[-train_idx, ]
y_train <- yd[train_idx]
y_test  <- yd[-train_idx]


## trainデータでSVMを学習
x <- x_train
y <- y_train
clf <- svm(x, y, type = "C-classification", kernel = "radial", cost = 100.0, gamma = 20.0)

## trainデータで予測・正解率
y_pred <- predict(clf, x_train)
mean(y_pred == y_train)

## testデータで予測・正解率
y_pred <- predict(clf, x_test)
mean(y_pred == y_test)


## 散布図２
draw_graph(x, y, clf)

png("img2.png")
draw_graph(x, y, clf)
dev.off()

pdf("img2.pdf")
draw_graph(x, y, clf)
dev.off()



##  cq05_imgc_hist_svm.ipynb #############################################################


setwd("C:/GoogleColab/img.input/shiba")
install.packages("jpeg")
library(jpeg)

## 画像を読み込み
img <- readJPEG("shiba_inu_1.jpg")

## 画像のサイズを確認
print(dim(img))

## 画像を表示
plot(as.raster(img))

## 画像のピクセル値を確認
print(img)






## 256×256にするための行・列の位置を作る
row_index <- round(seq(1, dim(img)[1], length.out = 256))
col_index <- round(seq(1, dim(img)[2], length.out = 256))

## 画像を256×256にリサイズ
img <- img[row_index, col_index, ]

## サイズを確認
print(dim(img))

## 画像を表示
plot(as.raster(img))







## RGBを取り出す
r <- img[, , 1]
g <- img[, , 2]
b <- img[, , 3]

## ピクセル値を0～255に変換
r <- r * 255
g <- g * 255
b <- b * 255

## RGBヒストグラムの作成
hist_r <- hist(as.vector(r), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts

hist_g <- hist(as.vector(g), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts

hist_b <- hist(as.vector(b), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts

## 確認
print(hist_b)
print(hist_g)
print(hist_r)



## RGBヒストグラムの描画
plot(hist_r, type = "l", col = "red", xlim = c(0, 255), xlab = "pixel value", ylab = "number of pixels")

lines(hist_g, type = "l", col = "green")

lines(hist_b, type = "l", col = "blue")

legend("topright", legend = c("red", "green", "blue"), col = c("red", "green", "blue"), lty = 1)



## ファイルの取得
files <- list.files()
length(files)

## 柴犬の特徴量を格納するリスト
pixels_shiba <- list()

## 画像を1枚ずつ処理
for (f in files) {
  
  ## 画像を読み込み
  img <- readJPEG(f)
  
  ## 画像を256×256にリサイズ
  row_index <- round(seq(1, dim(img)[1], length.out = 256))
  col_index <- round(seq(1, dim(img)[2], length.out = 256))
  img <- img[row_index, col_index, ]
  
  ## RGBを取り出す
  r <- img[, , 1]
  g <- img[, , 2]
  b <- img[, , 3]
  
  ## ピクセル値を0～255に変換
  r <- r * 255
  g <- g * 255
  b <- b * 255
  
  ## RGBヒストグラムを作成
  hist_r <- hist(as.vector(r), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  hist_g <- hist(as.vector(g), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  hist_b <- hist(as.vector(b), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  
  ## B・G・Rのヒストグラムを結合
  tmp <- c(hist_b, hist_g, hist_r)
  
  ## 特徴量を保存
  pixels_shiba[[length(pixels_shiba) + 1]] <- tmp
}

## 柴犬のラベルを作成
labels_shiba <- rep(0, length(pixels_shiba))

## ピクセル値をデータフレーム形式へ変換
pixels_shiba <- as.data.frame(do.call(rbind, pixels_shiba))

## サイズの確認
print(dim(pixels_shiba))

## 最初の6行を確認
head(pixels_shiba)






## サモエドのフォルダへ移動
setwd("C:/GoogleColab/img.input/samoyed")

## ファイルの取得
files <- list.files()
length(files)

## サモエドの特徴量を格納するリスト
pixels_samo <- list()

## 画像を1枚ずつ処理
for (f in files) {
  
  ## 画像を読み込み
  img <- readJPEG(f)
  
  ## 画像を256×256にリサイズ
  row_index <- round(seq(1, dim(img)[1], length.out = 256))
  col_index <- round(seq(1, dim(img)[2], length.out = 256))
  img <- img[row_index, col_index, ]
  
  ## RGBを取り出す
  r <- img[, , 1]
  g <- img[, , 2]
  b <- img[, , 3]
  
  ## ピクセル値を0～255に変換
  r <- r * 255
  g <- g * 255
  b <- b * 255
  
  ## RGBヒストグラムを作成
  hist_r <- hist(as.vector(r),  breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  hist_g <- hist(as.vector(g), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  hist_b <- hist(as.vector(b), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  
  ## B・G・Rのヒストグラムを結合
  tmp <- c(hist_b, hist_g, hist_r)
  
  ## 特徴量を保存
  pixels_samo[[length(pixels_samo) + 1]] <- tmp
}

## サモエドのラベルを作成
labels_samo <- rep(1, length(pixels_samo))

## ピクセル値をデータフレーム形式へ変換
pixels_samo <- as.data.frame(do.call(rbind, pixels_samo))

## 特徴量を結合
pixels_set <- rbind(pixels_shiba, pixels_samo)

## ラベルを結合
labels_set <- c(labels_shiba, labels_samo)





## 学習用データとテスト用データに分割
set.seed(0)
train_id <- sample(1:nrow(pixels_set), size = 0.8 * nrow(pixels_set))

trainX <- pixels_set[train_id, ]
testX <- pixels_set[-train_id, ]
trainY <- labels_set[train_id]
testY <- labels_set[-train_id]

## SVM ###



## 学習データを標準化
train_mean <- colMeans(trainX)
train_sd <- apply(trainX, 2, sd)


## 標準偏差が0の特徴量は1として扱う
train_sd[train_sd == 0] <- 1
trainX <- scale(trainX, center = train_mean, scale = train_sd)


## 5分割交差検証
set.seed(0)

fold_id <- sample(rep(1:5, length.out = nrow(trainX)))

scores <- c()

for (i in 1:5) {
  
  x <- trainX[fold_id != i, ]
  y <- trainY[fold_id != i]
  
  x_test <- trainX[fold_id == i, ]
  y_test <- trainY[fold_id == i]
  
  clf <- svm(x, factor(y))
  
  pred_y <- predict(clf, x_test)
  
  score <- mean(pred_y == factor(y_test))
  
  scores <- c(scores, score)
}

print(mean(scores))
print(sd(scores))








## テストデータを標準化
testX <- scale(testX, center = train_mean, scale = train_sd)

## テストデータを予測
pred <- predict(clf, testX)

## 正解率を計算
score <- mean(pred == factor(testY))
print(score)

## 混同行列の描画
conf_mat <- table(testY, pred)
print(conf_mat)






## 新規画像で評価

setwd("C:/GoogleColab/img.input/newdog")
files <- list.files()


## 特徴量を格納するリスト
pixels_new <- list()

## 画像を1枚ずつ処理
for (f in files) {
  
  img <- readJPEG(f)
  row_index <- round(seq(1, dim(img)[1], length.out = 256))
  col_index <- round(seq(1, dim(img)[2], length.out = 256))
  img <- img[row_index, col_index, ]
  
  r <- img[, , 1]
  g <- img[, , 2]
  b <- img[, , 3]
  r <- r * 255
  g <- g * 255
  b <- b * 255
  
  hist_r <- hist(as.vector(r), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  hist_g <- hist(as.vector(g), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  hist_b <- hist(as.vector(b), breaks = seq(0, 256, length.out = 257), plot = FALSE)$counts
  
  tmp <- c(hist_b, hist_g, hist_r)
  pixels_new[[length(pixels_new) + 1]] <- tmp
}

## データフレームに変換
pixels_new <- as.data.frame(do.call(rbind, pixels_new))

## サイズを確認
print(dim(pixels_new))




## 新しい画像の特徴量を標準化
new_mean <- colMeans(pixels_new)
new_sd <- apply(pixels_new, 2, sd)

new_sd[new_sd == 0] <- 1
pixels_new <- scale(pixels_new, center = new_mean, scale = new_sd)

## 予測
pred <- predict(clf, pixels_new)

print(pred)
