function [ slices ] = collectCentroids( folder_path)
    slices = {};
%% Import images sequentially and Converts Centroids into Data Points
    for i=1:6
        if i<10
            filename=sprintf(strcat(folder_path,'Slide%d.tiff'),i);
        else
            filename=sprintf(strcat(folder_path,'Slide%d.tiff'),i); 
        end
    
        I=imread(filename);
        I=imcomplement(I); %centroid only works for white shapes
        I=im2double(I);
        I=I(:,:,1);

        %labels each invdividual white dot for tracking
        labelarray=bwlabel(I);

        %temporally stores the centroids of the white dots
        s=regionprops(labelarray,'Centroid');

        %stores centroids into an array (x1 y1 x2 y2 ...)
        slices{i}=s;
    end
end

