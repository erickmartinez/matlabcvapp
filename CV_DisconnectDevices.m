function CV_DisconnectDevices(app)
% CV_DisconnectDevices
%   Disconnects all devices from the app
%   Parameters
%   ----------
%   app : Obj
%       A handle to the app designer GUI

    % Tables containing COM port numbers for each hotplate
    HP_COM_table=[9,5,10];
    % Tables containing COM port numbers for each Arduino
    Ard_COM_table=[8,7,6];

    message0 = 'Disconnecting Instruments... Please Wait';
    wb = waitbar(0,message0);
    pause(0.5);
    HW = app.HW;
    if(~isempty(HW))
        try
            for i=length(HW)
                % Print waitbar
                message1=['Disconnecting Instruments:Hotplate ',num2str(i),'... Please Wait'];
                waitbar((2*i-1)/8,wb,message1);
                
                % Disconnect the hot plates
                COM_HP = ['COM',num2str(HP_COM_table(i))];
                CloseHP_ext(app, HW, i, COM_HP);
                turnHPLampOnOff(app,i,0);
                pause(0.5);
                
                % Print waitbar
                message2=['Disconnecting Instruments:Arduino ',num2str(i),'... Please Wait'];
                waitbar((2*i)/8,wb,message2);

                % Disconnect the arduinos
                COM_ARd = ['COM',num2str(Ard_COM_table(i))];
                delete(instrfind({'Port'},{COM_ARd})) %Delete existing object if there is one
                turnArduinoLampOnOff(app,i,0);
                pause(0.5);
            end
            % Print waitbar
            message3='Disconnecting Instruments:Keithley ... Please Wait';
            waitbar(7/8,wb,message3);
            %Delete visa object to Keithley 2401 (K2401) if found
            if isfield(HW(1),'KEITH')
                fprintf(HW(1).KEITH, ":OUTP OFF"); %Turn Off Source Output
                for mu=1:length(HW)
                    fclose(HW(mu).KEITH);
                end
            end
            delete(instrfind('Name','VISA-GPIB0-25'));
            app.StatusLampKeithley.Color = [0 0 0];

            % Print waitbar
            message4='Disconnecting Instruments:Impedance Analyzer ... Please Wait';
            waitbar(1,wb,message4);
            %Delete Impedance Analyzer visa object if it already exists
            if isfield(HW(1),'IMPA')
                for mu=1:length(HW)
                    fclose(HW(mu).IMPA);
                end
            end
            delete(instrfind('Name','VISA-GPIB0-17'));
            app.StatusLampImpedance.Color = [0 0 0];
        catch e
            frpintf(e.message);
        end
    else
        for i=1:3
            turnHPLampOnOff(app,i,0);
            turnArduinoLampOnOff(app,i,0);
        end
    end
    instrreset;
    app.HW=[]; % Remove the hardware field
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
