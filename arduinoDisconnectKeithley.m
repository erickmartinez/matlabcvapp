function arduinoDisconnectKeithley(app,arduino_number)
% Connects the arduino on the specified arduino
    % Get the handle to the corresponding arduino:
    arduino_handle=app.HW(arduino_number).Arduino;
    try
        WriteDigitalPin(arduino_handle,'A0',0); % Normally closed position, Keithley connected
    catch
        warndlg(sprintf('Error disconnecting Keithley on arduino %d',...
            arduino_number),'Arduino error');
    end
end