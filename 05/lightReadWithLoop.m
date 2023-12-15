%% Lichtsensor-Versuch - Sensor in Schleife auslesen
function lightReadWithLoop(brickObj, numberOfSeconds)

% hier wird keine Initialisierung des Sensors benoetigt!
% oder doch !
%brick = lightConnectEV3('usb', 'ambient');

% Initialisierung der Vektoren, Start der Stoppuhr
% ...
helligkeitswerte = [];
zeitwerte = [];
time = 0;
tic;

% In einer Schleife für die angegebene Anzahl an Sekunden messen
% ...
    
    while(true)
	if(time/1000 >= numberOfSeconds)
	    break;
	end

	h = brickObj.sensor2.value;
%	helligkeitswerte = [h, helligkeitswerte];
    helligkeitswerte(end+1) = h;
    
	time = time + toc;
    
    zeitwerte(end+1) = time;
%    zeitwerte = [time/1000,zeitwerte];
    end
    
    zeit_differencen = diff(zeitwerte);
    mittelwert_zeit_differencen = mean(zeit_differencen)
    
% Plotten der Ergebnisse
% ...
    plot(zeitwerte,helligkeitswerte,'r-');
    xlabel('Zeit in Sekunden');
    ylabel('Helligkeitswerte');
    title('Helligkeit ueber die Zeit');
    hold off;
    
    figure;
    plot(zeit_differencen, "bo");
    hold on;
    line([0, 1000], [mittelwert_zeit_differencen, mittelwert_zeit_differencen])
    
    

end
