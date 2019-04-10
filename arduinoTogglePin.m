function arduinoTogglePin(app,arduinoNumber,pinNumber,value)
% Toggle the specified pin in the arduino on or off
% Parameters
% ----------
% arduino_handle: int  
%   The number of the arduino to communicate with
% pinNumber: int
%   The number of the pin to be toggled
    % Force value to be either 1 or 0
    if value ~= 1
        value = 0;
    end
    % Get the handle to the corresponding arduino:
    arduino_handle=app.HW(arduinoNumber).Arduino;
    try
        writeDigitalPin(arduino_handle,char("D"+num2str(pinNumber)),value);
    catch 
        warndlg(sprintf('Error comunicating with Arduino %d pin %d',...
                    arduinoNumber,pinNumber),'Arduino Error');
    end
    clear arduino_handle;
end

