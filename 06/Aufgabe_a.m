function[]  = Aufgabe_a()
%AUFGABE_ Summary of this function goes here
%   Detailed explanation goes here


brickObj = EV3();
brickObj.connect('usb');
a = [];
for i = 1:1000
    b = brickObj.sensor2.value
    a = [a,b];
    
    disp(b)
    pause(1);
end

plot(a);

end

