import pandas as pd
import numpy as np
import math
#データの読み込み
df = pd.read_csv("drink_data.txt", sep="\t", index_col=0)
#各項目の平均を0にする
df1 = df.iloc[:, ].apply(lambda x: (x-x.mean()), axis=0)
#特異値分解
U, s, V = np.linalg.svd(df1, full_matrices=True)
n = len(df)
#標準偏差
s1 = s/math.sqrt(n-1)
print('標準偏差')
print(s1)
#分散
print('分散')
s2 = s1**2
print(s2)
#寄与率
print('寄与率')
print(s2/np.sum(s2))
#主成分
print('主成分')
print(V)
#主成分得点
print('主成分得点')
sc = np.dot(df.values,V.T)
print(sc-np.average(sc, axis=0))
print('因子負荷量')
loading = V*s1
print(loading)
