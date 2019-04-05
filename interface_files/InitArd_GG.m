function [Arduino Therm] = InitArd_GG(com)
            delete(instrfind({'Port'},{char(com)}))
            Arduino = arduino(char(com),'Uno','Libraries','SPI');
            Therm = spidev(Arduino,'D10','Bitrate',5e6);
end