%% Lichtsensor-Versuch - Sensor auslesen
function brickObj = lightConnectEV3(brickConnectionType, sensorMode)

%% EV3-Verbindung oeffnen
% EV3-Objekt erstellen
brickObj = EV3();
% Verbindung herstellen
if strcmp(brickConnectionType, 'usb')
  brickObj.connect('usb');
else
  brickObj.connect('bt', 'serPort', '/dev/rfcomm0');
end


%% Lichtsensor initialisieren
%
% Initialisieren Sie den Lichtsensor!

if strcmp (sensorMode, 'ambient')
    brickObj.sensor2.mode = DeviceMode.Color.Ambient;
elseif strcmp (sensorMode, 'reflect')
    brickObj.sensor2.mode = DeviceMode.Color.Reflect;
else
  error('Unbekannter sensorMode');
end
