function closeArd(a)
  fclose( serial(a.Port) ); %Create a serial object with the port Arduino is connected to it and close it
  clear a; %Remove the variable
end