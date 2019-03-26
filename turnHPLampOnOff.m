function turnHPLampOnOff(app,number,status)
% turnHPLampOnOff(app,number,status)
% Changes the color of the lamps corresponding to the hotplate connections
% according tht provided status
%
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI
% number : int
%   The number of the hot plate to change the light to
% status : bool
%   The status (1 = on, 0 = off) of the lamp

    % Define the on and off colors
    if status == 1
        c = [0 1 0];
    else
        c = [0 0 0];
    end
    % Change the colors
    switch number
        case 1
            app.StatusLampHP1.Color = c;
        case 2
            app.StatusLampHP2.Color = c;
        case 3
            app.StatusLampHP3.Color = c;
    end
end