function [BW,maskedImage] = thresholding2(RGB)
% Threshold the input image in RGB color space using k-means clustering and
% morphological transformations.
% Return the black and white binary mask for segmentation and the original
% image masked using the mask

X = imgaussfilt(RGB);

% img=X;
% % Superpixels
% [L,N] = superpixels(img,2000);
% superpixel_Image = zeros(size(img),'like',img);
% idx = label2idx(L);
% numRows = size(img,1);
% numCols = size(img,2);
% for labelVal = 1:N
%     redIdx = idx{labelVal};
%     greenIdx = idx{labelVal}+numRows*numCols;
%     blueIdx = idx{labelVal}+2*numRows*numCols;
%     superpixel_Image(redIdx) = mean(img(redIdx));
%     superpixel_Image(greenIdx) = mean(img(greenIdx));
%     superpixel_Image(blueIdx) = mean(img(blueIdx));
% end
% X=superpixel_Image;

% Auto clustering
sz = size(X);
im = single(reshape(X,sz(1)*sz(2),[]));
im = im - mean(im);
im = im ./ std(im);
s = rng;
rng('default');
L = kmeans(im,2,'Replicates',2);
rng(s);
BW = L == 2;
BW = reshape(BW,[sz(1) sz(2)]);

se = strel('disk',10);
BW = imclose(BW,se);

% Fill holes
BW = imfill(BW, 'holes');

se = strel('disk',3);
BW = imopen(BW,se);

% Clear borders
BW = imclearborder(BW);

% Create masked image.
maskedImage = RGB;
maskedImage(repmat(~BW,[1 1 3])) = 0;
end

