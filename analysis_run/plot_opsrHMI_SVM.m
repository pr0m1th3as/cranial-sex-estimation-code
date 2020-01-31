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

% A script for displaying the classification results in boxplots based on the SVM
% of the Height Map Images from the supraorbital ridge and the occipital protuberance
% area. The script assumes that all relevant *_classification.mat files are present
% in the working folder.

% Occipital Protuberance HMI
load op_classification.mat
% determine iterations
iterations = length(classification);
for i=1:iterations
	opTestClass(i,:) = classification(i).test_class(1,:);
	opTestReject(i,:) = classification(i).test_class(2,:);
	opCrossClass(i,:) = classification(i).cross_class(1,:);
	opCrossReject(i,:) = classification(i).cross_class(2,:);
endfor
% Correct classification statistics for testing sample
h1 = figure;
opStatsTestClass = boxplot(opTestClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Occipital Protuberance HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample classification");
print(h1,"opTestClass.png");
% Classification rejection statistics for testing sample
h2 = figure;
opStatsTestReject = boxplot(opTestReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Occipital Protuberance HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample rejection");
print(h2,"opTestReject.png");
% Correct classification statistics for cross-validation sample
h3 = figure;
opStatsCrossClass = boxplot(opCrossClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Occipital Protuberance HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample classification");
print(h3,"opCrossClass.png");
% Classification rejection statistics for cross-validation sample
h4 = figure;
opStatsCrossReject = boxplot(opCrossReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Occipital Protuberance HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample rejection");
print(h4,"opCrossReject.png");
clear classification;
%
%
% Supraorbital Ridge HMI
load sr_classification.mat
for i=1:iterations
	srTestClass(i,:) = classification(i).test_class(1,:);
	srTestReject(i,:) = classification(i).test_class(2,:);
	srCrossClass(i,:) = classification(i).cross_class(1,:);
	srCrossReject(i,:) = classification(i).cross_class(2,:);
endfor
% Correct classification statistics for testing sample
h5 = figure;
srStatsTestClass = boxplot(srTestClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Supraorbital Ridge HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample classification");
print(h5,"srTestClass.png");
% Classification rejection statistics for testing sample
h6 = figure;
srStatsTestReject = boxplot(srTestReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Supraorbital Ridge HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample rejection");
print(h6,"srTestReject.png");
% Correct classification statistics for cross-validation sample
h7 = figure;
srStatsCrossClass = boxplot(srCrossClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Supraorbital Ridge HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample classification");
print(h7,"srCrossClass.png");
% Classification rejection statistics for cross-validation sample
h8 = figure;
srStatsCrossReject = boxplot(srCrossReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Supraorbital Ridge HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample rejection");
print(h8,"srCrossReject.png");
clear classification;