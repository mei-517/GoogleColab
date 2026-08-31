from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
from sklearn import datasets
import numpy as np

np.random.seed(0)
n_samples = 1500

X, y =  datasets.make_blobs(n_samples=n_samples, random_state=8)
cls = KMeans(n_clusters=2)
result = cls.fit(X)
plt.scatter(X[:,0], X[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.show()

X, y = datasets.make_circles(n_samples=n_samples, factor=.5,noise=.05)
cls = KMeans(n_clusters=2)
result = cls.fit(X)
plt.scatter(X[:,0], X[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.show()

X, y = datasets.make_moons(n_samples=n_samples, noise=.05)
cls = KMeans(n_clusters=2)
result = cls.fit(X)
plt.scatter(X[:,0], X[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.show()

X = np.random.rand(n_samples, 2)
cls = KMeans(n_clusters=3)
result = cls.fit(X)
plt.scatter(X[:,0], X[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.show()
