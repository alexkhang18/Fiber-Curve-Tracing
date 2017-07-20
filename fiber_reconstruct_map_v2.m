%% Fiber reconstruction and 3D mapping code
%Place this script into a folder containing a z-stack of fibers
%Written by Alex Khang
%Last Updated May 19th 2017


%% TODO: Add Z position in each 
clc
clear all
close all

tic 
fibers = Fiber.empty;

growing_fibers = Fiber.empty;
grown_fibers = Fiber.empty;

new_fiber_distance_threshold = 100; 

slices = collectCentroids('Synthetic Data Set/FOV 1 XZ PLANE/');

%% Create initial fibers
slice = slices{1};
for i=1:length(slice(:,1))
   fiber = Fiber;
   point = slice(i,:);
   fiber.addPoint(point);
   growing_fibers = [growing_fibers fiber];
end

%% Extend the fibers
for i=2:length(slices)
    slice = slices{i};
    used = [];
    to_remove = [];
    for j=1:length(growing_fibers)
        fiber = growing_fibers(j);
        point=fiber.getNextVirtualPoint();
        distances = sqrt(sum(bsxfun(@minus, slice, point).^2,2));
        if (min(distances) < new_fiber_distance_threshold)
            used = [used; find(distances==min(distances))];
            closest = slice(distances==min(distances),:);
            fiber.addPoint(closest);
            
            % has this point been used?
%             if any(used==find(distances==min(distances)))
%                 % move this fiber to the grown fibers list
%                 % also, we need to keep track of this fiber's index so we can
%                 % remove it from the growing_fibers list
%                 grown_fibers = [grown_fibers fiber];
%                 to_remove = [j to_remove];
%             end
        else
            to_remove = [j to_remove];
            grown_fibers = [grown_fibers fiber];
        end
    end

    %% Check to see if there are any centroids in the slice which were not used to extend an
    % existing fiber. If so, create a new fiber with that centroid
    unused = setdiff(1:length(slice(:,1)),used); %unused contains the indicies of points not used in slice
    for k=1:length(unused)
        fiber = Fiber;
        point = slice(unused(k),:);
        fiber.addPoint(point);
        growing_fibers = [growing_fibers fiber];
    end
    
    %% Remove non extended and converged fibers from 
    growing_fibers(to_remove) = [];
    
end

toc
%% Plot results
figure 
hold on
for i=1:length(growing_fibers)
    plot3(growing_fibers(i).points(:,1), growing_fibers(i).points(:,2), growing_fibers(i).points(:,3))
end

for i=1:length(grown_fibers)
    plot3(grown_fibers(i).points(:,1), grown_fibers(i).points(:,2), grown_fibers(i).points(:,3))
end
hold off