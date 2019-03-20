function CV_stopProcedure(app)
% Stops all processes in the setup and disconnects devices
    measurementUnits = [1,2,3];
    for mu=1:length(measurementUnits)
        % The handle to the arduino
        arduino_handle=app.HW(mu).Arduino;
        % Disconnect all POGO pins
        pogoPins   = MD(mu).ArdP; % Arduino pin numbers corresponding to the POGO pins 
        for pPIN = 1:length(pogoPins)
            arduinoTurnPinOff(app,mu,pPIN);
        end
        % Return all Keithley/Impedance analyzer relay switches to the
        % normal position
        try
            WriteDigitalPin(arduino_handle,'A0',1); % Normally closed position, Keithley connected
        catch
            warndlg(sprintf('Error disconnecting Keithley on arduino %d',...
                arduino_number),'Arduino error');
        end
        % Turn the fan off
        arduinoTurnFanOff(app,mu);
        % Turn the hot plate off
        success = setHotPlateTemperature(app,mu,25.6);
    end
end
        