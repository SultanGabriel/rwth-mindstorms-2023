%% Aufgabe Zahlendarstellung c)
% Template


%%  ----- MATLAB Calculation -----
 

%% Get two numbers from user dialog
% Tips:
% * use MATLAB command "inputdlg".
% * see MATLAB help for usage and more information.
% * convert the reponse cell array into numbers using "str2double"
%
% ... insert here your code



%% Calculate the summation of the two numbers
% ... insert here your code
zahl_1 = inputdlg();
zahl_2 = inputdlg();
a = zahl_1{1};
b = zahl_2{1};
c = str2num(a);
d = str2num(b);
ergebnis = c + d
ergebnis_zehner = floor(ergebnis / 10)
ergebnis_einer = mod(ergebnis, 10);


%% Initialize figures
plot_number_face;   % plot calculator face figure
hold on             % hold on flag to plot more plots into the calculator face figure



%% Calculate pointers to plot
% Tips:
% * for line plotting only the start and end point of the line has to be given
% * the rotated pointers can be easily constructed by a complex number (value and phase)
% * the length of the complex vectors should be different for both pointers and less than one
% * note the number zero is located at the coordinates (x,y) = (0,1) or (0,i) respectively
% * take care to use degrees or radian
% * consider only angles which are related to the exact number position. Angles between two
% numbers should be neglected.
%
% ... insert here your code


StartPoint = [0 0]

zehner_winkel = ergebnis_zehner * 0.2 * pi 
zehnerPoint = [sin(zehner_winkel) * 0.3, cos(zehner_winkel) * 0.3]

einser_winkel = ergebnis_einer * 0.2 * pi 
einserPoint = [sin(einser_winkel) * 0.7, cos(einser_winkel) * 0.7]


%% Plot pointers into the figure
% Tips:
% * for line plotting only the start and end point of the line has to be given
% * use different colors for the pointers
%
% ... insert here your code

line([0 zehnerPoint(1)], [0 zehnerPoint(2)] , 'LineStyle', '-', 'Color', 'red', 'LineWidth', 5);
line([0 einserPoint(1)], [0 einserPoint(2)] , 'LineStyle', '-', 'Color', 'blue', "LineWidth", 5);


%% Mindstorms NXT - Control
%

%%
% *Program the Mindstorms machine*
%
% ... insert here your code
b = EV3();
b.connect('usb');
b.motorA.limitMode = 'Tacho';
b.motorB.limitMode = 'Tacho';

b.motorA.resetTachoCount;
b.motorB.resetTachoCount;

b.motorA.brakeMode = 'Brake';
b.motorB.brakeMode = 'Brake';

b.motorA.power = -100;
b.motorB.power = 100;

% Motor
b.motorA.limitValue = (zehner_winkel / pi * 180) * 45;
b.motorB.limitValue = einser_winkel / pi * 180;

if(b.motorA.limitValue ~= 0)
    b.motorA.start();
end

if(b.motorB.limitValue ~= 0)
    b.motorB.start();
end
