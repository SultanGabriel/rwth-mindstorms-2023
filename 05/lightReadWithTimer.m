%% Lichtsensor-Versuch - Sensor timergesteuert auslesen
function lightReadWithTimer(brickObj, numberOfSeconds)

% ... Initialisierung der Vektoren, Starten der Stoppuhr hierher kopieren ...
% ...

myUserData.helligkeitswerte = [];
myUserData.zeitwerte = [];
myUserData.brick = brickObj;
myUserData.time = 0;
myUserData.endTime = numberOfSeconds;
myUserData.startTime = 0;
% Timer-Objekt anlegen und starten
% ...
t = timer("UserData", myUserData)

%set(t, "Period", 50)
%set(t, "UserData", myUserData)
%set(t, "ExecutionMode","fixedRate")
%set(t, "TimerFcn", @readLightTimerFcn) 

t.Period = 0.05;
t.ExecutionMode = 'fixedRate';
t.TimerFcn =  @readLightTimerFcn;
%t.StartFcn = @startFcn;

start(t);
tic;

% Daten aus Timer-Objekt auslesen.
% ...
% obj = get(t, "UserData")

% Plotten der Ergebnisse hierher kopieren
% ...

end 

%--------------------------------------------------------------------------

%%
function readLightTimerFcn (timerObj, event)
%    disp("ICH WURDE AUFGERUFEN!!!")

    obj = timerObj.UserData  
    %t1 = obj.startTime;
    
    obj.helligkeitswerte(end+1) = obj.brick.sensor2.value;

    obj.time = obj.time + toc
    obj.zeitwerte(end+1) = obj.time;


% Daten zurueck in Timer-Objekt sichern
    timerObj.UserData = obj;
    %t1 = datevec(datenum(obj.startTime));
    %t2 = datevec(datenum(event.time));



    if(obj.time/100 >= obj.endTime)
        timerObj.stop;

        plot(obj.zeitwerte, obj.helligkeitswerte);

        timerObj.delete;
    end

end
%{
function startFcn(timerObj, event)
    obj = timerObj.UserData
    obj.startTime = event.time

    timerObj.UserData = obj
end

%}