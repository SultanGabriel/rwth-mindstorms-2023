function values = soundsensor()

b = EV3();
b.connect('usb');
b.sensor1.mode = DeviceMode.NXTSound.DB;

values = [];

for i=1:1000
    
  values(i) = b.sensor1.value;
  
  
end

plot(values)

b.disconnect();
end