% Combining feature vector of all feature extraction methods for the
% training model

addpath('Functions');

%% Load Dataset image 

DataSet=imageDatastore("Dataset",'IncludeSubfolders',true,'LabelSource','foldernames');

% Initialization of length of features : 
numImages = numel(DataSet.Files);
imageSize = [256 256];
SIFTFeatures=zeros(numImages,200);
GaborFeatures=zeros(numImages,384);
ColorFeatures=zeros(numImages,3);
LabFeatures=zeros(numImages,200);
GaborFeatures48=zeros(numImages,48);

% Gabor Filter Bank Creation
gaborArray=gaborFilterBank(4,6,39,39);

%% Creation of Bag of Features for SIFT and Spatial augmented color features

% Splitting the DataSet to get the extract Bag of Features 
[trainingSetforSIFT, validationSet]=splitEachLabel(DataSet,0.5,'randomize');

% Bag of Features SIFT
getSIFT=@getSiftFeatures; 
bagSIFT=bagOfFeatures(trainingSetforSIFT,'CustomExtractor',getSIFT,'VocabularySize',200);

% Bag of Features Color
getColorLab=@ColorExtractor; 
bagLab=bagOfFeatures(trainingSetforSIFT,'CustomExtractor',getColorLab,'VocabularySize',200);

%% Combine features 

%The below for loop is used to extract the features for each data set
%image. 

for i = 1:numImages
    img = readimage(DataSet, i);
    imgdown = imresize(img,imageSize);
    imgdown = rgb2gray(imgdown);
    SIFTFeatures(i,:)=encode(bagSIFT,img);
    GaborFeatures(i,:)=gaborFeatures(imgdown,gaborArray);
    ColorFeatures(i,:)=getColorClusters(img,2,0);
    LabFeatures(i,:)=encode(bagLab,img);
    GaborFeatures48(i,:)=gaborFeatures2(imgdown,gaborArray);
end