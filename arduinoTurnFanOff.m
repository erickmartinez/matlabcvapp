function arduinoTurnFanOff(app,MUNumber)
% arduinoTurnFanOff
% Turns the fan off for the selected measurement unit
%
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI object
% MUNumber : int
%   The number of the selected measurement unit 1, 3 or 3


    % Get the handle to the corresponding arduino:
    a = app.HW(MUNumber).Arduino;
    try
        WriteDigitalPin(a,'A1',0);
    catch
        logMessage(app,sprintf('Error turning the fan off on unit %d.',...
            MUNumber));
    end
    clear a;
end