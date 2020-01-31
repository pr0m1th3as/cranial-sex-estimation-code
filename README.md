# cranial-sex-estimation-code
Data analysis implementation for evaluating a novel sex estimation method based on skullanalyzer data

To reimplement the analysis grab the morphometric feature dataset from https://zenodo.org/record/3632180 and save the relevant files into the corresponding folders. Keep the current directory structure and from within GNU Octave command window enter the ./analysis_run folder and type 'run'. The results are saved in compressed format in the subfolder ./analysis_run/results

To estimate the sex of a cranial sample, which has been pre-processed with the skullanalyzer program, utilize the function 'estimate_sex.m' in the ./estimate_sex folder.
