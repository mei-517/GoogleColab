from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
import numpy as np
import pandas as pd

da = np.array([[5, 2], [3, 2], [1, 1], [5, 4], [5, 5], [1, 4], [4, 4], [2, 3], [2, 1]])
da_test = np.array([[1, 2], [3, 5], [4, 1]])

cls = KMeans(n_clusters=2)
result = cls.fit(da)
result_test = cls.predict(da_test)

plt.scatter(da[:,0], da[:,1], c=result.labels_, cmap='rainbow', edgecolors='k')
plt.scatter(da_test[:,0], da_test[:,1], c=result_test, cmap='rainbow', edgecolors='k', marker='D')
plt.show()
