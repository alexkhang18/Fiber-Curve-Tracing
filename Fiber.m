classdef Fiber<handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        points = [];
    end
    
    methods
        function addPoint(obj, point) 
            obj.points = [obj.points; point];
        end
        
        function virtual_point = getNextVirtualPoint(obj)
            p1 = [obj.points(end-1,:)];
            p2 = [obj.points(end,:)];
            virtual_point = 2*p2 - p1;
        end
    end 
    
end