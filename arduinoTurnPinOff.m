function arduinoTurnPinOff(app,arduino_handle,pinNumber)
% Turn the specified pin off on the arduino
    arduinoTogglePin(app,arduino_handle, pinNumber,0);
end
