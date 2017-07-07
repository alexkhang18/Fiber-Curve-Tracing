%%% Fiber reconstruction and 3D mapping code
%Place this script into a folder containing a z-stack of fibers
%Written by Alex Khang
%Last Updated May 19th 2017

clc
clear all
close all


for i=1:12
    if i<10
filename=sprintf('Slide0%d.png',i);
    else
filename=sprintf('Slide%d.png',i); 
    end
    
I=imread(filename);
I=imcomplement(I); %centroid only works for white shapes
I=im2double(I);
I=I(:,:,1);

s=regionprops(I,'centroid');
x1(i)=s.Centroid(1);
y1(i)=s.Centroid(2);
% imshow(I)
figure
imshow(I)
hold on
plot(s.Centroid(1), s.Centroid(2), 'b*')
hold off
img{i}=I;
i=i+1;
end

z=[1:i-1];
scatter3(x1,y1,z); hold on;
% [azimuth,elevation,r]=cart2sph(x1,y1,z);
% plot3(azimuth,elevation,r)
[gof,coeff]=createFit(x1,y1,z);
coeff=coeffvalues(gof);
vectordirection=[x1(end),y1(end),x1(end)*coeff(2)+y1(end)*coeff(3)+coeff(1)]-[x1(1),y1(1),x1(1)*coeff(2)+y1(1)*coeff(3)+coeff(1)]; %computed from best fit
unitvectordirection=vectordirection/norm(vectordirection);

