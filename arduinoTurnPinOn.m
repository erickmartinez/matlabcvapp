function arduinoTurnPinOn(app,arduinoNumber,pinNumber)
% arduinoTurnPinOn
% Turns the specified pin on on the arduino
% Parameters
% ----------
% app : obj
%   A handle to the app designer gui object
% arduinoNumber : int
%   The number of the arduino to communicate with
% pinNumber : int
%   The number of the pin to be turned on
    arduinoTogglePin(app,arduinoNumber, pinNumber,1);
end

