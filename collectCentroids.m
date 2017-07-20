function [ slices ] = collectCentroids( folder_path) 
%% Import images sequentially and Converts Centroids into Data Points
% slices: a cell array of arrays of x,y points
%    slices(1) is an array of all x,y points slice 1...etc
slices = {};
    for i=1:96
        if i<10
            filename=sprintf(strcat(folder_path,'FOV 1 XZ PLANE000%d.tif'),i);
        else
            filename=sprintf(strcat(folder_path,'FOV 1 XZ PLANE00%d.tif'),i); 
        end
    
        I=imread(filename);
        %I=imcomplement(I); %centroid only works for white shapes
        I=im2double(I);
        I=rgb2gray(I);
        I = medfilt2(I);
        
        if i==47
           disp('ok') 
        end

        I=I(:,:,1);
        %labels each invdividual white dot for tracking
        labelarray=bwlabel(I);

        %temporally stores the centroids of the white dots
        s=regionprops(labelarray,'Centroid');

        p = [];
        for j=1:length(s)
            point = s(j).Centroid;
            point = [point i];
            p = [p; point];
        end
        slices{i} = p;
    end
end

