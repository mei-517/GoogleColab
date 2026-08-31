## Author: Mei Nagai


## Date:2026/08/31
## 第１部３章

install.packeges("e1071")
library(e1071)

## dataを取得
d <- read.table("elephant_data.txt",header = FALSE)

## Xd:体長体重 yd:ラベル
Xd <- d[,1:2]
yd <- d[,3]