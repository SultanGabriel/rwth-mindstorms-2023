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

global SPEED;
SPEED = 11;

brickObj.motorA.power = SPEED;
brickObj.motorB.power = SPEED;
brickObj.motorC.power = 5;

StopValue = 10;

%%Program
drehUnFahr(brickObj)
while(true)
	disp("Still alive")
	if(brickObj.sensor1.value <= StopValue)
		brickObj.motorA.syncedStop();
        disp("Stopped, dist < stopvalue");
		drehUnFahr(brickObj);
    end
    
    if(~brickObj.motorC.isRunning)
       brickObj.motorC.stop(); 
    end
        
	% EMERGENCY STOP !!!
	if(brickObj.sensor2.value)
		disp("EMERGENCY STOP!!!");
		brickObj.disconnect();
		break;
	end
end



function drehUnFahr(brickObj)
    global SPEED;
    disp("Gegend untersuchen")

	w = umgebungsMessung(brickObj)
    
	drehung(brickObj, w);

	disp("Weiter Fahrt")

	brickObj.motorA.power = SPEED;
	brickObj.motorB.power = SPEED;
    
    brickObj.motorA.limitValue = 0;
    brickObj.motorB.limitValue = 0;
    
	brickObj.motorA.syncedStart(brickObj.motorB);
end

%% function definitions
function w =  umgebungsMessung(brickObj)
    disp("Umgebungs Messung Start")
    brickObj.motorC.limitValue = 360;

    N = 360;
    ABSTAND = zeros(N,1, 'double');
    WINKEL = zeros(N,1, 'double');

    idx = -1;
    idx2 = -1;

    brickObj.motorC.start();
    while 1
        abstand = brickObj.sensor1.value;

        ABSTAND = circshift(ABSTAND, 1);
        WINKEL = circshift(WINKEL, 1);

        ABSTAND(1) = abstand;

        c = double(abs(brickObj.motorC.tachoCount));
        WINKEL(1) = c * 3.14 / 180.0;


        %if(360 - abs(brickObj.motorC.tachoCount) < 3  )
        if(~brickObj.motorC.isRunning)
            disp('Turn back and continue')

            polarplot(WINKEL, ABSTAND);

            brickObj.motorC.power = -100;

            brickObj.motorC.resetTachoCount;

            brickObj.motorC.start();

            brickObj.motorC.resetTachoCount;

            brickObj.motorC.power = 5;
            
            break;
        end
        

    end


    maxAbstand = -1;
    TOLERANZ = 1
    for i = 1:N
        if(maxAbstand < ABSTAND(i))
            maxAbstand = ABSTAND(i);
            idx = i;
            idx2 = -1;
        elseif(abs(maxAbstand - ABSTAND(i)) <= TOLERANZ)
            idx2 = i;
        end
    end

	w1 = WINKEL(idx) / pi * 180

	if(idx2 > 0)
		w2 = WINKEL(idx2) / pi * 180
		w = floor((w1 + w2) / 2)
	else
		w = w1
    end
    
    maxAbstand = maxAbstand
    
    disp("Umgebungs Messung Fertig");
end

function drehung(brickObj, angle)
    global SPEED;
    
	% In Uhrzeigersinn
    %if(angle < 180)
		%angle = angle;
    %    brickObj.motorA.power = SPEED;
    %    brickObj.motorB.power = -SPEED;
    %else 
		% Gegen Uhrzeigersinn
    brickObj.motorA.power = -1 * SPEED;
    brickObj.motorB.power = SPEED;
    %end
    
    brickObj.motorA.limitValue = angle * 2;
    brickObj.motorB.limitValue = angle * 2;
    
    brickObj.motorA.start();
    brickObj.motorB.start();
    
	while(brickObj.motorA.isRunning || brickObj.motorB.isRunning)
		disp("Bin am durchspinnen")
		continue;
	end
	disp("Hab gedreht")
end
            