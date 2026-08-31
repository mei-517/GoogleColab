from matplotlib import pyplot as plt
from sklearn.cluster import KMeans
import numpy as np
import pandas as pd

import csv
with open('peach.txt') as f:
    rf = csv.reader(f, quoting=csv.QUOTE_NONNUMERIC)
    da = [row for row in rf]
da = np.array(da)
print(da)

cls = KMeans(n_clusters=2)
result = cls.fit(da)

plt.scatter(da[:,0], da[:,1], c=result.labels_, cmap='Greys', edgecolors='k')
plt.show()
