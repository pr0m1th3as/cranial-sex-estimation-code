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
% of the Height Map Images from the inferior and lateral views of the left and
% right mastoid processes. The script assumes that all relevant *_classification.mat
% files are present in the working folder.

% Left Mastoid Process Inferior HMI
load mlInf_classification.mat
% determine iterations
iterations = length(classification);
for i=1:iterations
	mlInfTestClass(i,:) = classification(i).test_class(1,:);
	mlInfTestReject(i,:) = classification(i).test_class(2,:);
	mlInfCrossClass(i,:) = classification(i).cross_class(1,:);
	mlInfCrossReject(i,:) = classification(i).cross_class(2,:);
endfor
% Correct classification statistics for testing sample
h1 = figure;
mlInfStatsTestClass = boxplot(mlInfTestClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Left Mastoid Process Inferior HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample classification");
print(h1,"mlInfTestClass.png");
% Classification rejection statistics for testing sample
h2 = figure;
mlInfStatsTestReject = boxplot(mlInfTestReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Left Mastoid Process Inferior HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample rejection");
print(h2,"mlInfTestReject.png");
% Correct classification statistics for cross-validation sample
h3 = figure;
mlInfStatsCrossClass = boxplot(mlInfCrossClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Left Mastoid Process Inferior HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample classification");
print(h3,"mlInfCrossClass.png");
% Classification rejection statistics for cross-validation sample
h4 = figure;
mlInfStatsCrossReject = boxplot(mlInfCrossReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Left Mastoid Process Inferior HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample rejection");
print(h4,"mlInfCrossReject.png");
clear classification;
%
%
% Left Mastoid Process Lateral HMI
load mlLat_classification.mat
for i=1:iterations
	mlLatTestClass(i,:) = classification(i).test_class(1,:);
	mlLatTestReject(i,:) = classification(i).test_class(2,:);
	mlLatCrossClass(i,:) = classification(i).cross_class(1,:);
	mlLatCrossReject(i,:) = classification(i).cross_class(2,:);
endfor
% Correct classification statistics for testing sample
h5 = figure;
mlLatStatsTestClass = boxplot(mlLatTestClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Left Mastoid Process Lateral HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample classification");
print(h5,"mlLatTestClass.png");
% Classification rejection statistics for testing sample
h6 = figure;
mlLatStatsTestReject = boxplot(mlLatTestReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Left Mastoid Process Lateral HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample rejection");
print(h6,"mlLatTestReject.png");
% Correct classification statistics for cross-validation sample
h7 = figure;
mlLatStatsCrossClass = boxplot(mlLatCrossClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Left Mastoid Process Lateral HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample classification");
print(h7,"mlLatCrossClass.png");
% Classification rejection statistics for cross-validation sample
h8 = figure;
mlLatStatsCrossReject = boxplot(mlLatCrossReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Left Mastoid Process Lateral HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample rejection");
print(h8,"mlLatCrossReject.png");
clear classification;
%
%
% Right Mastoid Process Inferior HMI
load mrInf_classification.mat
for i=1:iterations
	mrInfTestClass(i,:) = classification(i).test_class(1,:);
	mrInfTestReject(i,:) = classification(i).test_class(2,:);
	mrInfCrossClass(i,:) = classification(i).cross_class(1,:);
	mrInfCrossReject(i,:) = classification(i).cross_class(2,:);
endfor
% Correct classification statistics for testing sample
h9 = figure;
mrInfStatsTestClass = boxplot(mrInfTestClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Right Mastoid Process Inferior HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample classification");
print(h9,"mrInfTestClass.png");
% Classification rejection statistics for testing sample
h10 = figure;
mrInfStatsTestReject = boxplot(mrInfTestReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Right Mastoid Process Inferior HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample rejection");
print(h10,"mrInfTestReject.png");
% Correct classification statistics for cross-validation sample
h11 = figure;
mrInfStatsCrossClass = boxplot(mrInfCrossClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Right Mastoid Process Inferior HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample classification");
print(h11,"mrInfCrossClass.png");
% Classification rejection statistics for cross-validation sample
h12 = figure;
mrInfStatsCrossReject = boxplot(mrInfCrossReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Right Mastoid Process Inferior HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample rejection");
print(h12,"mrInfCrossReject.png");
clear classification;
%
%
% Right Mastoid Process Lateral HMI
load mrLat_classification.mat
for i=1:iterations
	mrLatTestClass(i,:) = classification(i).test_class(1,:);
	mrLatTestReject(i,:) = classification(i).test_class(2,:);
	mrLatCrossClass(i,:) = classification(i).cross_class(1,:);
	mrLatCrossReject(i,:) = classification(i).cross_class(2,:);
endfor
% Correct classification statistics for testing sample
h13 = figure;
mrLatStatsTestClass = boxplot(mrLatTestClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Right Mastoid Process Lateral HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample classification");
print(h13,"mrLatTestClass.png");
% Classification rejection statistics for testing sample
h14 = figure;
mrLatStatsTestReject = boxplot(mrLatTestReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Right Mastoid Process Lateral HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("testing sample rejection");
print(h14,"mrLatTestReject.png");
% Correct classification statistics for cross-validation sample
h15 = figure;
mrLatStatsCrossClass = boxplot(mrLatCrossClass,maxwhisker=0);
axis([0,16,0.6,1.01]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0.6,0.7,0.8,0.9,1], "yticklabel", {"60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Right Mastoid Process Lateral HMI correct classification statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample classification");
print(h15,"mrLatCrossClass.png");
% Classification rejection statistics for cross-validation sample
h16 = figure;
mrLatStatsCrossReject = boxplot(mrLatCrossReject,maxwhisker=0);
axis([0,16,0,1]);
set(gca (), "xtick", [1:15], "xticklabel", {"0.0","±0.1","±0.2","±0.3","±0.4","±0.5","±0.6","±0.7",...
																						"±0.8","±0.9","±1.0","±1.1","±1.2","±1.3","±1.4"});
set(gca (), "ytick", [0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1], "yticklabel",...
											{"0%","10%","20%","30%","40%","50%","60%","70%","80%","90%","100%"});
set (gca, "yminorgrid", "on");
plot_title = ["Right Mastoid Process Lateral HMI classification rejection statistics at ",...
							num2str(iterations)," iterations"];
title(plot_title);
xlabel("RBF decision threshold range");
ylabel("cross-validation sample rejection");
print(h16,"mrLatCrossReject.png");
clear classification;