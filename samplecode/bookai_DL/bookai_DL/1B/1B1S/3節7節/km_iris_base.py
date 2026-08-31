from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
import numpy as np
import pandas as pd
from sklearn.datasets import load_iris

iris = load_iris()

cls = KMeans(n_clusters=3)
result = cls.fit(iris.data)

plt.xlabel(iris.feature_names[0], fontsize=18)
plt.ylabel(iris.feature_names[1], fontsize=18)
plt.scatter(iris.data[:,0],iris.data[:,1], c=result.labels_, cmap='rainbow', edgecolors='k')
plt.show()
