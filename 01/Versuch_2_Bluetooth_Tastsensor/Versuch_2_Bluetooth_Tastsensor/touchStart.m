% **************************************************************
% Beschreibung: Startscript fuer die Ausfuehrung der GUI
%               "touchGUI"
% 
% Autor: Thomas Herold
% Datum: 16.08.2007
% last edited 15.10.2016
% Veraltetes Dokument, aufgrund der neuen EV3 Toolbox eigentlich nicht mehr 
% notwendig.
% **************************************************************

%% Clear Workspace, Close all Figures
clear;
close all;

% %% Initialisieren der Bluetooth Verbindung
% brickObj = EV3();
% brickObj.connect('ioType','bt','serPort','/dev/rfcomm0');
% tic;
% 
% %%COM_SetDefaultNXT(h);   nicht mehr noetig?
% 
% %% Initialisierung des Sensors und Aufruf der GUI
% 
% %%OpenSwitch(SENSOR_1);
% brickObj.sensor1.mode = DeviceMode.Touch.Pushed;
% %%

touchGUI;

