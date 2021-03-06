addpath('Functions');
addpath('Matlab data');

%% Ask for loading or not the existing features.

fprintf('Enter yes in single quotes to use the saved features.\n');
fprintf('Enter no in single quotes to extract all features.\n');
Load = input('Do you want to load the existing features?\n');

if strcmp(Load,'no') ==1
    % Extract all Features
    run('combinedFeatures')
else
    % Load all Features
    load('Features_color.mat');
    load('Features_Gabor_384.mat');
    load('Features_Lab.mat');
    load('Features_SIFT.mat');
    load('Features_Gabor_48.mat')
end


%% Labeling feature vectors to the corresponding image

DataSet=imageDatastore("Dataset",'IncludeSubfolders',true,'LabelSource','foldernames');

fprintf('Loading and labeling all features...\n')

DataSetLabels = DataSet.Labels;
numcats=grp2idx(DataSetLabels);

% Single Features
LabeledFeatures_Gabor=[numcats GaborFeatures];
LabeledFeatures_Sift=[numcats SIFTFeatures];
LabeledFeatures_Color=[numcats ColorFeatures];
LabeledFeatures_Lab=[numcats LabFeatures];
LabeledFeatures_Gabor48=[numcats GaborFeatures48];

% Combined two Features

LabeledFeatures_GC=[numcats GaborFeatures ColorFeatures];
LabeledFeatures_G48C=[numcats GaborFeatures48 ColorFeatures];
LabeledFeatures_GL=[numcats GaborFeatures LabFeatures];
LabeledFeatures_G48L=[numcats GaborFeatures48 LabFeatures];
LabeledFeatures_SC=[numcats SIFTFeatures ColorFeatures];
LabeledFeatures_SG=[numcats SIFTFeatures GaborFeatures];
LabeledFeatures_SL=[numcats SIFTFeatures LabFeatures];

% Combined three Features

LabeledFeatures_GCS=[numcats GaborFeatures ColorFeatures SIFTFeatures];
LabeledFeatures_GLS=[numcats GaborFeatures LabFeatures SIFTFeatures];
LabeledFeatures_G48CS=[numcats GaborFeatures48 ColorFeatures SIFTFeatures];

fprintf('All features loaded, training the classifier.\n')

[~, validationAccuracyS] = trainClassifier_S(LabeledFeatures_Sift);
[~, validationAccuracyG48] = trainClassifier_G48(LabeledFeatures_Gabor48);
[~, validationAccuracyC] = trainClassifier_C(LabeledFeatures_Color);
[~, validationAccuracyG48C] = trainClassifier_G48C(LabeledFeatures_G48C);
[~, validationAccuracyG] = trainClassifier_G(LabeledFeatures_Gabor);
[~, validationAccuracySC] = trainClassifier_SC(LabeledFeatures_SC);
[~, validationAccuracySG] = trainClassifier_SG(LabeledFeatures_SG);
[~, validationAccuracyL] = trainClassifier_Lab(LabeledFeatures_Lab);
[~, validationAccuracySL] = trainClassifier_SL(LabeledFeatures_SL);
[~, validationAccuracyG48L] = trainClassifier_G48L(LabeledFeatures_G48L);
[~, validationAccuracyGL] = trainClassifier_GL(LabeledFeatures_GL);
[~, validationAccuracySGL] = trainClassifier_SGL(LabeledFeatures_GLS);
[~, validationAccuracySGC] = trainClassifier_SGC(LabeledFeatures_GCS);
[~, validationAccuracyGC] = trainClassifier_GC(LabeledFeatures_GC);

Accuracy = [validationAccuracyS;...
    validationAccuracyG48;...
    validationAccuracyC;...
    validationAccuracyG48C;...
    validationAccuracySC;...
    validationAccuracyG;...
    validationAccuracySG;...
    validationAccuracyL;...
    validationAccuracySL;
    validationAccuracyGL;...
    validationAccuracyG48L;...
    validationAccuracySGL;...
    validationAccuracySGC;...
    validationAccuracyGC];

Features = {'SIFT';...
    'Gabor48';...
    'Color';...
    'Gabor48 + Color';...
    'SIFT + Color';...
    'Gabor';...
    'SIFT + Gabor';...
    'Spatial Color';...
    'SIFT + Spatial Color';...
    'Gabor + Spatial Color';...
    'Gabor48 + Spatial Color';...
    'Gabor + SIFT + Spatial Color';...
    'SIFT + Gabor + Color';...
    'Gabor + Color'};

Methods=['SVM';...
    'SVM';...
    'KNN';...
    'KNN';
    'SVM';...
    'SVM';...
    'SVM';...
    'SVM';...
    'SVM';...
    'SVM';...
    'SVM';...
    'SVM';...
    'SVM';...
    'SVM'];

T = table(Features,Methods,round(Accuracy,2))