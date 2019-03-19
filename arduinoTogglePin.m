function arduinoTogglePin(app,arduino_number,pinNumber,value)
% Toggle the specified pin in the arduino on or off
% arduino_handle: The number of the arduino to communicate with
% pinNumber: The number of the pin to be toggled
% value: 1 or 0
    % Force value to be either 1 or 0
    if value ~= 1
        value = 0;
    end
    % Get the handle to the corresponding arduino:
    arduino_handle=app.HW(arduino_number).Arduino;
    try
        writeDigitalPin(arduino_handle,char("D"+num2str(pinNumber)),value);
    catch 
        f = warndlg(sprintf('Error comunicating with Arduino %d pin %d',...
                    arduino_number,pinNumber),'Arduino Error');
    end
end

