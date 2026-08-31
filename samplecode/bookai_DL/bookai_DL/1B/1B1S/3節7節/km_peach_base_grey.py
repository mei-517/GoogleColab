from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
import numpy as np
import pandas as pd

da = np.array([[5, 2], [3, 2], [1, 1], [5, 4], [5, 5], [1, 4], [4, 4], [2, 3], [2, 1]])

cls = KMeans(n_clusters=2)
result = cls.fit(da)

plt.scatter(da[:,0], da[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.show()
