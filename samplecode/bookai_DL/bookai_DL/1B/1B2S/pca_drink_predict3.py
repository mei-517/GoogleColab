from sklearn.decomposition import PCA
import pandas as pd
from cq_modules import cq_pca
#データの読み込み
df = pd.read_csv("drink_data.txt", sep="\t", index_col=0)
#主成分分析の実行
pca = PCA()
pca.fit(df)

print(pca.inverse_transform([1,  0, 0,   0, 0, 0]))
print(pca.inverse_transform([1, -2, 0,   0, 0, 0]))
print(pca.inverse_transform([1, -2, 0.8, 0, 0, 0]))

#結果の表示
#cq_cpa.summay(pca)
#cq_cpa.cp_plot(pca)
#cq_cpa.biplot(pca, df, 1, 2, scale=1, pc_biplot=True)

new_df = pd.read_csv("drink_predict_data3.txt", sep="\t", index_col=0)
cq_pca.biplot(pca, df, 1, 2, new_data=new_df, scale=0, pc_biplot=True)
