function CV_DisconnectDevices(app)
% CV_DisconnectDevices
%   Disconnects all devices from the app
%   Parameters
%   ----------
%   app : Obj
%       A handle to the app designer GUI
    message0 = 'Disconnecting Instruments... Please Wait';
    wb = waitbar(0,message0);
    pause(0.5);
    HW = app.HW;
    if HW ~= 0
        try

            for i=1:3
                % Print waitbar
                message1=['Disconnecting Instruments:Hotplate ',num2str(i),'... Please Wait'];
                waitbar((2*i-1)/8,wb,message1);
                
                % Disconnect the hot plates
                COM_HP = ['COM',num2str(i+8)]; % CHECK THE PORT NUMBERS FOR EACH HOTPLATE
                CloseHP_ext(app, HW, i, COM_HP);
                turnHPLampOnOff(app,i,0);
                pause(0.5);
                
                % Print waitbar
                message2=['Disconnecting Instruments:Arduino ',num2str(i),'... Please Wait'];
                waitbar((2*i)/8,wb,message2);

                % Disconnect the arduinos
                COM_ARd = ['COM',num2str(i+5)]; % CHECK THE PORT NUMBERS FOR EACH ARDUINO
                delete(instrfind({'Port'},{COM_ARd})) %Delete existing object if there is one
                turnArduinoLampOnOff(app,i,0);
                pause(0.5);
            end
            % Print waitbar
            message3=['Disconnecting Instruments:Keithley ... Please Wait'];
            waitbar(7/8,wb,message3);
            %Delete visa object to Keithley 2401 (K2401) if found
            fprintf(HW(1).IMPA, ":OUTP OFF"); %Turn Off Source Output
            delete(instrfind('Name','VISA-GPIB0-25'));
            app.StatusLampKeithley.Color = [0 0 0];

            % Print waitbar
            message4=['Disconnecting Instruments:Impedance Analyzer ... Please Wait'];
            waitbar(1,wb,message4);
            %Delete Impedance Analyzer visa object if it already exists
            delete(instrfind('Name','VISA-GPIB0-17')); 
            app.StatusLampImpedance.Color = [0 0 0];
        catch e
            display(e.message);
        end
    else
        for i=1:3
            turnHPLampOnOff(app,i,0);
            turnArduinoLampOnOff(app,i,0);
        end
    end
    instrreset;
    app.HW = 0;
    for i=1:3
        turnHPLampOnOff(app,i,0);
        turnArduinoLampOnOff(app,i,0);
    end
    app.StatusLampKeithley.Color = [0 0 0];
    app.StatusLampImpedance.Color = [0 0 0];
    pause(0.5);
    close(wb)
    % Turn the connected flag off
    app.devicesConnected = 0;
end