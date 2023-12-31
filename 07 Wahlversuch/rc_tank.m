global SPEED;
global brick;
global KeyIsPressed;
global distPlot;
KeyIsPressed = false;
SPEED = 50;



init();

function brickObj = init()
    global SPEED
	global brick
	global fig;

    brick = EV3();
   	brick.connect('usb');
    %brick.connect('bt', 'serPort', '/dev/rfcomm0')

    brick.motorA.limitMode = 'Tacho';
    brick.motorA.resetTachoCount;
    brick.motorD.resetTachoCount;
    brick.motorA.brakeMode = 'Brake';
    brick.motorD.brakeMode = 'Brake';
    brick.motorA.speedRegulation = 0;
    brick.motorD.speedRegulation = 0;
    brick.motorA.power = SPEED;
    brick.motorD.power = SPEED;

	fig = figure;
	set(fig, 'KeyPressFcn', @keyPressed);
	set(fig, 'KeyReleaseFcn', @keyReleased);

	global t;
	t = timer();
	t.Period = 0.2;
	t.ExecutionMode = 'fixedRate'
	t.TimerFcn = @updateDistPlot;

	start(t)

	global distPlot;
	v = brick.sensor4.value;
	distPlot = bar(v, 'r')
	ylim([0 255])
    

	global beepTimer;
	beepTimer = timer()
	beepTimer.Period= 0.75;
	beepTimer.ExecutionMode = 'fixedRate';
	beepTimer.TimerFcn = @ParkAssistent;
end

function ParkAssistent(~, ~)
	global brick;

	brick.playTone(100, 800, 200);
end

function updateDistPlot(~, ~)
	global brick;
	global distPlot;
	distPlot.YData = brick.sensor4.value;
	if(brick.sensor4.value < 8)
		brick.beep();
	end

end

%% Move Forward or backwards
% dir = 1 (forwards) & dir = -1 (backwards)
function move(dir)
    global SPEED;
    global brick;
	global beepTimer;
	
    brick.motorA.power = dir * SPEED;
    brick.motorD.power = dir * SPEED;

	brick.motorA.start();
	brick.motorD.start();

	if(dir < 0) 
		beepTimer.start;
	end	
    %brick.motorA.syncedStart(brick.motorD);
end

%% Turn left / right
% grad > 0 right turn & grad < 0 left turn
function turn(dir)
    global SPEED;
    global brick;

	brick.motorA.power = -SPEED * dir;
	brick.motorD.power = SPEED * dir;

	brick.motorA.start();
	brick.motorD.start();
end

function stopMotors()
    global brick;
	brick.motorA.stop();
	brick.motorD.stop();
end

function disconnect()
	disp("DISCONNECTING AND CLOSING");
	global t;
	t.stop()
	t.delete()

	global beepTimer;
	beepTimer.delete();

	global brick;	
	brick.disconnect()
	
	global fig;
	close(fig)
end

function moveArm(dir)
	global brick;

	ArmSPEED = 50;
	
	brick.motorB.power = dir * ArmSPEED;
	brick.motorB.start;

end

function stopArm()
	global brick;

	brick.motorB.stop;
end

function moveArmClamp(dir)
	global brick;

	ArmSPEED = 20;

	brick.motorC.power = dir * ArmSPEED;
	brick.motorC.start;
end

function stopArmClamp()
	global brick;
	brick.motorC.stop;
end
	
%% Keyboard keyPressed
function keyPressed(src, event)
	global KeyIsPressed;
	fprintf(1, 'KeyPressed %s\n', event.Key)
	
	if(~KeyIsPressed)
		KeyIsPressed = true;
 		switch event.Key
			case 'w'
				move(1);
			case 's'
				move(-1);
			case 'a'
				turn(-1)
			case 'd'
				turn(1)
			case 'p'
				disconnect();
			case 'r'
				moveArm(1)
			case 'f'
				moveArm(-1)
			case 't'
				moveArmClamp(1)
			case 'g'
				moveArmClamp(-1)
		end
	end

end

%% Keyboard keyRelesed
function keyReleased(src, event)
    global brick;
	global KeyIsPressed;
	global beepTimer;
	fprintf(1, 'KeyReleased %s\n', event.Key)
	
	if(KeyIsPressed)
		KeyIsPressed = 0;
		switch event.Key
			case 'w'
				stopMotors();
			case 's'
				beepTimer.stop;
				stopMotors();
			case 'a'
				stopMotors();
			case 'd'
				stopMotors();
			case 'r'
				stopArm();
			case 'f'
				stopArm()
			case 't'
				stopArmClamp();
			case 'g'
				stopArmClamp();
		end
	end
end
