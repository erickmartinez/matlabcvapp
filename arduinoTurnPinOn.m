function arduinoTurnPinOn(app,arduino_handle,pinNumber)
% Turn the specified pin on on the arduino
    arduinoTogglePin(app,arduino_handle, pinNumber,1);
end

