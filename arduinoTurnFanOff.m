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
    arduino_handle=app.HW(MUNumber).Arduino;
    try
        WriteDigitalPin(arduino_handle,'A1',0);
    catch
        warndlg(sprintf('Error turning the fan off for arduino %d',...
            MUNumber),'Arduino error');
    end
    clear arduino_handle;
end