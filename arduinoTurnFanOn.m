function arduinoTurnFanOn(app,arduino_number)
    % Get the handle to the corresponding arduino:
    arduino_handle=app.HW(arduino_number).Arduino;
    try
        WriteDigitalPin(arduino_handle,'A1',1);
    catch
        warndlg(sprintf('Error turning the fan on for arduino %d',...
            arduino_number),'Arduino error');
    end
end