% Copyright (C) 2020 Andreas Bertsatos <andreas.bertsatos@gmail.com>
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

% A function for predicting sex from the morphometric features available in the
% respective .mat file produced by the skullanalyzer. The present function relies
% on the external "classifiers.mat" and "HMItoHOG.py" files, which must be present
% in the same working directory. The "classifiers.mat" contains the trained model
% coefficients for each morphometric feature. The "HMItoHOG.py" script requires
% python 3.6 and skimage >=1.5 installed.
%
% You may use the existing "ABH073-Cranium.mat" file to test the present function as:
%
% >> estimate_sex("ABH073-Cranium")
%
% If you wish to get the decision function score from the combined classifiers, type:
%
% >> df = estimate_sex("ABH073-Cranium")
%
% If you call the function without an input argument, a dialog box will request a
% corresponding filename for the .mat file. Make sure you omit the extension as in the
% examples given above.

function varargout = estimate_sex(varargin)
	% check if "HMItoHOG.py" python script is present in working directory
	if(exist("HMItoHOG.py")!=2)
		error ("The required python script ""HMItoHOGs.py"" was not found in the working directory\n");
	endif
	% check if "classifiers.mat" file is present in working directory
	if(exist("classifiers.mat")!=2)
		error ("The required data file ""classifiers.mat"" was not found in the working directory\n");
	else
		load classifiers.mat
	endif
	% check for input argument or ask user for filename
  if(nargin == 1)
    filename = varargin{1};
  else
    filename = inputdlg("Enter Mesh name");
  endif
	extension = [".mat"];
  filename = char(strcat(filename, extension));
	% check if user defined .mat file is present in working directory
	if(exist(filename)!=2)
		err_message = ["The " filename " file was not found in the working directory\n"];
		error(err_message);
	endif
	
	% read user's defined sample related mat file
	load(filename, "HMI", "EFD");
	% initialize a counter for available morphometric features of the given sample
	features = 0;
	% check if OccipitalProtuberance field exists and calculate the respective DFs
	if(isfield(HMI, "OccipitalProtuberance"))
		csvwrite("tempHMI.csv", HMI.OccipitalProtuberance(:,:));
		% run python script for HOG calculation
		unix("python3 HMItoHOG.py");
		HOGs = csvread("tempHOG.csv")';
		% delete temp files from HMI_test folder
		unix("rm tempHMI.csv tempHOG.csv");
		% here goes the code for applying the op classifier from sample split #1
		df_s1(1,1) = evaluate_model(HOGs, classifiers.op1);
		% here goes the code for applying the op classifier from sample split #2
		df_s2(1,1) = evaluate_model(HOGs, classifiers.op2);
		features += 1;
	else
		df_s1(1,1) = 0;
		df_s2(1,1) = 0;
	endif
	% check if SupraorbitalRidge field exists and calculate the respective DFs
	if(isfield(HMI, "SupraorbitalRidge"))
		csvwrite("tempHMI.csv", HMI.SupraorbitalRidge(:,:));
		% run python script for HOG calculation
		unix("python3 HMItoHOG.py");
		HOGs = csvread("tempHOG.csv")';
		% delete temp files from HMI_test folder
		unix("rm tempHMI.csv tempHOG.csv");
		% here goes the code for applying the op classifier from sample split #1
		df_s1(1,2) = evaluate_model(HOGs, classifiers.sr1);
		% here goes the code for applying the op classifier from sample split #2
		df_s2(1,2) = evaluate_model(HOGs, classifiers.sr2);
		features += 1;
	else
		df_s1(1,2) = 0;
		df_s2(1,2) = 0;
	endif
	% check if LeftMastoidLateral field exists and calculate the respective DFs
	if(isfield(HMI, "LeftMastoidLateral"))
		csvwrite("tempHMI.csv", HMI.LeftMastoidLateral(:,:));
		% run python script for HOG calculation
		unix("python3 HMItoHOG.py");
		HOGs = csvread("tempHOG.csv")';
		% delete temp files from HMI_test folder
		unix("rm tempHMI.csv tempHOG.csv");
		% here goes the code for applying the op classifier from sample split #1
		df_s1(1,3) = evaluate_model(HOGs, classifiers.mlLat1);
		% here goes the code for applying the op classifier from sample split #2
		df_s2(1,3) = evaluate_model(HOGs, classifiers.mlLat2);
		features += 1;
	else
		df_s1(1,3) = 0;
		df_s2(1,3) = 0;
	endif
	% check if LeftMastoidInferior field exists and calculate the respective DFs
	if(isfield(HMI, "LeftMastoidInferior"))
		csvwrite("tempHMI.csv", HMI.LeftMastoidInferior(:,:));
		% run python script for HOG calculation
		unix("python3 HMItoHOG.py");
		HOGs = csvread("tempHOG.csv")';
		% delete temp files from HMI_test folder
		unix("rm tempHMI.csv tempHOG.csv");
		% here goes the code for applying the op classifier from sample split #1
		df_s1(1,4) = evaluate_model(HOGs, classifiers.mlInf1);
		% here goes the code for applying the op classifier from sample split #2
		df_s2(1,4) = evaluate_model(HOGs, classifiers.mlInf2);
		features += 1;
	else
		df_s1(1,4) = 0;
		df_s2(1,4) = 0;
	endif
	% check if RightMastoidLateral field exists and calculate the respective DFs
	if(isfield(HMI, "RightMastoidLateral"))
		csvwrite("tempHMI.csv", HMI.RightMastoidLateral(:,:));
		% run python script for HOG calculation
		unix("python3 HMItoHOG.py");
		HOGs = csvread("tempHOG.csv")';
		% delete temp files from HMI_test folder
		unix("rm tempHMI.csv tempHOG.csv");
		% here goes the code for applying the op classifier from sample split #1
		df_s1(1,5) = evaluate_model(HOGs, classifiers.mrLat1);
		% here goes the code for applying the op classifier from sample split #2
		df_s2(1,5) = evaluate_model(HOGs, classifiers.mrLat2);
		features += 1;
	else
		df_s1(1,5) = 0;
		df_s2(1,5) = 0;
	endif
	% check if RightMastoidInferior field exists and calculate the respective DFs
	if(isfield(HMI, "RightMastoidInferior"))
		csvwrite("tempHMI.csv", HMI.RightMastoidInferior(:,:));
		% run python script for HOG calculation
		unix("python3 HMItoHOG.py");
		HOGs = csvread("tempHOG.csv")';
		% delete temp files from HMI_test folder
		unix("rm tempHMI.csv tempHOG.csv");
		% here goes the code for applying the op classifier from sample split #1
		df_s1(1,6) = evaluate_model(HOGs, classifiers.mrInf1);
		% here goes the code for applying the op classifier from sample split #2
		df_s2(1,6) = evaluate_model(HOGs, classifiers.mrInf2);
		features += 1;
	else
		df_s1(1,6) = 0;
		df_s2(1,6) = 0;
	endif
	% check if NasionBregma field exists and retrieve the 7 most sex discriminant EFD coefficients
	if(isfield(EFD, "NasionBregma"))
		if(length(EFD.NasionBregma(:,1))>1)
			nbWeights = [EFD.NasionBregma([1:4,7],1)', EFD.NasionBregma([2:3],3)'];
			% here goes the code for applying the nb classifier from sample split #1
			df_s1(1,7) = evaluate_model(nbWeights, classifiers.nb1);
			% here goes the code for applying the nb classifier from sample split #2
			df_s2(1,7) = evaluate_model(nbWeights, classifiers.nb2);
			features += 1;
		else
			df_s1(1,7) = 0;
			df_s2(1,7) = 0;
		endif
	endif
	
	% define weights for each sample split
	weight_s1 = [0.8,1.1,1.0,0.6,1.0,0.6,0.9];
	weight_s2 = [0.8,1.0,1.0,0.6,1.0,0.6,0.8];
	
	% combine all decision functions' output in a single outcome by applying appropriate weights
	df1 = sum(df_s1.*weight_s1);
	df2 = sum(df_s2.*weight_s2);
	df=(df1+df2)/2;
	
	% check the outcome
	if(df<0)
		outcome = "male";
	else
		outcome = "female";
	endif
	
	% check the posterior probability of the outcome based on the value of the combined DFs
	probability = calculate_postprob(df);
	
	% check number of output arguments and provide predicted output accordingly
	if(nargout==0)
		printf("The processed cranium contained %i morphometric features and it is estimated\n", features);
		printf("to belong to a %s individual with a posterior probability of %f.\n", outcome, probability);
  else
		varargout{1} = df;
	endif
endfunction

% A function for evaluating the decision function of a given classifier.
% The function can evaluate both RBF kernel classifier and LDA classifier based
% on the available parameters of the provided classifier in the input argument.
function df = evaluate_model(data, classifier)
	% determine the type of classifier by the number of fields
	if(length(fieldnames(classifier))==4)
		% apply RBF
		df = 0;
		for i=1:length(classifier.dual_coef)
			d(i) = norm(classifier.support_vector(i,:) - data);
			t(i) = exp(-classifier.gamma_param * (d(i) ^ 2));
			df += classifier.dual_coef(i) * t(i);
		endfor
		df += classifier.rho_intercept;		
	elseif(length(fieldnames(classifier))==1)
		% apply LDA
		df = sum(classifier.weights([2:end],1)' .* data) + classifier.weights(1,1);		
	endif
endfunction

% A function for calculating the posterior probability based on the combined decision function 
% and the available features it was based upon.
function postprob = calculate_postprob(df)
	if(df>-0.4 && df<0.4)
		postprob = 0.92;
	elseif(df>-0.8 && df<0.8)
		postprob = 0.95;
	elseif(df>-1.2 && df<1.2)
		postprob = 0.97;
	elseif(df>-1.6 && df<1.6)
		postprob = 0.98;
	elseif(df>-2.0 && df<2.0)
		postprob = 0.99;
	else
		postprob = 1.00;
	endif
endfunction
