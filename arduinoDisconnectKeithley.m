function arduinoDisconnectKeithley(app,arduino_number)
% arduinoDisconnectKeithley
% Disconnects the Keithley on the specified arduino
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI instance
% arduinoNumber : int
%   The number of arduino to disconnect the keithley from

    % Get the handle to the corresponding arduino:
    a=app.HW(arduino_number).Arduino;
    try
        writeDigitalPin(a,'A0',0); % Normally closed position, Keithley connected
    catch
        logMessage(app,sprintf('Error disconnecting Keithley on unit %d.',...
            arduino_number));
    end
    clear a;
end