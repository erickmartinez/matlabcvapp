function CV_stopProcedure(app)
% Stops all processes in the setup and disconnects devices
    % Set the stopFlag to 1 to avoid taking more measurements
    app.stopFlag = 1;
    measurementUnits = [1,2,3];
    
    %%% This part needs to be called in RunIterCV: before each pin measurement, check the stopflag. If it is 1, 
    %%% break the for loop of RunIterCV and call close_setup.
    %%% close_setup also needs to be called at the end of the while loop
    %%% need to close all visa objects here too
    %%% function close_setup
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
        