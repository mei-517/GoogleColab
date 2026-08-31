import os
import sys

import cv2
#import tensorflow as tf

import poseviz

import numpy as np
import pickle

def main():
#動画ファイル名の設定
    InputName = 'd_dance_movie'

#モデルを読み込んで関節情報を得ることもできる（時間がかかるので下記で設定）
#    model = tf.saved_model.load('metrabs_mob3l_y4t')
#    skeleton = 'smpl_24'
#    joint_names = model.per_skeleton_joint_names[skeleton].numpy().astype(str)
#    joint_edges = model.per_skeleton_joint_edges[skeleton].numpy()

#'smpl_24'（体の24点）
    joint_names = ['pelv','lhip','rhip','spi1','lkne','rkne','spi2','lank','rank','spi3','ltoe','rtoe','neck','lcla','rcla','head','lsho','rsho','lelb','relb','lwri','rwri','lhan','rhan']
    joint_edges = [[1,4],[1,0],[2,5],[2,0],[3,6],[3,0],[4,7],[5,8],[6,9],[7,10],[8,11],[9,12],[12,13],[12,14],[12,15],[13,16],[14,17],[16,18],[17,19],[18,20],[19,21],[20,22],[21,23]]

#'smpl+head_30'(参考：頭部を詳しくした30点)
#    joint_names = ['pelv_smpl','lhip_smpl','rhip_smpl','bell_smpl','lkne_smpl','rkne_smpl','spin_smpl','lank_smpl','rank_smpl','thor_smpl','ltoe_smpl','rtoe_smpl','neck_smpl','lcla_smpl','rcla_smpl','head_smpl','lsho_smpl','rsho_smpl','lelb_smpl','relb_smpl','lwri_smpl','rwri_smpl','lhan_smpl','rhan_smpl','htop_mpi_inf_3dhp','learcoco','leyecoco','nosecoco','rearcoco','reyecoco'] 
#    joint_edges = [[1,4],[1,0],[2,5],[2,0],[3,6],[3,0],[4,7],[5,8],[6,9],[7,10],[8,11],[9,12],[12,13],[12,14],[12,15],[13,16],[14,17],[16,18],[17,19],[18,20],[19,21],[20,22],[21,23],[25,26],[26,27],[27,29],[28,29],[24,15],[15,27]]

# 3次元データの読み込み
    loadpose = []
    with open(InputName+'.pickle', mode='rb') as f:
        loadpose = pickle.load(f)

# 動画サイズの取得
    cap = cv2.VideoCapture(InputName+'.mp4')
    width = cap.get(cv2.CAP_PROP_FRAME_WIDTH)
    height = cap.get(cv2.CAP_PROP_FRAME_HEIGHT)
    camera = poseviz.Camera.from_fov(55, (width, height))
    cap.release()

# 関節位置の設定
    viz = poseviz.PoseViz(joint_names, joint_edges)

# 3次元表示
    for j in range(5):
        cap = cv2.VideoCapture(InputName+'.mp4')
        for i in range(len(loadpose)):
            ret, frame = cap.read()
            image = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
            viz.update(image, loadpose[i][0], loadpose[i][1], camera)
        cap.release()

    viz.close()


if __name__ == '__main__':
    main()




