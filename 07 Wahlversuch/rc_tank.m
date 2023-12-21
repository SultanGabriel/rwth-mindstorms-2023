global SPEED;
global brick;
global KeyIsPressed;
global distPlot;
KeyIsPressed = false;
SPEED = 50;



init();
%% Main Loop
%while(true)
%	%Emergency stop	
%	if(brick.sensor2.value)
%		brick.disconnect()
%
%		global t;
%		t.stop()
%		t.delete()
%		break
%	end
%
%%	global distPlot;
%%	distPlot.YData = brick.sensor4.value;
		
%end

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
	% % right turn
    % %{if (dir > 0)
	% 	brick.motorA.power = -SPEED;
	% 	brick.motorD.power = SPEED;
	% 	%brick.motorA.limitValue = grad;
	% 	%brick.motorD.limitValue = grad;
	% elseif(dir < 0)
	% 	brick.motorA.power = SPEED;
	% 	brick.motorD.power = -SPEED;
	% 	%brick.motorA.limitValue = abs(grad);
	% 	%brick.motorD.limitValue = abs(grad);
	% end
	% %}

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

function shoot()
	disp("shoot")
end

function stopShooting()
	disp("stopShooting")
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
			case 'space'
				shoot();
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
				%brick.motorA.syncedStop();
				stopMotors();
			case 's'
				%brick.motorA.syncedStop();
				beepTimer.stop;
				stopMotors();
			case 'a'
				stopMotors();
			case 'd'
				stopMotors();
			case 'space'
				stopShooting();
		end
	end
end



