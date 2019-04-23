function arduinoTurnFanOn(app,MUNumber)
% arduinoTurnFanOn
% Turns the fan onn for the selected measurement unit
%
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI object
% MUNumber : int
%   The number of the selected measurement unit 1, 3 or 3

    % Get the handle to the corresponding arduino:
    a=app.HW(MUNumber).Arduino;
    try
        WriteDigitalPin(a,'A1',1);
    catch
        logMessage(app,sprintf('Error turning the fan on for arduino %d',...
            MUNumber));
    end
    clear a;
end