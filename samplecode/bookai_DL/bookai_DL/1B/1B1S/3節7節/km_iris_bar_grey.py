from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
import numpy as np
import pandas as pd
from sklearn.datasets import load_iris

iris = load_iris()

cls = KMeans(n_clusters=3)
result = cls.fit(iris.data)

iris_pd = pd.DataFrame(iris.data, columns=iris.feature_names)
iris_pd['ID'] = result.labels_
iris_pd_mean = iris_pd.groupby('ID').mean()
colorlist = ["0.2", "0.4", "0.6", "0.8"]
iris_pd_mean.plot.bar(color=colorlist, stacked=True)
plt.show()
