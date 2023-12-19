function varargout = touchGUI(varargin)
% GUI_MAIN M-file for gui_main.fig
%      GUI_MAIN, by itself, creates a new GUI_MAIN or raises the existing
%      singleton*.
%
%      H = GUI_MAIN returns the handle to a new GUI_MAIN or the handle to
%      the existing singleton*.
%
%      GUI_MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_MAIN.M with the given input arguments.
%
%      GUI_MAIN('Property','Value',...) creates a new GUI_MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_main_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_main_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_main

% Last Modified by GUIDE v2.5 24-Oct-2007 09:46:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @touchGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @touchGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_main is made visible.
function touchGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_main (see VARARGIN)

% Choose default command line output for gui_main
handles.output = hObject;

    %% Initialisieren der Bluetooth Verbindung
brickObj = EV3();
brickObj.connect('bt','serPort','/dev/rfcomm0');


%%COM_SetDefaultNXT(h);   nicht mehr noetig?

%% Initialisierung des Sensors und Aufruf der GUI

%%OpenSwitch(SENSOR_1);
brickObj.sensor1.mode = DeviceMode.Touch.Pushed;
handles.NXT = brickObj
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_main wait for user response (see UIRESUME)
% uiwait(handles.gui_main);


% --- Outputs from this function are returned to the command line.
function varargout = touchGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%% --- Executes on button press in startstop.
function startstop_Callback(hObject, eventdata, handles)
% hObject    handle to startstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of startstop

% Nur bei gedruecktem Startknopf wird das Funktion weiter ausgefuehrt
% Ansonsten wird die Funktion verlassen
if (get(handles.startstop,'Value') == 0)
    return
end

% --- Define Variables ---
nominalval_vector = 0;
actualval_vector = 0;
switchstate_vector = 0;
difference = 0;             % Variable zum Aufsummieren der Absolutfehlerzeitflaechen

cyclecount = 0;             % Durchlaufzaehler
shiftwidth = 30;            % Verschiebeweite des Sollwertes pro Schleifendurchlauf
periods = 3;                % Anzahl der zu durchlaufenden Perioden des Sollsignals

duration = 0;               % Laufzeit
timestep = 0;               % Laenge eines Durchlaufs der Whileschleife
wait = 0.05;                   % Wartezeit innerhalb der While-Schleife [s]

actualval = 0;  % Wert des durch Druecken veraenderbaren Signals (Sollwert)
switchstate = 0;    % Schalterstatus

% Generierung des Sollsignals
x_values = 0:0.001:1;
nominalval = sin(2*pi*x_values*1);

% Bestimmung der Cursorposition in der Mitte des Sollsignals
curserpos = floor(length(x_values)/2);

% Grafikausgabe initialisieren
axes(handles.sineplot);
plot(x_values,nominalval,x_values(curserpos),actualval,'ro');
axis([0 1 -2 2]);
set(handles.sum_error,'String',num2str(difference));
set(handles.time,'String',num2str(0))

% Countdown (wird durch Abschalten gestoppt)
if (get(handles.startstop,'Value') == 1)
    set(handles.countdown,'String',num2str(3))
    pause(1)
else
    return
end
if (get(handles.startstop,'Value') == 1)
    set(handles.countdown,'String',num2str(2))
    pause(1)
else
    return
end
if (get(handles.startstop,'Value') == 1)
    set(handles.countdown,'String',num2str(1))
    pause(1)
else
    return
end
set(handles.countdown,'String','go')

tic;  % Initialisieren der Zeitnahme einer Schleifendurchlaufdauer

% While-Schleife wird durch Betaetigung des Startknopfes ausgefuehrt, 
% bis dieser erneut betaetigt wird oder die Zeit abglaufen ist.
while(get(handles.startstop,'Value'))
    cyclecount = cyclecount + 1;
    
    % Speichern der Variablen in die Arrays
    nominalval_vector(cyclecount) = nominalval(curserpos);
    actualval_vector(cyclecount) = actualval;
    switchstate_vector(cyclecount) = switchstate;
    

%%
    % manuell erzeugten Istwert und Schalterstellung holen
    [actualval switchstate] = touchGetYPos(actualval_vector,cyclecount,handles.NXT);
    % automatisch erzeugten Istwert und Schalterstellung holen
%     [actualval switchstate] = touchGetYPosAuto(nominalval_vector,actualval_vector,cyclecount);

    % Rotation des Sollwertes
    nominalval = circshift(nominalval',-shiftwidth)';

    % Ausgabe der Grafik
    plot(x_values,nominalval,x_values(curserpos),actualval,'ro')
    axis([0 1 -2 2])
    
    pause(wait);        % Warten
    timestep = toc;   % Speichern der Durchlaufzeit
    tic;          % Neuinitialisieren der Zeitnahme
    
    % Bildung des Absolutwertes aus der Differenz zw. Ist und Soll
    % (gerundet auf zwei Nachkommastellen)
    difference = round((difference + abs(actualval - nominalval(500)))*1e3)*1e-3;
    set(handles.sum_error,'String',num2str(difference))

    % Bestimmen der Gesamtzeit (gerundet auf eine Nachkommastelle)
    duration = duration + timestep;
    set(handles.time,'String',num2str(round(duration*10)/10));

    % Abbruch bei Erreichen der eingestellten Periodenanzahl
    if length(nominalval_vector) >= round(periods*length(nominalval)/shiftwidth)
        set(handles.startstop,'Value',0);
    end
end
set(handles.startstop,'UserData',[nominalval_vector;actualval_vector;switchstate_vector]);

set(handles.countdown,'String',num2str(3))


%% --- Executes on button press in output.
function output_Callback(hObject, eventdata, handles)
% hObject    handle to output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Schliessen der Fenster ausser der GUI
close(findobj('-not','Name','touchGUI','-and','IntegerHandle','on'))

plotdata = get(handles.startstop,'UserData');
if(isempty(plotdata))
    fprintf(1,'\n No Data stored! Run GUI before first call of "Ausgabe"!\n\n','Color','Y');
    return
end

% keine Ausgabe waehrend laufender While-Schleife
if (get(handles.startstop,'Value') == 0)
    touchPlot(plotdata(1,:),plotdata(2,:),plotdata(3,:));
else
    return
end

% --- Executes when user attempts to close gui_main.
function gui_main_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to gui_main (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Beim Beenden der GUI wird die Whileschleife beendet
if (get(handles.startstop,'Value') == 1)
    set(handles.startstop,'Value',0);
end
    
%%hObject.disconnect();

% Hint: delete(hObject) closes the figure
delete(hObject);
close all;


