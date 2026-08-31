from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
import numpy as np
import pandas as pd
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split

iris = load_iris()
iris_train, iris_test = train_test_split(iris.data, test_size=0.1)

cls = KMeans(n_clusters=3)
result = cls.fit(iris_train)
result_test = cls.predict(iris_test)

plt.xlabel(iris.feature_names[0], fontsize=18)
plt.ylabel(iris.feature_names[1], fontsize=18)
plt.scatter(iris_train[:,0],iris_train[:,1], c=result.labels_, cmap='rainbow', edgecolors='k')
plt.scatter(iris_test[:,0], iris_test[:,1], c=result_test, cmap='rainbow', edgecolors='k', marker='D')
plt.show()
