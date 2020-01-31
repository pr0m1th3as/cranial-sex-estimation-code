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

% This script reads all ".mat" files (generated with the skullanalyzer software) from the Results
% folder, and extracts the EFDs of the NasionBregma segment for each sample that is available. If
% cranial feature is missing or contains single row vector of zeros ([0 0 0 0]), then it is omitted.
% After reading all available samples, find the smallest number of harmonics calculated for any
% particular sample, and trim all available EFD matrices to this size (length(EFD(1,:)),:).
% Subsequently, run linear discriminant analysis to find the particular EFDs that are the most
% discriminatory between the two classification groups (males, females). After determining the most
% discriminatory EFDs, run a number of iterations with random sample spliting between training and
% testing subsamples and calculate discriptive statistics on various decision thresholds (0:+-1.4)
clear
iterations = 100;


% create a unified list from all available occipital protuberance HMI files
ABH = dir("../Results/ABH*Cranium.mat");
WLH = dir("../Results/WLH*Cranium.mat");
MOTOL = dir("../Results/MOTOL*Cranium.mat");
HOMOL = dir("../Results/HOMOL*Cranium.mat");

% for each sublist create a unified appropriate filename and label list
sex = csvread("GR_sex.txt");
for i=1:length(ABH)
	sample_id = str2num(ABH(i).name([4:6]));
	label(i,:) = sex(sex(:,1)==sample_id,:);
	files(i).name = ABH(i).name;
end
for j=1:length(WLH)
	sample_id = str2num(WLH(j).name([4:6]));
	label(i+j,:) = sex(sex(:,1)==sample_id,:);
	files(i+j).name = WLH(j).name;
end
sex = csvread("MOTOL_sex.txt");
for k=1:length(MOTOL)
	sample_id = str2num(MOTOL(k).name([6:8]));
	label(i+j+k,:) = sex(sex(:,1)==sample_id,:);
	files(i+j+k).name = MOTOL(k).name;
end
sex = csvread("HOMOLKA_sex.txt");
for l=1:length(HOMOL)
	sample_id = str2num(HOMOL(l).name([6:8]));
	label(i+j+k+l,:) = sex(sex(:,1)==sample_id,:);
	files(i+j+k+l).name = HOMOL(l).name;
end
t_sample = j+k+l;
c_sample = i;

% for each filename load appropriate .mat file and save the NasionBregma EFD matrix
valid = 0;
for s=1:length(files)
	file_path = ["../Results/" files(s).name];
	load(char(file_path), "EFD");
	% check if NasionBregma field exist and append it to new structure along with filename and
	% sex label (Males == 1, Females == 2)
	if(isfield(EFD, "NasionBregma"))
		if(length(EFD(1).NasionBregma(:,1)) > 1)
			valid += 1;
			valid_samples(valid).name = files(s).name;
			valid_samples(valid).nbEFD = EFD.NasionBregma;
			valid_samples(valid).class = label(s,2);	
		endif
	endif
	clear EFD
endfor

% retain only the first 12 A and C EFD coefficients, since B and D are ~zero, and append all
% coefficients in a single row vector [a1,a2,...,a12,c1,c2,...,c12], precedented by the class
% label of each sample. i.e. [sex,a1,a2,...,a12,c1,c2,...,c12]
for s=1:valid
	A = valid_samples(s).nbEFD(1:12,1);
	C = valid_samples(s).nbEFD(1:12,3);
	sex = valid_samples(s).class;
	DATA(s,:) = [sex, A', C'];
end
% use only the most discriminatory EFDs in the range vector below. Note that the first weight in
% CC.weights is the constant, but keep the same index since DATA(:,1) is the class label (sex)
EFDs = [2:5,8,15,16];		%retained EFDs: A1,A2,A3,A4,A7,C2,C3

% run a number of iterations to find out cross validated classification statistics
for iter=1:iterations
	idx = randperm(t_sample);
	train_range = idx(1:160) + c_sample;
	test_range = idx(161:end) + c_sample;
	cross_range = [1:c_sample];
	CC = train_sc(DATA(train_range,EFDs),DATA(train_range,1));
	Rt = test_sc(CC, DATA(test_range,EFDs),'LDA',[DATA(test_range,1)]);
	Rc = test_sc(CC, DATA(cross_range,EFDs),'LDA',[DATA(cross_range,1)]);
	
	% check if testing sample was corectly classified and append the results on a new matrix
	cor_pred = zeros(1,15);
	unc_pred = zeros(1,15);
	for test_sample=1:length(test_range)
		df = Rt.output(test_sample,2);	%positive value implies female
		s = DATA(test_range(test_sample),1);
		% for cut off point ranging from 0 to +-1 at 0.1 intervals
		for q=0:14
			cop = q / 10;
			if((s==2 && df>cop) || (s==1 && df<-cop))
				cor_pred(q+1) += 1;
			elseif((s==2 && df<cop && df>-cop) || (s==1 && df<cop && df>-cop))
				unc_pred(q+1) += 1;
			endif
			index(q+1) = cop;
		endfor
		test(test_sample).files = valid_samples(test_range(test_sample)).name;
		test(test_sample).labels = valid_samples(test_range(test_sample)).class;
	endfor
	for train_sample=1:length(train_range)
		train(train_sample).files = valid_samples(train_range(train_sample)).name;
		train(train_sample).labels = valid_samples(train_range(train_sample)).class;
	endfor
	classification(iter).test_class = [cor_pred./(ones(1,15)*test_sample-unc_pred); unc_pred./test_sample];
	classification(iter).train = train;
	classification(iter).test = test;
	classification(iter).weights = CC.weights;
	% check if cross-validation sample was corectly classified and append the results on a new matrix
	cor_pred = zeros(1,15);
	unc_pred = zeros(1,15);
	for cross_sample=1:length(cross_range)
		df = Rc.output(cross_sample,2);	%positive value implies female
		s = DATA(cross_range(cross_sample),1);
		% for cut off point ranging from 0 to +-1 at 0.1 intervals
		for q=0:14
			cop = q / 10;
			if((s==2 && df>cop) || (s==1 && df<-cop))
				cor_pred(q+1) += 1;
			elseif((s==2 && df<cop && df>-cop) || (s==1 && df<cop && df>-cop))
				unc_pred(q+1) += 1;
			endif
			index(q+1) = cop;
		endfor
		cross(cross_sample).files = valid_samples(cross_range(cross_sample)).name;
		cross(cross_sample).labels = valid_samples(cross_range(cross_sample)).class;
	endfor
	classification(iter).cross_class = [cor_pred./(ones(1,15)*cross_sample-unc_pred); unc_pred./cross_sample];
	classification(iter).cross = cross;
endfor
% save results
save("nb_classification.mat", "classification" );

% plot results
for i=1:iterations
	nbTestClass(i,:) = classification(i).test_class(1,:);
	nbTestReject(i,:) = classification(i).test_class(2,:);
	nbCrossClass(i,:) = classification(i).cross_class(1,:);
	nbCrossReject(i,:) = classification(i).cross_class(2,:);
endfor
h1 = figure;
nbStatsTestClass = boxplot(nbTestClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Nasion Bregma EFD correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("LDA decision threshold range");
ylabel("testing sample classification");
print(h1,"nbTestClass.png");
h2 = figure;
nbStatsReject = boxplot(nbTestReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Nasion Bregma EFD classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("LDA decision threshold range");
ylabel("testing sample rejection");
print(h2,"nbTestReject.png");
h3 = figure;
nbStatsCrossClass = boxplot(nbCrossClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Nasion Bregma EFD correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("LDA decision threshold range");
ylabel("cross-validation sample classification");
print(h3,"nbCrossClass.png");
h4 = figure;
nbStatsCrossReject = boxplot(nbCrossReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Nasion Bregma EFD classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("LDA decision threshold range");
ylabel("cross-validation sample rejection");
print(h4,"nbCrossReject.png");