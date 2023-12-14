function [value switchstate] = touchGetYPos(actualval_vector,cyclecount,brickObj)
% Berechnet den Wert des manuell veraenderlichen Signals fuer die GUI
% Beim Druecken des Tastsensors erhoeht sich der Wert
% und der Wert sinkt beim Loslassen des Tastsensors.
% Ausgabewerte:
%   value: neuer Y-Wert  neuerWert
%   switchstate: Tastsensor-Status
% Eingabewerte:
%   actualval_vector: speichert alle vorherigen Y-Werte (der letzte
%   Eintrag ist die letzte Y-Position)
%   cyclecount: Anzahl der bisherigen Funktionsaufrufe


% % Initialisieren der Bluetooth Verbindung
% brickObj = EV3();
% brickObj.connect('ioType','bt','serPort','/dev/rfcomm0');
% 
% 
% %COM_SetDefaultNXT(h);   gibt es keinen ersatzbefehl fuer?
% 
% % Initialisierung des Sensors und Aufruf der GUI
% 
% %OpenSwitch(SENSOR_1);
% brickObj.sensor1.mode = DeviceMode.Touch.Pushed;
% %
%% Bearbeitung des Codes ab hier:
if(brickObj.sensor1.value)
    switchstate = 1
else
    switchstate = 0
end
cyclecount

%value = 0;

%for index = 1:cyclecount
%    value = value + actualval_vector(l)
%end
%value = (value+)


%begin = max(cyclecount - 12, 1)

%value = 1/cyclecount * (sum(actualval_vector, 'all') + switchstate ) * 1.5 ;

value = actualval_vector(cyclecount) + 0.1 * (2 * switchstate-1);
 
%value = 1/2 * (value + switchstate)

%FUNKTIONIERT
%value = 1/(cyclecount+1) * (sum(actualval_vector) + switchstate) * 1.5;
value = min(max(value, -1.5), 1.5);

end
