
%%
b = init();
scan(b);


function brickObj = init()
brickObj = EV3();
%brickObj.connect('usb');
brickObj.connect('bt', 'serPort', '/dev/rfcomm0')

brickObj.motorA.limitMode = 'Tacho';
brickObj.motorD.limitMode = 'Tacho';
brickObj.motorA.resetTachoCount;
brickObj.motorD.resetTachoCount;
brickObj.motorA.brakeMode = 'Brake';
brickObj.motorD.brakeMode = 'Brake';
brickObj.motorA.speedRegulation = 0;
brickObj.motorD.speedRegulation = 0;
brickObj.motorA.power = 50;
brickObj.motorD.power = 50;


brickObj.sensor1.mode = DeviceMode.Color.Col;

end


function scan(brickObj)
    dis = zeros(500);
    ang = zeros(500);
    i = 1;
    while 1
        if(ang(i) <= 360)
            brickObj.sensor3.value = 0;
            break;
        end
        brickObj.motorA.power = 50;
        brickObj.motorD.power = -50;
        brickObj.motorA.syncedStart(brickObj.motorD);
        dis(i) = brickObj.sensor4.value;
        ang(i) = brickObj.sensor3.value; 
        i = i + 1;
    end
    
end