function center=getColorClusters(image, k, plot)

    imlab=rgb2lab(image);
    imlab=im2single(imlab); 
    [topclusters,centers]=imsegkmeans(imlab,k,'NumAttempts',3);
    if (plot)
        imshow(topclusters,[])
    end
    %remove background info by comparing with top left and bottom right corner of image 
    [height,width]=size(imlab);
    hfrac=round(height/8); 
    wfrac=round(width/8);
    background=[imlab(1:hfrac,1:wfrac,:) imlab(height-hfrac+1:end,width-wfrac+1:end,:)];
    avgbackground=mean(mean(background,1),2);
    avgbackground=avgbackground(:)'; 
    for i=1:2
        dist(i)=norm(avgbackground-centers(i,:));
    end
    ind=1;
    if dist(1)<dist(2)
        ind=2;
    end
    %keep the centroids with greater distance from background
    center=centers(ind,:,:);
    
end