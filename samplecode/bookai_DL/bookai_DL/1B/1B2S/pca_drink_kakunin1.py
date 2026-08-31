from sklearn.decomposition import PCA
import pandas as pd
import numpy as np
#データの読み込み
df = pd.read_csv("drink_data.txt", sep="\t", index_col=0)
#主成分分析
pca = PCA()
pca.fit(df)
#結果の表示
print('標準偏差')
print(np.sqrt(pca.explained_variance_))
lam = np.sqrt(pca.explained_variance_)
print('分散')
print(pca.explained_variance_)
print('寄与率')
print(pca.explained_variance_ratio_)
print('主成分得点')
scores = pca.transform(df)
print(scores)
print('主成分')
comp = pca.components_
print(comp)
print('因子負荷量')
loading = pca.components_.T*lam
print(loading)
