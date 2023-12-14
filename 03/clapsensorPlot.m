function [ plotStruct ] = clapsensorPlot( plotStruct, values, changes, lampStates, threshold )
%SWITCHLAMP shows a figure holding images representing lamps. The lamps can
% be turned on and off
%   
% examples: 
%  all lamps on:  clapsensorPlot(ps, [1:100], [1:100], [1 1 1], 50)
%  all lamps off: clapsensorPlot(ps, [1:100], [1:100], [0 0 0], 20)



% function was called first time or figure was closed
if(isempty(plotStruct) ||isempty(plotStruct.h_fig) || ~isvalid(plotStruct.h_fig)) 
    plotStruct.h_fig = figure;

    % values
    plotStruct.values_axes = subplot(4,2,[1,3]);

    % diffs
    plotStruct.changes_axes = subplot(4,2,[5,7]);

    % lamps
    plotStruct.lamp1_axes = subplot(4,2,2);
    plotStruct.lamp2_axes =  subplot(4,2,4);
    plotStruct.lamp3_axes =  subplot(4,2,6);

end
    
    

% values
axes(plotStruct.values_axes);
hold off;
plot(values, 'b');
ylim([0 100]);
hold on;
threshold_line = threshold * ones(size(values));
plot(threshold_line, 'r');
% legend('Values', 'Threshold', 'Location', 'southoutside');
title('Values');

% diffs
axes(plotStruct.changes_axes);
hold off;
plot(changes, 'b');
hold on;
threshold_line = threshold * ones(size(changes));
plot(threshold_line, 'r');
% legend('Changes', 'Threshold', 'Location', 'southoutside');

title('Changes');

% lamps
lamp_size = 100;

% red lamp or off
rgb_val_l1 = [lampStates(1) 0 0];
lamp=zeros(lamp_size,lamp_size,3);
lamp(:,:,1) = rgb_val_l1(1);
lamp(:,:,2) = rgb_val_l1(2);
lamp(:,:,3) = rgb_val_l1(3);
axes(plotStruct.lamp1_axes);
imshow(lamp);
title('Lamp 1');

% yellow lamp or off
rgb_val_l2 = [lampStates(2) lampStates(2) 0];
lamp(:,:,1) = rgb_val_l2(1);
lamp(:,:,2) = rgb_val_l2(2);
lamp(:,:,3) = rgb_val_l2(3);
axes(plotStruct.lamp2_axes);
imshow(lamp);
title('Lamp 2');

% green lamp or off
rgb_val_l3 = [0 lampStates(3) 0];
lamp(:,:,1) = rgb_val_l3(1);
lamp(:,:,2) = rgb_val_l3(2);
lamp(:,:,3) = rgb_val_l3(3);
axes(plotStruct.lamp3_axes);
imshow(lamp);
title('Lamp 3');

               
end

