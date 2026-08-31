from sklearn.decomposition import PCA#①主成分分析を行うためのライブラリ
import pandas as pd
from cq_modules import cq_pca#②主成分分析結果を表示するためのライブラリ
!pip install japanize_matplotlib
#③データの読み込み
df = pd.read_csv("apple_data.txt", sep="\t", index_col=0)
#④主成分分析
pca = PCA()#主成分分析の準備
pca.fit(df)#主成分分析の実行
#⑤結果の表示
cq_pca.summay(pca)
cq_pca.plot(pca)
cq_pca.biplot(pca, df, 1, 2, scale=0, pc_biplot=True)
