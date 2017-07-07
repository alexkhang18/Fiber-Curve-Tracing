%%% Fiber reconstruction and 3D mapping code
%Place this script into a folder containing a z-stack of fibers
%Written by Alex Khang
%Last Updated May 19th 2017

clc
clear all
close all


for i=1:16
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

if length(s)>1
point1=struct2array(s(1));
point2=struct2array(s(2));
else
point1=struct2array(s(1));
point2=struct2array(s(1));
end


x1(i)=point1(1);
y1(i)=point1(2);

x2(i)=point2(1);
y2(i)=point2(2);

figure
imshow(I)
hold on
plot(x1(i),y1(i),'b*',x2(i),y2(i),'b*')

% img{i}=I;

i=i+1;

end

close all

figure(2)
z=[1:i-1];
scatter3(x1,y1,z); hold on;
scatter3(x2,y2,z)



% %Unit Vector Determination

% % [azimuth,elevation,r]=cart2sph(x1,y1,z);
% % plot3(azimuth,elevation,r)
% [gof,coeff]=createFit(x1,y1,z);
% coeff=coeffvalues(gof);
% vectordirection=[x1(end),y1(end),x1(end)*coeff(2)+y1(end)*coeff(3)+coeff(1)]-[x1(1),y1(1),x1(1)*coeff(2)+y1(1)*coeff(3)+coeff(1)]; %computed from best fit
% unitvectordirection=vectordirection/norm(vectordirection);

