# Copyright (C) 2020 Andreas Bertsatos <andreas.bertsatos@gmail.com>
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
from skimage.feature import hog
# read the available HMI file from the HMI_test directory and according to
# its dimensions calculate the respective HOG coefficients and save them in
# a csv file

# enter testing directory and read tempHMI file
HMI = np.genfromtxt('tempHMI.csv',delimiter=',')

# check if size represents an occipital protuberance HMI
if (HMI.shape[0] == 90) and (HMI.shape[1] == 90):
    HOGs = np.zeros((1,432))
    HOGs = hog(HMI,orientations=8,pixels_per_cell=(10,15),cells_per_block=(1,1))

# check if size represents an supraorbital ridge HMI
if (HMI.shape[0] == 50) and (HMI.shape[1] == 60):
    HOGs = np.zeros((1,200))
    HOGs = hog(HMI,orientations=8,pixels_per_cell=(10,12),cells_per_block=(1,1))

# check if size represents an mastoid process lateral HMI
if (HMI.shape[0] == 80) and (HMI.shape[1] == 100):
    HOGs = np.zeros((1,640))
    HOGs = hog(HMI,orientations=8,pixels_per_cell=(10,10),cells_per_block=(1,1))

# check if size represents an mastoid process inferior HMI
if (HMI.shape[0] == 60) and (HMI.shape[1] == 60):
    HOGs = np.zeros((1,288))
    HOGs = hog(HMI,orientations=8,pixels_per_cell=(10,10),cells_per_block=(1,1))

df = pd.DataFrame(HOGs)
df.to_csv('tempHOG.csv', index=False, header=False)