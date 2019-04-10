function arduinoConnectKeithley(app,arduino_number)
% Connects the arduino on the specified arduino
    % Get the handle to the corresponding arduino:
    arduino_handle=app.HW(arduino_number).Arduino;
    try
        WriteDigitalPin(arduino_handle,'A0',1); % Normally closed position, Keithley connected
        configurePin(arduino_handle,'A0','unset'); % The pin is no longer reserved and can be automatically set at the next operation.
    catch
        warndlg(sprintf('Error connecting Keithley on arduino %d',...
            arduino_number),'Arduino error');
    end
end