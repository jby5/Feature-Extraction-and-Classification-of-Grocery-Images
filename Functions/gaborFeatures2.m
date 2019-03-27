function featuresAll = gaborFeatures2(img,gaborArray)

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
% 
% 
% 
%   Details can be found in:
%   
%   M. Haghighat, S. Zonouz, M. Abdel-Mottaleb, "CloudID: Trustworthy 
%   cloud-based and cross-enterprise biometric identification," 
%   Expert Systems with Applications, vol. 42, no. 21, pp. 7905-7916, 2015.
% 
% 
% 
% (C)	Mohammad Haghighat, University of Miami
%       haghighat@ieee.org
%       PLEASE CITE THE ABOVE PAPER IF YOU USE THIS CODE.


% if (nargin ~= 4)        % Check correct number of arguments
%     error('Please use the correct number of input arguments!')
% end

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
featuresAll=zeros(4,4,u*v);
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
        for i = 1:u %4
            for j = 1:v %6
                
                gaborAbs = abs(gaborResult{i,j});
                %gaborAbs = downsample(gaborAbs,d1);
                %gaborAbs = downsample(gaborAbs.',d2);
                gaborAbs = gaborAbs(:);
                
                % Normalized to zero mean and unit variance. (if not applicable, please comment this line)
                %gaborAbs = (gaborAbs-mean(gaborAbs))/std(gaborAbs,1);
                gaborAveraged=mean(gaborAbs);
                blockfeatures(index) = gaborAveraged;
                index=index+1;
            end
        end
        featuresAll(blockRow,blockCol,:)=blockfeatures;
    end
end
featuresAvg=mean(mean(featuresAll,1),2);
featuresAvg=featuresAvg(:)';
featuresSTD=std(std(featuresAll));
featuresSTD=featuresSTD(:)';
featuresAll=[featuresAvg featuresSTD];
%features=features';
%metrics=var(features,[],2);
