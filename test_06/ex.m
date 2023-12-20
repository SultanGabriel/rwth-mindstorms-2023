classdef ex < handle
    %EX Summary of this class goes here
    %   Detailed explanation goes here
    events
        hit_range;
    end
    properties
        brickObj;
    end
    
    methods
        %%
        function range_under_set_limit()
            disp('aaaaaaa')
        end
        %%
        function do_your_stuff(obj,brickObj)
            addlistener(brickObj.sensor1,'hit_range',@range_under_set_limit)
        end

        %%
        function obj = ex()
            brickObj = EV3();
            brickObj.connect('bt', 'serPort', '/dev/rfcomm0');
            obj.do_your_stuff(brickObj);  
        end

    end
end

