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

% A script for calculating correct classification results from the application of the
% combined models in the entire sample.

clear
% load the labels from the entire sample and read the decision function output results
load("./results/Full Sample.mat", "Sample");

corpred_s1t = zeros(1,30);unclass_s1t = zeros(1,30);
corpred_s1c = zeros(1,30);unclass_s1c = zeros(1,30);
corpred_s2t = zeros(1,30);unclass_s2t = zeros(1,30);
corpred_s2c = zeros(1,30);unclass_s2c = zeros(1,30);
corpred_ABH = zeros(1,30);unclass_ABH = zeros(1,30);
corpred_WLH = zeros(1,30);unclass_WLH = zeros(1,30);
corpred_MOT = zeros(1,30);unclass_MOT = zeros(1,30);
corpred_HOM = zeros(1,30);unclass_HOM = zeros(1,30);

% for every sample calculate the correct classification by accounting all features with given weights
for i=1:324
	% get decision functions' output for each split
	df1 = sum(Sample(i).df_split1.*[0.8,1.1,1.0,0.6,1.0,0.6,0.9]);
	df2 = sum(Sample(i).df_split2.*[0.8,1.0,1.0,0.6,1.0,0.6,0.8]);
	df=(df1+df2)/2;
	% check if sample was corectly classified and append the results on a new matrix
	s = Sample(i).label;
	for q=0:29
		cop = q / 5;
		% sample split #1
		if((s==2 && df1>cop) || (s==1 && df1<-cop))
			if(i<222)
				corpred_s1t(q+1) += 1;
			else
				corpred_s1c(q+1) += 1;
			endif			
		elseif((s==2 && df1<cop && df1>-cop) || (s==1 && df1<cop && df1>-cop))
			if(i<222)
				unclass_s1t(q+1) += 1;
			else
				unclass_s1c(q+1) += 1;
			endif
		endif
		% sample split #2
		if((s==2 && df2>cop) || (s==1 && df2<-cop))
			if(i>101)
				corpred_s2t(q+1) += 1;
			else
				corpred_s2c(q+1) += 1;
			endif
		elseif((s==2 && df2<cop && df2>-cop) || (s==1 && df2<cop && df2>-cop))
			if(i>101)
				unclass_s2t(q+1) += 1;
			else
				unclass_s2c(q+1) += 1;
			endif
		endif
		% combined splits classifiers on full sample
		if((s==2 && df>cop) || (s==1 && df<-cop))
			if(i<102)
				corpred_ABH(q+1) += 1;
			elseif(i<155)
				corpred_WLH(q+1) += 1;
			elseif(i<222)
				corpred_MOT(q+1) += 1;
			else
				corpred_HOM(q+1) += 1;
			endif			
		elseif((s==2 && df<cop && df>-cop) || (s==1 && df<cop && df>-cop))
			if(i<102)
				unclass_ABH(q+1) += 1;
			elseif(i<155)
				unclass_WLH(q+1) += 1;
			elseif(i<222)
				unclass_MOT(q+1) += 1;
			else
				unclass_HOM(q+1) += 1;
			endif	
		endif
	endfor
endfor
% classified test group, rejected test group, classified cross-val group, rejected cross-val group
sample_split_1 = [corpred_s1t./(ones(1,30)*221-unclass_s1t); unclass_s1t./221;...
									corpred_s1c./(ones(1,30)*103-unclass_s1c); unclass_s1c./103];
sample_split_2 = [corpred_s2t./(ones(1,30)*223-unclass_s2t); unclass_s2t./233;...
									corpred_s2c./(ones(1,30)*101-unclass_s2c); unclass_s2c./101];
h1 = figure;
h = plot([1:30], sample_split_1([1,2],:), "b", [1:30], sample_split_1([3,4],:), "y",...
					[1:30], sample_split_2([1,2],:), "c", [1:30], sample_split_2([3,4],:), "r");
axis([0,31,0,1.01]);
set(gca (), "xtick", [1:2:30], "xticklabel", {"0.0","±0.4","±0.8","±1.2","±1.6","±2.0","±2.4","±2.8",...
																						"±3.2","±3.6","±4.0","±4.4","±4.8","±5.2","±5.6"});
set(gca (), "ytick", [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
set (gca, "xgrid", "on");
plot_title = ["Combined morphometric features per sample split"];
title(plot_title);
xlabel("merged classifiers' decision threshold range");
ylabel("correct classification and unidentified rejection rates");
legend (h([1, 3, 5, 7]), {"split #1 testing sample", "split #1 cross-val sample",...
				"split #2 testing sample", "split #2 cross-val sample"}, "location", "southeast");
print(h1,"./results/gmf_predictionSS.png");




% classified test group, rejected test group, classified cross-val group, rejected cross-val group
full_sample_1 = [corpred_ABH./(ones(1,30)*101-unclass_ABH); unclass_ABH./101;...
									corpred_WLH./(ones(1,30)*53-unclass_WLH); unclass_WLH./53];
full_sample_2 = [corpred_MOT./(ones(1,30)*67-unclass_MOT); unclass_MOT./67;...
									corpred_HOM./(ones(1,30)*103-unclass_HOM); unclass_HOM./103];
h1 = figure;
h = plot([1:30], full_sample_1([1,2],:), "b", [1:30], full_sample_1([3,4],:), "y",...
					[1:30], full_sample_2([1,2],:), "c", [1:30], full_sample_2([3,4],:), "r");
axis([0,31,0,1.01]);
set(gca (), "xtick", [1:2:30], "xticklabel", {"0.0","±0.4","±0.8","±1.2","±1.6","±2.0","±2.4","±2.8",...
																						"±3.2","±3.6","±4.0","±4.4","±4.8","±5.2","±5.6"});
set(gca (), "ytick", [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
set (gca, "xgrid", "on");
plot_title = ["Combined morphometric features from both sample splits"];
title(plot_title);
xlabel("merged classifiers' decision threshold range");
ylabel("correct classification and unidentified rejection rates");
legend (h([1, 3, 5, 7]), {"ABH sample", "WLH sample",...
				"MOTOL sample", "HOMOLKA sample"}, "location", "southeast");
print(h1,"./results/gmf_predictionFS.png");
