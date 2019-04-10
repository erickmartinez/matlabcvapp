function arduinoTurnFanOff(app,arduino_number)
    % Get the handle to the corresponding arduino:
    arduino_handle=app.HW(arduino_number).Arduino;
    try
        WriteDigitalPin(arduino_handle,'A1',0);
    catch
        warndlg(sprintf('Error turning the fan off for arduino %d',...
            arduino_number),'Arduino error');
    end
end