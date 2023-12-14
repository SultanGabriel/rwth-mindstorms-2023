function plot_number_face()
%% plot number-face

% init figure
figure('Name', 'Number-Face', 'NumberTitle', 'off');
axes;
axis off;

% calc angles
ang = 0:36:180-36;
rad = ang./180*pi;
    
% calc complex numbers
Vec = 1 * exp(-j * (rad-pi/2));
    
X = real(Vec);
Y = imag(Vec);
    
% plot lines
line([X; -X], [Y; -Y], 'LineStyle', '-', 'Color', 'black');

% plot numbers
t = num2str(0:9);
nums = t(1:3:28);
text([X+0.05 -X-0.1], [Y -Y], nums', 'FontSize',16);

end