brickObj = EV3();
brickObj.connect('usb');
	%brickObj.connect('bt', 'serPort', '/dev/rfcomm0')
brickObj.motorA.limitMode = 'Tacho';
brickObj.motorA.resetTachoCount;
brickObj.motorA.brakeMode = 'Brake';
brickObj.motorA.speedRegulation = 0;
brickObj.motorA.power = 100;

%brickObj.motorA.start();
values = zeros(100,1)
for i = 1:100
    values(i) = brickObj.sensor1.value
end
%brickObj.motorA.stop();
pause(1)
figure(plot(values))

