function [seg,stats,L,N] = segmentation(img,bw_threshold)
% Segment the input image, img into individual cropped image depending on
% the binary mask, bw_threshold

% Inputs:
%       img             :	Matrix of the input image 
%       bw_threshold	:	binary mask from threshloding
%               
% Output:
%       seg         	:   Individual cropped image of produce
%       stats           :   Boundaries regions proprieties
%       L               :   Label matrix for each region the binary image
%       N               :   Number of Region

% Find the N individual boundaries in the binary mask with label L 
[~,L,N,~] = bwboundaries(bw_threshold);

% Create an empty cell of 
seg = cell(N,1);

stats = regionprops(L,'all');
figure, imshow(img);
hold on;
for idx = 1 : N
    h = rectangle('Position',stats(idx).BoundingBox,'LineWidth',2);
    set(h,'EdgeColor',[.75 0 0]);
end
title(['There are ', num2str(N), ' objects in the image!']);

for k = 1 : N
    segmented = imcrop(img,stats(k).BoundingBox);
    seg{k} = segmented;
end
end