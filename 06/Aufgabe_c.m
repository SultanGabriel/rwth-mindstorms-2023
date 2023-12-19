brickObj = EV3();
%brickObj.connect('usb');
brickObj.connect('bt', 'serPort', '/dev/rfcomm0')

brickObj.motorA.limitMode = 'Tacho';
brickObj.motorB.limitMode = 'Tacho';
brickObj.motorC.limitMode = 'Tacho';

brickObj.motorA.resetTachoCount;
brickObj.motorB.resetTachoCount;
brickObj.motorC.resetTachoCount;

brickObj.motorA.brakeMode = 'Brake';
brickObj.motorB.brakeMode = 'Brake';
brickObj.motorC.brakeMode = 'Brake';

brickObj.motorA.speedRegulation = 0;
brickObj.motorB.speedRegulation = 0;
brickObj.motorC.speedRegulation = 1;

brickObj.motorA.power = 100;
brickObj.motorB.power = 100;
brickObj.motorC.power = -5;

brickObj.motorC.limitValue = 360;


brickObj.motorC.start();
%brickObj.motorA.syncedStart(brickObj.motorB);

N = 360;
ABSTAND = zeros(N,1, 'double');
WINKEL = zeros(N,1, 'double');

%polarplot(WINKEL, ABSTAND);

%linkdata on

while 1

    abstand = brickObj.sensor1.value
   
    ABSTAND = circshift(ABSTAND, 1);
    WINKEL = circshift(WINKEL, 1);

    ABSTAND(1) = abstand;
    
    c = double(abs(brickObj.motorC.tachoCount))
    WINKEL(1) = c * 3.14 / 180.0;

     %{
    if(brickObj.motorC.power < 0 )
        ABSTAND = circshift(ABSTAND, -1);
        WINKEL = circshift(WINKEL, -1);

        ABSTAND(end) = abstand;
        
        c = abs(double(brickObj.motorC.tachoCount))
        WINKEL(end) = c * 3.14 / 180.0
        
    else
        ABSTAND = circshift(ABSTAND, 1);
        WINKEL = circshift(WINKEL, 1);

        ABSTAND(1) = abstand
        
        c = double(brickObj.motorC.tachoCount)
        WINKEL(1) = c * 3.14 / 180.0
    end
        %}
    
    if(abstand <= 40)
        disp('stoped')
        %brickObj.motorA.syncedStop();  
        %brickObj.disconnect();
        %break;
    end
    %brickObj.motorC.tachoCount
    if(360 - abs(brickObj.motorC.tachoCount) < 1  )
        disp('turn')
        
        polarplot(WINKEL, ABSTAND);
        break;
        
        brickObj.motorC.resetTachoCount;
        if(brickObj.motorC.power == 10)
            brickObj.motorC.power = -10;
        else
            brickObj.motorC.power = 10;
        end
        brickObj.motorC.start();
    end
  
end

maxAbstand = -1;
idx = -1;
idx2 = -1
TOLERANZ = 1
for i = 1:N
    if(maxAbstand < ABSTAND(i))
        maxAbstand = ABSTAND(i)
        idx = i;
        idx2 = -1;
    elseif(abs(maxAbstand - ABSTAND(i)) <= TOLERANZ)
        idx2 = i;
    end
        
end

maxAbstand
idx
idx2


wstart = WINKEL(idx) / pi * 180

if(idx2 > 0)
    wstop = WINKEL(idx2) / pi * 180

    w = floor((wstart + wstop) / 2)
    drehung(brickObj, w)
else
    drehung(brickObj, wstart)
end


%brickObj.disconnect();


function drehung(brickObj, angle)
    if(angle < 0)
        brickObj.motorA.power = 100;
        brickObj.motorB.power = -100;
    else 
        brickObj.motorA.power = -100;
        brickObj.motorB.power = 100;
    end
    
    brickObj.motorA.limitValue = angle * 2;
    brickObj.motorB.limitValue = angle * 2;
    
    brickObj.motorA.start();
    brickObj.motorB.start();
    
end