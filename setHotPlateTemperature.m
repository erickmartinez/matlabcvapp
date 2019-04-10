function [success] = setHotPlateTemperature(app,hotplateNumber,temperature)
% Tries to set the temperature on the specified hotplate
%   app: a handle to the app designer instance
%   hotplateNumber: a number corresponding to the hotplate
%   temperature: the temperature in °C
    % Get the handle to the hotplate
    Tnew = CorrectT_ext(temperature,hotplateNumber);
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
        out = fread(hotplate_handle); %Read out hotplate response

        if isempty(out) %If not responce
            fprintf("Temperature set point on hotplate %d not successful.",...
                hotplateNumber);
            success = 0;
        else
            success = 1;
            fprintf("Temperature set to %.1f °C on hotplate %d, corresponding to a surface temperature of %.1f",...
                temperature,hotplateNumber,Tnew);
        end
    catch
        warndlg(sprintf('Error communicating with hotplate %d',hotplateNumber),'Hotplate error');
    end
end

