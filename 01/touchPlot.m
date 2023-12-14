function touchPlot(nominalval_vector,actualval_vector,switchstate_vector)
% Ausgabe der Ergebnisse von der GUI "touchGUI"
% Eingabewerte:
%   nominalval_vector: speichert die Sinuswelle
%   actualval_vector: speichert alle vorherigen Y-Werte (der letzte Eintrag
%   ist die letzte Y-Position)
%   switchstate_vector: speichert die Schalterzustaende des NXT Tastsensors



%% Variablen
x_values = 1:length(nominalval_vector);  % Vektor der x-Werte

%% Bearbeitung des Codes ab hier:
scr_size = get(0,'ScreenSize') ;
figure('position',[0.25 * scr_size(4), 0.25 * scr_size(3), 0.5*scr_size(3), 0.5*scr_size(4)] );

p1 = plot(x_values, nominalval_vector, 'b-');
hold on;
p2 = plot(x_values, actualval_vector, 'r-');
grid on
hold off;
title("Soll- und Istwert", "FontSize", 15);

set(gca, "FontSize", 15);

xlabel('X-Werte', "FontSize", 15);
ylabel('Y-Werte', "FontSize", 15);

legend('Sinus', 'Versuch')


%%Schalterstatus
figure
plot(x_values, switchstate_vector, 'r-');
title("Schalterstatus");


end