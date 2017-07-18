%%% Fiber reconstruction and 3D mapping code
%Place this script into a folder containing a z-stack of fibers
%Written by Alex Khang
%Last Updated May 19th 2017

clc
clear all
close all

tic 
fibers = Fiber.empty;

growing_fibers = Fiber.empty;
grown_fibers = Fiber.empty;

new_fiber_distance_threshold = 100; 

slices = collectCentroids('Synthetic Data Set/branching/Presentation2/');

% Create initial fibers
slice = slices{1};
for i=1:length(slice)
   fiber = Fiber;
   point = slice(i,:);
   fiber.addPoint(point);
   fibers = [fibers fiber];
end

% extend the fibers
slice = slices{2};
for i=1:length(fibers)
    fiber = fibers(i);
    point=fiber.points(1,:);
    distances = sqrt(sum(bsxfun(@minus, slice, point).^2,2));
    if (min(distances) < new_fiber_distance_threshold)
        closest = slice(distances==min(distances),:);
        fiber.addPoint(closest);
    end
end

% The part where you create a virtual point and use it to find min distance
for i=3:length(slices)
    slice = slices{i};
    for j=1:length(fibers)
        fiber = fibers(j); 
        vpoint = fiber.getNextVirtualPoint();
        distances = sqrt(sum(bsxfun(@minus, slice, vpoint).^2,2));
        if (min(distances) < new_fiber_distance_threshold)
            closest = slice(distances==min(distances),:);
            fiber.addPoint(closest);
        end
    end
end

disp("done");


figure 
hold on

plot3(fibers(1).points(:,1), fibers(1).points(:,2), 1:length(fibers(1).points))
plot3(fibers(2).points(:,1), fibers(2).points(:,2), 1:length(fibers(2).points))

hold off

%%% Fiber matching

% %Concatenates the centroid positions into a two columns containing x in the
% %first column and y in the second column with a separate cell for each step
% %size
% k=1;
% for k=1:length(s_array)
%     temp_s=(s_array{1,k});
%     
%     j=1;
%     z=1;
%     while z<=(length(temp_s)/2) && j<length(temp_s) 
%         x1(z)=temp_s(j);
%         y1(z)=temp_s(j+1);
%         z=z+1;
%         j=j+2;
%     end
%     points{k}=[x1;y1]'; %stores centroid information for each cross section at all slices. 
%     %First column = X coordinate. Second colum = Y coordinate. 
%     %Cell Column # = slice number - 1 (numbering scheme starts at zero). 
%     clear x1 y1
%     figure (1)
%     z=[1:i-1];
%     scatter3(points{k}(:,1),points{k}(:,2),[z(k)*ones(1,size(points{k},1))]-1); hold on;
%     
%     k=k+1;
% end
%     
% %% Curve Tracking Algorithm
% %Manual curve linking of slices 0 & 1
% 
% p=1;
% 
% for p=1:size(points{1},1) %for loop for centroids in slice 0
%     a=1;
%     for a=1:size(points{2},1) %for loop to find MSE between centroid "p" in slice 0 and centroids in slice 1
%         mse(a)=immse([points{1}(p,:)],[points{2}(a,:)]);
%         a=a+1;
%     end
%     
%     minimum=min(mse); 
%     min_loc(p)=find(mse==minimum);
%     
%     
%     mse1{p}=mse;
%     
%     mse2(p)=min(mse1{p});
%     
%     
% %     minimum=min(mse); 
% %     min_loc(p)=find(mse==minimum); %finds point in slice 1 that minimizes MSE for centroid "p"
% % %     points_2_x_used(p)=points{2}(min_loc(p),1);
% %     points_updated{p}=[points{1}(p,:);points{2}(min_loc(p),:)]; %concatenates trajectories into separate cells
% %     figure (1)
% %     plot3(points_updated{p}(:,1),points_updated{p}(:,2),[0:size(points_updated{p},1)-1]); hold on;
% %     p=p+1;
% end
% 
% mse=cell2mat(mse1);
% 
% min_loc=[1,1];
% %this portion of the code deals with centroids in k+1 that minimizes MSE
% %for multiple centroids in k
% if length(unique(min_loc))<length(min_loc)%checks if a centroid in k+1 minimizes MSE for multple trajectories
%     
% %     [C, imin_loc, ic] = unique(min_loc);
% %     uniquelocations=sort(imin_loc);
% %     alllocations=sort(ic);
% %     a=diff(alllocations);
%     i=1;%finds the point with minimum mse and assigns the conflicting centroid to that point
%     for i=1:max(min_loc)
%     x_index=find(min_loc==min_loc(i));
%     
%     z=1; %finds MSE for all possible combinations for points in slice 0 and 1
%        for z=1:length(x_index);
%         mse_tie(z)=immse([points{1}(x_index(z),:)],[points{2}(min_loc(i),:)]);
%         z=z+1;
%        end
%        
%     if length(x_index)>1
%     m=1;
%     for m=1:length(x_index)
%        
%        
%     absolute_min=find(mse_tie==min(mse_tie));
%     curve{i}=[points{1}(x_index(absolute_min),:);points{2}(min_loc(i),:)];
%    
%     %update variables
%     %finds the left_over points and update points{2}
%     A=setdiff(points{2}(:,1),points{2}(min_loc(i),1));    
%     q=1;
%     for q=1:length(A)
%        left_over{q}=points{2}((find(points{2}==A(q))),:);
%        q=q+1;
%     end 
%     left_over=cell2mat(left_over');
%     points{2}=left_over;
%     
%     
%     %update absolute_min
%     G=setdiff(mse_tie,mse_tie(absolute_min,1));
%     q=1;
%     for q=1:length(G)
%        left_over_mse(q)=mse_tie(find(mse_tie==G(q)));
%        q=q+1;
%     end 
%     clearvars mse_tie
%     
%     mse_tie=left_over_mse;
%     
%     %recalculate mse with remaining points
%     
%     
%     
%     
%     i=i+1;
%     end
%     end
%     end
%     
% end
% 
%     
%         
% toc    
%     
%     
% 
%     
% %     i=1;
% %     for i=1:length(min_loc)
% %     mse_1=immse([points{1}(i,:)],[points{2}(min_loc(i),:)]);
%     
% 
% 
% 
