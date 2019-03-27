% The main function for the produce recognition in an input image.

clc; % Clear command window.
addpath('Functions');
addpath('Matlab data');
fprintf('Running main.m...\n'); 
workspace;
imtool close all;  

%% Check that user has the Image Processing Toolbox installed.
hasIPT = license('test', 'image_toolbox');
if ~hasIPT
	% User does not have the toolbox installed.
	message = sprintf('Sorry, but you do not seem to have the Image Processing Toolbox.\nDo you want to try to continue anyway?');
	reply = questdlg(message, 'Toolbox missing', 'Yes', 'No', 'Yes');
	if strcmpi(reply, 'No')
		% User said No, so exit.
		return;
	end
end

%% Load the provided matlab data 

% Load Trained Classifier
load('TrainedClassifier_Gabor+Color.mat')
fprintf('Classifier loaded.\n');

%% Dataset image are loaded

root = "Dataset";
trainingSet=imageDatastore(root,'IncludeSubfolders',true,'LabelSource','foldernames');

%% Select an image to test the system 

fprintf('Please select an image\n');
[TestImageFileName, TestImagefolder] = uigetfile({'*.*'},'Image Selector');
if isequal(TestImageFileName,0)
    disp('User selected Cancel');
else
    fullFileName = fullfile(TestImagefolder, TestImageFileName);
    disp(['User selected image', fullFileName]);
end

%%

% [bw,maskedImage] = thresholding1(imread(fullFileName));
[bw,maskedImage] = thresholding2(imread(fullFileName));
[seg,stats,L,N] = segmentation(imread(fullFileName),bw);

%%
DataSetLabels = trainingSet.Labels;
[numcats,name]=grp2idx(DataSetLabels);

gaborArray=gaborFilterBank(4,6,39,39);
features=zeros(1,387);
imageSize = [256 256];
centroids = cat(1, stats.Centroid);
for k = 1 : N
    imgdown = imresize(seg{k},imageSize);
    imgdown = rgb2gray(imgdown);
    features(1:384)=gaborFeatures(imgdown,gaborArray);
    features(385:387)=getColorClusters(seg{k},2,0);
    prediction = trainedClassifier.predictFcn(features);
    label = name(prediction);
    H= text(centroids(k,1), centroids(k,2),["Prediction:",label{1}]);
    set(H,'Color',[0 1 1], 'FontSize', 15)
end

hold off

fprintf('Finished.\n');


