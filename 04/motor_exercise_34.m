%% Complex Number Calculator and 'Watch'
% RWTH Mindstorms Versuch 4 Aufgabe 3.4

%% Init EV3
b = EV3();
b.connect('usb');

b.motorA.limitMode = 'Tacho';
b.motorB.limitMode = 'Tacho';

b.motorA.resetTachoCount;
b.motorB.resetTachoCount;

b.motorA.brakeMode = 'Brake';
b.motorB.brakeMode = 'Brake';

b.motorA.power = 100;
b.motorB.power = -100;

%% Get input
ret = inputdlg({"First Complex Number", "Second Complex Number", "Operation (mul, div, conj, sqrt)"})


first = str2num(ret{1})
second =str2num(ret{2})
op =ret{3}

%% Handle Input
switch op
    case 'mul'
	res = first * second
    case 'div'	
	res = first / second
    case 'conj'
	res = 'conj';
    case 'sqrt'
	res = 'sqrt';
    otherwise
	res = NaN;
	return;
end


p1 = angle(first) / pi * 180
p2 = angle(second) / pi * 180

w = angle(res) / pi * 180

%hold all;
compass(real(res), imag(res), "m")
hold on;

compass(real(second), imag(second), "r")
hold on;

compass(real(first), imag(first), "b")
hold off


%% Show input  
disp('Showing Input');
b.motorA.limitValue = p1 * 48;
b.motorB.limitValue = p2;

if(b.motorA.limitValue ~= 0)
    b.motorA.start();
end

if(b.motorB.limitValue ~= 0)
    b.motorB.start();
end

waitForMotors(b)

%% Reset
b.motorA.limitValue = (360 - p1) * 45;
b.motorB.limitValue = 360 - p2;


if(b.motorA.limitValue ~= 0)
    b.motorA.start();
end

if(b.motorB.limitValue ~= 0)
    b.motorB.start();
end

disp('Resetting');
waitForMotors(b);

%% Show result

b.motorA.resetTachoCount;

b.motorA.limitValue = w * 45;

if(b.motorA.limitValue ~= 0)
    disp('Showing Result!')
    b.motorA.start();
end

waitForMotors(b)

%% Final Reset
b.motorA.limitValue = (360 - w) * 45;

if(b.motorA.limitValue ~= 0)
    disp('Final Resetting')
    b.motorA.start();
end

%%

function waitForMotors(b)
    while (true)
        if(~b.motorA.isRunning && ~b.motorB.isRunning)
            break;
        end
    end
    pause(5)
end

