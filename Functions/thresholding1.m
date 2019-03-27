function [BW,maskedImage] = thresholding1(RGB)
% Threshold the input image in RGB color space using superpixel algorithm
% (SLIC) and Active Contour.
% Return the black and white binary mask for segmentation and the original
% image masked using the mask

% Image blur 
img = imgaussfilt(RGB, 1);
img = rgb2hsv(img);

% Superpixels
[L,N] = superpixels(img,250);
superpixel_Image = zeros(size(img),'like',img);
idx = label2idx(L);
numRows = size(img,1);
numCols = size(img,2);
for labelVal = 1:N
    redIdx = idx{labelVal};
    greenIdx = idx{labelVal}+numRows*numCols;
    blueIdx = idx{labelVal}+2*numRows*numCols;
    superpixel_Image(redIdx) = mean(img(redIdx));
    superpixel_Image(greenIdx) = mean(img(greenIdx));
    superpixel_Image(blueIdx) = mean(img(blueIdx));
end

sat = superpixel_Image(:,:,2);
figure,imshow(sat);

% I = rgb2gray(superpixel_Image);

% Image blur 
Iblur = imgaussfilt(sat, 1);
% Iblur = imgaussfilt(I, 1);

% active contour
mask = zeros(size(Iblur));
mask(25:end-25,25:end-25) = 1;
bw = activecontour(Iblur,mask,1000);

se = strel('disk',3);
bw = imclose(bw,se);

thre = imfill(bw,'holes');

BW = imclearborder(thre);

maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end