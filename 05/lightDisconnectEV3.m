%% Lichtsensor-Versuch - Sensor auslesen
function lightDisconnectEV3(brickObj)
%% Bluetooth- oder USB-Verbindung schließen
    brickObj.disconnect();
end

