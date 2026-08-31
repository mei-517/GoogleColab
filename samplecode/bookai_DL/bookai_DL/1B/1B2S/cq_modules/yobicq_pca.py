from matplotlib import pyplot as plt
from sklearn.decomposition import PCA
import numpy as np
import pandas as pd
from sklearn.preprocessing import scale
import japanize_matplotlib
import math
from sklearn import preprocessing

def plot(pca):
    x = range(1,pca.n_features_+1)
    plt.plot(x, np.cumsum(pca.explained_variance_ratio_), marker="o", color = "red", linestyle = "--")
    plt.bar(x, pca.explained_variance_ratio_, color = "blue")
    plt.xlim(0, pca.n_features_+1)
    plt.ylim(0, 1.05)
    plt.xlabel('PC')
    plt.ylabel('寄与率・累積寄与率')
    plt.show()



def summay(pca):
    np.set_printoptions(formatter={'float': '{: 0.6f}'.format})
#    print(f'標準偏差　 {np.sqrt(pca.explained_variance_)}')
#    print(f'寄与率　 　{pca.explained_variance_ratio_}')
#    print(f'累積寄与率 {np.cumsum(pca.explained_variance_ratio_)}')
    name = []#np.array([0, 1, 2, 3])
    n = pca.n_features_
    for i in range(n):
        name.append(f'PC{i+1}')
    df = pd.DataFrame(
        [np.sqrt(pca.explained_variance_),pca.explained_variance_ratio_,np.cumsum(pca.explained_variance_ratio_)],
        index=['標準偏差　', '寄与率　　', '累積寄与率'],
        columns=name
        )
    print(df)


def biplot(pca, data, pcx, pcy, new_data=None, scale=1,pc_biplot=False, labels=None):
#    print('my_biplot')
#    print(new_data)
    n = pca.n_samples_
    lam = np.sqrt(pca.explained_variance_)
    lam = lam**scale
    if pc_biplot is False:
        lam = lam/np.sqrt(n)
    scores = pca.transform(data)/lam
#    print(scores)
    comp = pca.components_.T*lam
    pcx = pcx-1
    pcy = pcy-1
    vr = pca.explained_variance_ratio_
    xmin_s = np.min(scores[:,pcx])
    xmax_s = np.max(scores[:,pcx])
    ymin_s = np.min(scores[:,pcy])
    ymax_s = np.max(scores[:,pcy])

    xmin_c = np.min(comp[:,pcx])
    xmax_c = np.max(comp[:,pcx])
    ymin_c = np.min(comp[:,pcy])
    ymax_c = np.max(comp[:,pcy])

    if new_data is not None:
#       print(lam)
       new_scores = pca.transform(new_data)/lam
#       print(new_scores)
       new_xmin_s = np.min(new_scores[:,pcx])#,scores[:,pcx])
       new_xmax_s = np.max(new_scores[:,pcx])#,scores[:,pcx])
       new_ymin_s = np.min(new_scores[:,pcy])#,scores[:,pcy])
       new_ymax_s = np.max(new_scores[:,pcy])#,scores[:,pcy])
       xmin_s = xmin_s if xmin_s < new_xmin_s else new_xmin_s
       xmax_s = xmax_s if xmax_s > new_xmax_s else new_xmax_s
       ymin_s = ymin_s if ymin_s < new_ymin_s else new_ymin_s
       ymax_s = ymax_s if ymax_s > new_ymax_s else new_ymax_s


    lim_max = np.max([xmax_s,ymax_s])
    lim_min = np.min([xmin_s,ymin_s])

    ratio = np.max([xmax_c/lim_max, ymax_c/lim_max, xmin_c/lim_min, ymin_c/lim_min])
    lim_min *= 1.2
    lim_max *= 1.2

    fig, ax1 = plt.subplots(figsize=(6, 6))
    ax1.scatter(comp[:, pcx], comp[:, pcy], c='red', marker='.', s=0)#, label=list(df.index))#, alpha=0.8)#, c=list(df.iloc[:, 0]))
    for i in range(len(list(data.columns))):
        ax1.text(comp[i, pcx], comp[i, pcy],list(data.columns)[i],color="red")
        ax1.annotate('', xy=[0,0],xytext=[comp[i, pcx], comp[i, pcy]],arrowprops=dict(arrowstyle='<-',facecolor='red',edgecolor='red'))#plt.grid()
    ax1.tick_params(axis='x', colors='red')
    ax1.tick_params(axis='y', colors='red')
    ax1.set_xlim(lim_min*ratio,lim_max*ratio)
    ax1.set_ylim(lim_min*ratio,lim_max*ratio)
    ax1.grid()
    plt.xlabel('PC'+str(pcx+1)+'('+'{:.2f}'.format(vr[pcx]*100)+' %)')
    plt.ylabel('PC'+str(pcy+1)+'('+'{:.2f}'.format(vr[pcy]*100)+' %)')

    markerlist = [".", ",", "o", "v", "^", "<", ">", "1", "2", "3"]
    colorlist = ["r", "g", "b", "c", "m", "y", "k", "w"]
    ax2 = ax1.twinx().twiny() 
    ax2.set_xlim(lim_min,lim_max)
    ax2.set_ylim(lim_min,lim_max)
    for i in range(len(list(data.index))):
        if labels is None:
            ax2.scatter(scores[i, pcx], scores[i, pcy], c='blue',marker='o')
        else:
            ax2.scatter(scores[i, pcx], scores[i, pcy], c=colorlist[labels[i]],marker=markerlist[labels[i]])
        ax2.text(scores[i, pcx]+0.1, scores[i, pcy]+0.1,list(data.index)[i])
    if new_data is not None:
        ax2.scatter(new_scores[:, pcx], new_scores[:, pcy], c='green',marker='^')
        for i in range(len(list(new_data.index))):
            ax2.text(new_scores[i, pcx]+0.1, new_scores[i, pcy]+0.1,list(new_data.index)[i])
    plt.show()
