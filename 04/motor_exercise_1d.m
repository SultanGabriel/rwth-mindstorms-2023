
%% Open Bluetooth/USB connetion
% ...
b = EV3();
b.connect('usb');

%% Create motor object
% ...
b.motorA.power = -100;
b.motorA.smoothStart = 0;
b.motorA.limitMode = 'Tacho';
b.motorA.limitValue = 0;
b.motorA.resetTachoCount
b.motorA.brakeMode = 'Brake';
b.motorA.speedRegulation = 1;


b.motorB.power = 100;
b.motorB.smoothStart = 0;
b.motorB.limitMode = 'Tacho';
b.motorB.limitValue = 0;
b.motorB.resetTachoCount
b.motorB.brakeMode = 'Brake';
b.motorB.speedRegulation = 1;

b.motorA.start;
b.motorB.start;

