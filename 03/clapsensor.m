function clapsensor()
% open a new object
ev3_obj=EV3();
ev3_obj.connect('usb','beep','on');

% set mode to dB
ev3_obj.sensor1.mode = DeviceMode.NXTSound.DB;

% clap detection threshold
clapThreshold = 15;
numSamples = 15;

% initialize sample array and state of lamps
values = zeros(numSamples, 1);
changes = zeros(numSamples - 1, 1);
states = [0 0 0];

% initially, create the figure without data, all lamps off
plot_handles = []; % will be initiliazed by clapsensorPlot
plot_handles = clapsensorPlot(plot_handles, values, values, [0 0 0], 0);

max_iterations = 50;
iterations = 0;
while iterations < max_iterations  && isvalid(plot_handles.h_fig)
% start loop
    iterations = iterations + 1;
    
    % get a new sample from the sensor    
    s =  ev3_obj.sensor1.value;
    
    % throw away oldest sample and add the new one at the end
    values = circshift(values,1);
    
    values(1) = s;
    
    
    % calculate changes

    changes=diff(values)
    
    %{
    % Calculate Lamp states
    if( changes(1) > clapThreshold)
        if(states(1))
            states(1) = 0;
        else
            states(1) = 1;
        end

    end
    %}
    
    clapCount = 0;
    for i=1:numSamples-1
       c = changes(i);
       if(c > clapThreshold)
          clapCount = clapCount + 1;
       end
    end
    
    if(clapCount==0)
        states = [0 0 0]
        
    elseif(clapCount==1)
        states = [1 0 0]
        
    elseif(clapCount==2)
        states = [1 1 0]
        
    elseif(clapCount>2)
        states = [1 1 1]
    end
    

    % display plot and lamps
    clapsensorPlot(plot_handles, values, changes, states, clapThreshold);
    
    % wait 10ms between samples
    pause(0.01);
end

% close object
ev3_obj.disconnect();
end
