function arduinoConnectKeithley(app,arduinoNumber)
% arduinoConnectKeithley
% Connects the Keithley on the specified arduino
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI instance
% arduinoNumber : int
%   The number of arduino to connect the keithley to
    
    % Get the handle to the corresponding arduino:
    a = app.HW(arduinoNumber).Arduino;
    try
        configurePin(a,'A0','unset'); % The pin is no longer reserved and can be automatically set at the next operation.
    catch
        warndlg(sprintf('Error connecting Keithley on arduino %d',...
            arduinoNumber),'Arduino error');
    end
    clear a;
end