function turnArduinoLampOnOff(app,number,status)
% turnArduinoLampOnOff(app,number,status)
% Changes the color of the lamps corresponding to the arduino connections
% according tht provided status
%
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI
% number : int
%   The number of the arduino to change the light to
% status : bool
%   The status (1 = on, 0 = off) of the lamp
    if status == 1
        c = [0 1 0];
    else
        c = [0 0 0];
    end
    switch number
        case 1
            app.StatusLampArd1.Color = c;
        case 2
            app.StatusLampArd2.Color = c;
        case 3
            app.StatusLampArd3.Color = c;
    end
end