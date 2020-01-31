% Copyright (C) 2019 Andreas Bertsatos <andreas.bertsatos@gmail.com>
%
% This program is free software; you can redistribute it and/or modify it under
% the terms of the GNU General Public License as published by the Free Software
% Foundation; either version 3 of the License, or (at your option) any later
% version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
% FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License along with
% this program; if not, see <http://www.gnu.org/licenses/>.

% a script for running all analyses based on the available geometric features and
% save all results and plotted figures in archived folders. Make sure that all
% folders are in the correct directory structure. The complete dataset may be found
% at https://zenodo.basbab
%	All HMI-related .csv files should be placed in the ../HMI/ folder and the corresponding
% .mat files should be saved in the ../Results/ folder. The three .txt files containing sample
% indices and sex information, which are also available in the dataset should be saved in the
% current working directory ("./analysis_run") along with the existing scripts and functions.

% load necessary packages
warning off;
pkg load nan;
pkg load statistics;
% start clock counter
tic
% run the analysis with ABH, WHL and MOTOL samples for SVM training and HOMOLKA for cross-validation
testAWM_crossH_ml_InfHMI;clear
testAWM_crossH_ml_LatHMI;clear
testAWM_crossH_mr_InfHMI;clear
testAWM_crossH_mr_LatHMI;clear
plot_mpHMI_SVM;close all
% archive generated files in a compressed archive
unix("tar -zcvf testAWM_crossH-mpHMI-SVM.tgz *.png *.csv *.mat");
unix("rm *.png");
unix("rm *.csv");
unix("rm *.mat");
unix("mv testAWM_crossH-mpHMI-SVM.tgz ./results");
testAWM_crossH_opHMI;clear
testAWM_crossH_srHMI;clear
plot_opsrHMI_SVM;close all
% archive generated files in a compressed archive
unix("tar -zcvf testAWM_crossH-opsrHMI-SVM.tgz *.png *.csv *.mat");
unix("rm *.png");
unix("rm *.csv");
unix("rm *.mat");
unix("mv testAWM_crossH-opsrHMI-SVM.tgz ./results");
testAWM_crossH_nbEFD;close all
% archive generated files in a compressed archive
unix("tar -zcvf testAWM_crossH-nbEFD-LDA.tgz *.png *.mat");
unix("rm *.png");
unix("rm *.mat");
unix("mv testAWM_crossH-nbEFD-LDA.tgz ./results");
% run the analysis with HOMOLKA, WHL and MOTOL samples for SVM training and ABH for cross-validation
testHWM_crossA_ml_InfHMI;clear
testHWM_crossA_ml_LatHMI;clear
testHWM_crossA_mr_InfHMI;clear
testHWM_crossA_mr_LatHMI;clear
plot_mpHMI_SVM;close all
% archive generated files in a compressed archive
unix("tar -zcvf testHWM_crossA-mpHMI-SVM.tgz *.png *.csv *.mat");
unix("rm *.png");
unix("rm *.csv");
unix("rm *.mat");
unix("mv testHWM_crossA-mpHMI-SVM.tgz ./results");
testHWM_crossA_opHMI;clear
testHWM_crossA_srHMI;clear
plot_opsrHMI_SVM;close all
% archive generated files in a compressed archive
unix("tar -zcvf testHWM_crossA-opsrHMI-SVM.tgz *.png *.csv *.mat");
unix("rm *.png");
unix("rm *.csv");
unix("rm *.mat");
unix("mv testHWM_crossA-opsrHMI-SVM.tgz ./results");
testHWM_crossA_nbEFD;close all
% archive generated files in a compressed archive
unix("tar -zcvf testHWM_crossA-nbEFD-LDA.tgz *.png *.mat");
unix("rm *.png");
unix("rm *.mat");
unix("mv testHWM_crossA-nbEFD-LDA.tgz ./results");
clear
% display total processing time
toc