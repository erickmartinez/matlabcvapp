function CV_RebootSystem(app,MD)
% CV_RebootSystem
% Disconnects all the POGO pins, disconnects the impedance analyzer, turns
% off all the hot plates and fans.
% 
% Parameters
% ----------
% app : obj
%   a handle to the app designer GUI

    %%% This part needs to be called in RunIterCV: before each pin measurement, check the stopflag. If it is 1, 
    %%% break the for loop of RunIterCV and call close_setup.
    %%% close_setup also needs to be called at the end of the while loop
    %%% need to close all visa objects here too
    %%% function close_setup
    measurementUnits = [1,2,3];
    for mu=1:length(measurementUnits)
        % The handle to the arduino
        a = app.HW(mu).Arduino;
        % Disconnect all POGO pins
        pogoPins   = MD(mu).ArdP; % Arduino pin numbers corresponding to the POGO pins (can be any numbers and does not necessarily start at 1)
        for pPIN = 1:length(pogoPins)
            arduinoTurnPinOff(app,mu,pogoPins(pPIN));
        end
        % Return all Keithley/Impedance analyzer relay switches to the
        % normal position
        try
            WriteDigitalPin(arduino_handle,'A0',1); % Normally closed position, Keithley connected
            WriteDigitalPin(a,'A0',1); % Normally closed position, Keithley connected
            configurePin(a,'A0','unset'); % The pin is no longer reserved and can be automatically set at the next operation.
        catch
            warndlg(sprintf('Error disconnecting Keithley on arduino %d',...
                mu),'Arduino error');
        end
        % Turn the fan off
        arduinoTurnFanOff(app,mu);
        % Turn the hot plate off
        success = setHotPlateTemperature(app,MD,mu,25.6);
    end
    clear Arduino_handle
    clear a;
        success = setHotPlateTemperature(app,mu,25.6);
        clear a;
end
    CV_DisconnectDevices(app);
end