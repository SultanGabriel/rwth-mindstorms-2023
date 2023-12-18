function[]  = Aufgabe_a()
%AUFGABE_ Summary of this function goes here
%   Detailed explanation goes here


brickObj = EV3();
brickObj.connect('usb');
a = [];
for i = 1:100
    a = [a,brickObj.sensor2.value] ;
    disp(a)
    pause(1);
end

plot(a);

end

