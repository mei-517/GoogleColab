import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.animation as animation#アニメーション用

import pickle

# Figureを追加
fig = plt.figure(figsize = (8, 8))

# 3DAxesを追加
ax = fig.add_subplot(111, projection='3d')

# 軸目盛を設定
#d = np.linspace(-1, 1, 11)
#ax.set_xticks(d)
#ax.set_yticks(d)
#ax.set_zticks(d)

# 軸の範囲を設定
ax.set_xlim(-1500,1500)
ax.set_zlim(-1500,1500)
ax.set_ylim(-1500,1500)

# 軸ラベルを設定
#ax.set_xlabel("x", size = 24)
#ax.set_ylabel("y", size = 24)
#ax.set_zlabel("z", size = 24)

# 軸ラベルを消去
#ax.axes.xaxis.set_ticklabels([])
#ax.axes.yaxis.set_ticklabels([])
#ax.axes.zaxis.set_ticklabels([])


#データファイルの設定
InputName = ['movie1', 'movie2']#2つの動画を用意する

#接続情報（'smpl_24'（体の24点））
joint_edges = [[1,4],[1,0],[2,5],[2,0],[3,6],[3,0],[4,7],[5,8],[6,9],[7,10],[8,11],[9,12],[12,13],[12,14],[12,15],[13,16],[14,17],[16,18],[17,19],[18,20],[19,21],[20,22],[21,23]]
joint_colors = ['red', 'black', 'blue']

#データの読み込み
input_list = []
for iname in InputName:
  loadpose = []
  with open(iname+'.pickle', mode='rb') as f:
    loadpose = pickle.load(f)
  input_list.append(loadpose)

#動画のフレーム数の取得
vf = 100000
for il in input_list:
  if vf>len(il):
    vf = len(il)
print(vf)

#画像表示
skt = []

def init():
  pass

def update(n):
  global input_list
  global skt
  global ax
  while len(skt)>0:
    skt.pop(0).remove()

  for k,vl in enumerate(input_list):
    poses3d = vl[n][1]
    for pose3d in poses3d:
      for i_start, i_end in joint_edges:
        s = ax.plot((pose3d[i_start][0] - poses3d[0][0][0], pose3d[i_end][0] - poses3d[0][0][0]),
                    (pose3d[i_start][2] - poses3d[0][0][2], pose3d[i_end][2] - poses3d[0][0][2]),
                    (-pose3d[i_start][1] + poses3d[0][0][1], -pose3d[i_end][1] + poses3d[0][0][1]),
                     marker='o', markersize=2, color = joint_colors[k])
        skt.append(s[0])
  print(str(n+1)+' / '+str(vf),end='\r')


ani = animation.FuncAnimation(fig, update, init_func=init, interval = 30, frames = vf, repeat=False)
ani.save(InputName[0]+'_mpl_3d.mp4', writer='ffmpeg')
#ani.save('anim.gif')

#set PATH=%PATH%;C:\Users\makino\Documents\3DP\ffmpeg-master-latest-win64-gpl-shared\bin

