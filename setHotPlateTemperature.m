function [success] = setHotPlateTemperature(app,MD,hotplateNumber,temperature)
% Tries to set the temperature on the specified hotplate
%   app: a handle to the app designer instance
%   hotplateNumber: a number corresponding to the hotplate
%   temperature: the temperature in °C
    % Get the handle to the hotplate
%     TargetTempH=MD(hotplateNumber).ExpData.Setup.TempH;
%     TargetTempC=MD(hotplateNumber).ExpData.Setup.TempC;
    hotplate_handle = app.HW(hotplateNumber).HP;
    HT = floor(temperature/25.6); %Set high temp value 
    LT = mod(temperature,25.6)*10; %Set low temp value 
    CumSum = 178+HT+LT; % Obtain checksum value
    CumSum = mod(CumSum,256);
    array = [254,178,HT,LT,0, CumSum]; %Serial bit/byte to send to hotplate
    try
        for j=1:length(array) %Iterature through serial array with 50ms waitime
            fwrite(hotplate_handle,array(j),'uint8'); %Write to hotplate
            pause(.05)
        end
%         pause(0.1);
        out = fread(hotplate_handle,6); %Read out hotplate response
        flushoutput(hotplate_handle); % removes data from the output buffer
        if (isempty(out) || out(3) == 1)  %If no response
            fprintf("Temperature set point on hotplate %d not successful. Trying again...\n",...
                hotplateNumber);
            setHotPlateTemperature(app,MD,hotplateNumber,temperature);
            success = 0;
        else
            success = 1;
            fprintf('HP%d temperature set: %.1f\n',hotplateNumber,temperature);
        end
    catch
        warndlg(sprintf('Error communicating with hotplate %d',hotplateNumber),'Hotplate error');
    end
    clear hotplate_handle;
    pause(1); % Let temperature stabilize
end