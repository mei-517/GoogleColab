from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split

import csv

np.random.seed(1)

#データの読み込み
with open('grape.txt') as f:
    rf = csv.reader(f, quoting=csv.QUOTE_NONNUMERIC,delimiter='\t')
    da = [row for row in rf]

da_train, da_test = train_test_split(da, test_size=0.1)


da_g_train = np.array(da_train)
da_g_test = np.array(da_test)

da_kg_train = np.array(da_train)
da_kg_train[:,1] = da_kg_train[:,1]/1000
da_kg_test = np.array(da_test)
da_kg_test[:,1] = da_kg_test[:,1]/1000

#g単位で分類
cls = KMeans(n_clusters=2)
result = cls.fit(da_g_train)
result_test = cls.predict(da_g_test)
plt.scatter(da_g_train[:,0], da_g_train[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.scatter(da_g_test[:,0], da_g_test[:,1], c=result_test, cmap='Greys', edgecolors='k', marker='D')
plt.show()


#kg単位で分類
cls = KMeans(n_clusters=2)
result = cls.fit(da_kg_train)
result_test = cls.predict(da_kg_test)
plt.scatter(da_kg_train[:,0], da_kg_train[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.scatter(da_kg_test[:,0], da_kg_test[:,1], c=result_test, cmap='Greys', edgecolors='k', marker='D')
plt.show()

from sklearn.preprocessing import MinMaxScaler
mmsc = MinMaxScaler()

#g単位を正規化して分類
da_g_train_norm = mmsc.fit_transform(da_g_train)
da_g_test_norm = mmsc.transform(da_g_test)

cls = KMeans(n_clusters=2)
result = cls.fit(da_g_train_norm)
result_test = cls.predict(da_g_test_norm)
plt.scatter(da_g_train_norm[:,0], da_g_train_norm[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.scatter(da_g_test_norm[:,0], da_g_test_norm[:,1], c=result_test, cmap='Greys', edgecolors='k', marker='D')
plt.show()

#kg単位を正規化して分類
mmsc = MinMaxScaler()
da_kg_train_norm = mmsc.fit_transform(da_kg_train)
da_kg_test_norm = mmsc.transform(da_kg_test)

cls = KMeans(n_clusters=2)
result = cls.fit(da_kg_train_norm)
result_test = cls.predict(da_kg_test_norm)
plt.scatter(da_kg_train_norm[:,0], da_kg_train_norm[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.scatter(da_kg_test_norm[:,0], da_kg_test_norm[:,1], c=result_test, cmap='Greys', edgecolors='k', marker='D')
plt.show()
