classdef Fiber<handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        points = [];
        was_extended = 0;
    end
    
    methods
        function addPoint(obj, point) 
            obj.points = [obj.points; point];
            obj.was_extended = 1;
        end
        
        %% Returns a point calculated from a trajectory if this fiber has more than 
        % one points. Returns a single point otherwise
        function virtual_point = getNextVirtualPoint(obj)
            if length(obj.points(:,1)) > 1
                p1 = [obj.points(end-1,:)];
                p2 = [obj.points(end,:)];
                virtual_point = 2*p2 - p1;
            else
                virtual_point = [obj.points(1,:)];
            end
        end
    end 
    
end