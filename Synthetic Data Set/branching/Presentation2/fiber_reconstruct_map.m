%%% Fiber reconstruction and 3D mapping code
%Place this script into a folder containing a z-stack of fibers
%Written by Alex Khang
%Last Updated May 19th 2017

clc
clear all
close all


for i=1:15
    if i<10
filename=sprintf('Slide0%d.tiff',i);
    else
filename=sprintf('Slide%d.tiff',i); 
    end
    
I=imread(filename);
I=imcomplement(I); %centroid only works for white shapes
I=im2double(I);
I=I(:,:,1);
labelarray=bwlabel(I);

s=regionprops(labelarray,'Centroid');

s_array{i}=struct2array(s);




%     x1(k)=s(1);
%     y1(k)=s(2);
% 
%     x2(k)=s(3);
%     y2(k)=s(4);

% if length(s)>1
% point1=struct2array(s(1));
% point2=struct2array(s(2));
% else
% point1=struct2array(s(1));
% point2=struct2array(s(1));
% end



% figure
% imshow(I)
% hold on
% plot(x1(i),y1(i),'b*',x2(i),y2(i),'b*')

% img{i}=I;

i=i+1;

end

table=cell2table(s_array);

k=1;
for k=1:length(s_array)
    temp_s=(s_array{1,k});
    
    j=1;
    z=1;
    while z<=(length(temp_s)/2) && j<length(temp_s) 
        x1(z)=temp_s(j);
        y1(z)=temp_s(j+1);
        z=z+1;
        j=j+2;
    end
    points{k}=[x1;y1]';
    clear x1 y1
    figure (1)
    z=[1:i-1];
    scatter3(points{k}(:,1),points{k}(:,2),z(k)*ones(1,size(points{k},1))); hold on;
    k=k+1;
end
    

% 
% 



% %Unit Vector Determination

% % [azimuth,elevation,r]=cart2sph(x1,y1,z);
% % plot3(azimuth,elevation,r)
% [gof,coeff]=createFit(x1,y1,z);
% coeff=coeffvalues(gof);
% vectordirection=[x1(end),y1(end),x1(end)*coeff(2)+y1(end)*coeff(3)+coeff(1)]-[x1(1),y1(1),x1(1)*coeff(2)+y1(1)*coeff(3)+coeff(1)]; %computed from best fit
% unitvectordirection=vectordirection/norm(vectordirection);

