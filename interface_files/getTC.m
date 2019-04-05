function TempC = getTC(Therm)
    dataIn = [1 1]; %write 2 pieces of info in order to receive 2 pieces of info
    dataOut = writeRead(Therm,dataIn,'uint16'); %uint16 is the largest integer you can use with this function therefore you need 2
    bytepack=uint32(dataOut(1)); %since there are two separate pieces you need to combine them to a 32-bit integer
    bytepack=bitshift(bytepack,16); %data(1) is the 1st half and is converted to uint32 and the data is shifted to the correct side.
    z = bitor(bytepack,uint32(dataOut(2))); %data(2) is the 2nd half and bitor() is used to place this into the correct side of uint32
    z = dec2bin(z,32); %create a 32-bit binary number
    TempC = bin2dec(z(2:14))*0.25;  %from the MAX31855 datasheet, bits 18-31 is the temperature in celcius. These number are referenced backwards in matlab. 
 end