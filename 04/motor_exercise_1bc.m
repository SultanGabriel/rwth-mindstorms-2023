%% Aufgabe Motormessungen
% Template for exercise b) and c)


%% Open Bluetooth/USB connetion
% ...
b = EV3();
b.connect('usb');

%% Set variables
% ...
    messergebnisse_einzel = [];
    messergebnisse_gesamt = [];
    time = 0;

%% Create motor object
% ...
b.motorA.power = 30;
b.motorA.limitValue = 1000;
%b.motorA.brakeMode = 'Coast';
b.motorA.brakeMode = 'Brake';


%% Do three measurements
% ...
b.motorA.resetTachoCount


tic
for k = 1:3
    b.motorA.resetTachoCount;
    messergebnisse_einzel = [];
    time = 0;
    i=1;
    if (k > 1 )
       b.motorA.power = b.motorA.power +20; 
    end
    b.motorA.start();
    while(1)
        time = time + toc;
        messergebnisse_einzel=[messergebnisse_einzel;[b.motorA.isRunning,b.motorA.tachoCount,time]];
        i = i+1;
        if(time > 6000)
           break; 
        end
    end
    b.motorA.stop;
    %messergebnisse_einzel
    size(messergebnisse_einzel)
    messergebnisse_gesamt = [messergebnisse_gesamt, messergebnisse_einzel(1:250,1:3)];
end
messergebnisse_gesamt;

%% Close NXT
% ...


%% Display permant motor position differences
% ...


%% Plot graphs
% ...
xachse = messergebnisse_gesamt(:,3);

hold all;
plot(xachse,messergebnisse_gesamt(:,2),'r');
plot(xachse,messergebnisse_gesamt(:,5),'m');
plot(xachse,messergebnisse_gesamt(:,8),'c');
plot([-1000 10000],[1000 1000],'b-');
plot(xachse,messergebnisse_gesamt(:,1)*510,'r.');
plot(xachse,messergebnisse_gesamt(:,4)*520,'m.');
plot(xachse,messergebnisse_gesamt(:,7)*530,'c.');
set(gca, 'YScale', 'log');
