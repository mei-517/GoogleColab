from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
import numpy as np
import pandas as pd

df = pd.read_csv('peach_xls.csv', encoding="shift_jis")
da = df.values

cls = KMeans(n_clusters=2)
result = cls.fit(da)

plt.scatter(da[:,0], da[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.show()
