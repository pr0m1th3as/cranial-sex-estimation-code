# Copyright (C) 2019 Andreas Bertsatos <andreas.bertsatos@gmail.com>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, see <http://www.gnu.org/licenses/>.

import os
import numpy as np
import pandas as pd
from sklearn import svm
from skimage.feature import hog

# read all available HMI files from training, testing and cross-validation
# directories and test if HMI dimensions are correct for the occipital height
# map images
# training directory
os.chdir('./HMI_train')
train_dir = os.listdir()
train_sample_size = 0
train_files = []
for file in train_dir:
    train_HMI = np.genfromtxt(file,delimiter=',')
    if (train_HMI.shape[0] == 50) and (train_HMI.shape[1] == 60):
        train_files.append(file)
        train_sample_size = train_sample_size + 1
# save keys and labels for training sample: 1==Male, 2==Female
dframe = pd.read_csv('train_labels.csv',header=None)
train_keys = np.asarray(dframe[0])
train_labels = np.asarray(dframe[1])
os.chdir('..')
print('Train sample size is: ', train_sample_size)
# testing directory
os.chdir('./HMI_test')
test_dir = os.listdir()
test_sample_size = 0
test_files = []
for file in test_dir:
    test_HMI = np.genfromtxt(file,delimiter=',')
    if (test_HMI.shape[0] == 50) and (test_HMI.shape[1] == 60):
        test_files.append(file)
        test_sample_size = test_sample_size + 1
# save keys and labels for testing sample: 1==Male, 2==Female
dframe = pd.read_csv('test_labels.csv',header=None)
test_keys = np.asarray(dframe[0])
test_labels = np.asarray(dframe[1])
os.chdir('..')
print('Test sample size is: ', test_sample_size)
# cross-validation directoy
os.chdir('./HMI_cross')
cross_dir = os.listdir()
cross_sample_size = 0
cross_files = []
for file in cross_dir:
    cross_HMI = np.genfromtxt(file,delimiter=',')
    if (cross_HMI.shape[0] == 50) and (cross_HMI.shape[1] == 60):
        cross_files.append(file)
        cross_sample_size = cross_sample_size + 1
# save keys and labels for cross-validation sample: 1==Male, 2==Female
dframe = pd.read_csv('cross_labels.csv',header=None)
cross_keys = np.asarray(dframe[0])
cross_labels = np.asarray(dframe[1])
os.chdir('..')
print('Cross-validation sample size is: ', test_sample_size)

# sort training samples according to keys & labels previously read from
# from the 'train_lables.csv' file
os.chdir('./HMI_train')
train_DATA = np.zeros((train_sample_size,50,60))
train_LIST = np.zeros((train_sample_size))
for i in range(0,train_sample_size):
    dfb = pd.read_csv(train_files[i],header=None)
    train_sample = np.asarray(dfb)
    train_DATA[i,:,:] = train_sample
    key = int(train_files[i][5:8])
    idx = np.where(train_keys == key)[0]
    train_LIST[i] = (train_labels[idx][0])
os.chdir('..')

# sort testing samples according to keys & labels previously read from
# from the 'test_lables.csv' file
os.chdir('./HMI_test')
test_DATA = np.zeros((test_sample_size,50,60))
test_LIST = np.zeros((test_sample_size))
test_KEYS = np.zeros((test_sample_size))
for i in range(0,test_sample_size):
    dfb = pd.read_csv(test_files[i],header=None)
    test_sample = np.asarray(dfb)
    test_DATA[i,:,:] = test_sample
    key = int(test_files[i][4:7])
    test_KEYS[i] = key
    idx = np.where(test_keys == key)[0]
    test_LIST[i] = (test_labels[idx][0])
os.chdir('..')

# sort cross-validation samples according to keys & labels previously
# read from from the 'test_lables.csv' file
os.chdir('./HMI_cross')
cross_DATA = np.zeros((cross_sample_size,50,60))
cross_LIST = np.zeros((cross_sample_size))
cross_KEYS = np.zeros((cross_sample_size))
for i in range(0,cross_sample_size):
    dfb = pd.read_csv(cross_files[i],header=None)
    cross_sample = np.asarray(dfb)
    cross_DATA[i,:,:] = cross_sample
    key = int(cross_files[i][5:8])
    cross_KEYS[i] = key
    idx = np.where(cross_keys == key)[0]
    cross_LIST[i] = (cross_labels[idx][0])
os.chdir('..')


# extracting Histogram of Oriented Gradients from the training, testing,
# and corss-validation samples
n_features = 200
train_HOGs = np.zeros((train_sample_size,n_features))
for i in range(0,train_sample_size):
    train_HOGs[i,:] = hog(train_DATA[i],orientations=8,pixels_per_cell=(10,12),cells_per_block=(1,1))
print('HOG training matrix is: ', train_HOGs.shape)
test_HOGs = np.zeros((test_sample_size,n_features))
for i in range(0,test_sample_size):
    test_HOGs[i,:] = hog(test_DATA[i],orientations=8,pixels_per_cell=(10,12),cells_per_block=(1,1))
print('HOG testing matrix is: ', test_HOGs.shape)
cross_HOGs = np.zeros((cross_sample_size,n_features))
for i in range(0,cross_sample_size):
    cross_HOGs[i,:] = hog(cross_DATA[i],orientations=8,pixels_per_cell=(10,12),cells_per_block=(1,1))
print('HOG cross-validation matrix is: ', cross_HOGs.shape)


# reshape training label array for setting up SVM classifiers with rbf kernel
train_LIST = np.reshape(train_LIST,(train_sample_size))
class1 = svm.SVC(kernel='rbf',C=20,probability=False,gamma=(1/n_features))
class1.fit(X=train_HOGs[:train_sample_size,:],y=train_LIST[:train_sample_size])


# get soft classification results and append them to csv file along with their respective
# key and label for each testing sample.
scoresRBF = class1.decision_function(test_HOGs[:test_sample_size,:])
scoresRBF = np.reshape(scoresRBF,(len(scoresRBF),1))
test_LIST = np.reshape(test_LIST,(len(test_LIST),1))
test_KEYS = np.reshape(test_KEYS,(len(test_KEYS),1))
test_output_array = np.concatenate((scoresRBF,test_LIST),axis=1)
test_output_array = np.concatenate((test_KEYS,test_output_array),axis=1)
print('Test sample classification results', test_output_array.shape, 'saved in test_classification.csv')
df = pd.DataFrame(test_output_array)
df.to_csv('test_classification.csv', index=False, header=False)

# get soft classification results and append them to csv file along with their respective
# key and label for each cross-validation sample.
scoresRBF = class1.decision_function(cross_HOGs[:cross_sample_size,:])
scoresRBF = np.reshape(scoresRBF,(len(scoresRBF),1))
cross_LIST = np.reshape(cross_LIST,(len(cross_LIST),1))
cross_KEYS = np.reshape(cross_KEYS,(len(cross_KEYS),1))
cross_output_array = np.concatenate((scoresRBF,cross_LIST),axis=1)
cross_output_array = np.concatenate((cross_KEYS,cross_output_array),axis=1)
print('Cross-validation sample classification results', cross_output_array.shape, 'saved in cross_classification.csv')
df = pd.DataFrame(cross_output_array)
df.to_csv('cross_classification.csv', index=False, header=False)

# get dual coefficients (y_i * alpha_i), support vectors (x_i), intercept (rho) 
# and gamma (1/n_features) parameter of the trained model and store it in csv file
dc = class1.dual_coef_
dc = np.reshape(dc,(len(dc[0,:]),1))
sv = class1.support_vectors_
output = np.concatenate((dc,sv),axis=1)
# add a row at the end with first element being rho and second being gamma
rg = np.zeros((1,n_features+1))
rg[0,0] = class1.intercept_
rg[0,1] = 1/n_features
output = np.concatenate((output,rg),axis=0)
print('Trained model attributes', output.shape, 'saved in trainedmodel.csv')
df = pd.DataFrame(output)
df.to_csv('trainedmodel.csv', index=False, header=False)