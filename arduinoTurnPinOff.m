function arduinoTurnPinOff(app,arduinoNumber,pinNumber)
% Turn the specified pin on on the arduino
% Parameters
% ----------
% app : obj
%   A handle to the app designer gui object
% arduinoNumber : int
%   The number of the arduino to communicate with
% pinNumber : int
%   The number of the pin to be turned off
    arduinoTogglePin(app,arduinoNumber, pinNumber,0);
end
