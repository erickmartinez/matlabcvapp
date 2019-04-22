function arduinoTogglePin(app,arduinoNumber,pinNumber,value)
% Toggle the specified pin in the arduino on or off
% Parameters
% ----------
% arduinoNumber: int  
%   The number of the arduino to communicate with
% pinNumber: int
%   The number of the pin to be toggled
% value : bool
%   The state (either 1 or 0)

    % Force value to be either 1 or 0
    if value ~= 1
        value = 0;
    end
    % Get the handle to the corresponding arduino:
    a = app.HW(arduinoNumber).Arduino;
    try
        writeDigitalPin(a,char("D"+num2str(pinNumber)),value);
    catch
        logMessage(app,sprintf('Error comunicating with Arduino %d pin %d',...
                    arduinoNumber,pinNumber));
    end
    clear a;
end

