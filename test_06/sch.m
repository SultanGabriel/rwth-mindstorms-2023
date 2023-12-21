brickObj = EV3();
brickObj.connect('usb');
%brickObj.connect('bt', 'serPort', '/dev/rfcomm0')
brickObj.motorC.limitMode = 'Tacho';
brickObj.motorC.resetTachoCount;
brickObj.motorC.brakeMode = 'Brake';
brickObj.motorC.speedRegulation = 1;
brickObj.motorC.power = 100;

brickObj.motorC.start();

%brickObj.sensor2.mode = DeviceMode.Color.Col;



