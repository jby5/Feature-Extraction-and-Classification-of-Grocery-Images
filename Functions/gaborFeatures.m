function features = gaborFeatures(img,gaborArray)

% JY: edited to take only image input, call gaborFilterBank within this
% function, and to take 256x256 images 
% GABORFEATURES extracts the Gabor features of an input image.
% It creates a column vector, consisting of the Gabor features of the input
% image. The feature vectors are normalized to zero mean and unit variance.
%
%
% Inputs:
%       img         :	Matrix of the input image 
%       gaborArray	:	Gabor filters bank created by the function gaborFilterBank
%       d1          :	The factor of downsampling along rows.
%       d2          :	The factor of downsampling along columns.
%               
% Output:
%       featureVector	:   A column vector with length (m*n*u*v)/(d1*d2). 
%                           This vector is the Gabor feature vector of an 
%                           m by n image. u is the number of scales and
%                           v is the number of orientations in 'gaborArray'.
%
%
% Sample use:
% 
% img = imread('cameraman.tif');
% gaborArray = gaborFilterBank(5,8,39,39);  % Generates the Gabor filter bank
% featureVector = gaborFeatures(img,gaborArray,4,4);   % Extracts Gabor feature vector, 'featureVector', from the image, 'img'.


if size(img,3) == 3     % Check if the input image is grayscale
    %warning('The input RGB image is converted to grayscale!')
    img = rgb2gray(img);
end

img = double(img);


%% Filter the image using the Gabor filter bank

% Filter input image by each Gabor filter
rows=64*ones(1,4);
blocks=mat2cell(img,rows, rows);
[u,v] = size(gaborArray);
gaborResult = cell(u,v);
features=[];
index=1;
for blockRow=1:4
    for blockCol=1:4
        for i = 1:u
            for j = 1:v
                gaborResult{i,j} = imfilter(blocks{blockRow,blockCol}, gaborArray{i,j});
            end
        end
        d1=4;
        d2=4;
        
        %% Create feature vector
        index=1;
        % Extract feature vector from input image
        for i = 1:u
            for j = 1:v
                
                gaborAbs = abs(gaborResult{i,j});
                gaborAbs = gaborAbs(:);
                gaborAveraged = mean(gaborAbs);
                blockfeatures(index) = gaborAveraged;
                index=index+1;
            end
        end
        features=[features blockfeatures];
    end
end
