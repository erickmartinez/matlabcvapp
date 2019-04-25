function arduinoTurnFanOff(app,MUnb)
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
    a = app.HW(MUnb).Arduino;
    try
        writeDigitalPin(a,'A1',0);
    catch e
        logMessage(app,sprintf('Error turning the fan off on unit %d:\n%s',...
            MUnb,e.message));
    end
    clear a;
end