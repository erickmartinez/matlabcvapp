function [success] = setHotPlateTemperature_interface(h,temperature,failedCalls)
% setHotPlateTemperature
% Sends the temperature setpoint to the hotplate
% Parameters
% ----------
% h: obj 
%   The serial connection to the hotplate
% temperature: int 
%   The temperature in �C
% failedCalls : int
%   The number of times the function has been called and produced an error
%
% Returns
% -------
% success : bool
%   1 if ok, 0 otherwise

    % From SCILOGEX
    % 3.5 Temperature control
    % Command:
    % -------------------------------------------------------
    %  1   | 2    | 3          | 4         | 5    | 6
    % -------------------------------------------------------
    % 0xfe | 0xB2 | Temp(high) | temp(low) | NULL | Check sum
    % -------------------------------------------------------
    % Response:
    % -------------------------------------------------------
    %  1   | 2    | 3          | 4    | 5    | 6
    % -------------------------------------------------------
    % 0xfd | 0xB2 | Parameter1 | NULL | NULL | Check sum
    % -------------------------------------------------------
    % If temperature set=300, temphigh)=0x01 temp (low)=0x2C 
    % ********** NOTE: sets T=30 �C not 300 �C
    % Parameter1:
    % 0:OK
    % 1:fault
    
    
    MAX_FAILED_CALLS = 20;
    % If failedCalls not int the arguments failedCalls = 0
    if ~exist('failedCalls','var')
        failedCalls = 0;
    end
    
    % First check if the set temperature is equal to the the set temp in
    % the hotplate
    currentSetPoint = getHotPlateSetTemperature(h);
    
    % If the hotplate setpoint is different from the input temperature or
    % the hotplate temperature status is off, set the temperature
    if (currentSetPoint ~= temperature || ...
            getHotPlateTemperatureStatus(h) == 1)

        % Need to mulptiply by 10 to get the right temp setpoint
        T = temperature*10;
        HT = floor(T/256);  % the high bit of the set temperature
        LT = mod(T,256);    % the low bit of the set temperature
        CumSum = 178+HT+LT; % Obtain checksum value
        CumSum = mod(CumSum,256);
        q = [254,178,HT,LT,0, CumSum]; %Serial bit/byte to send to hotplate
        try
            % Iterate through serial array with 50ms waitime
            for i=1:length(q) 
                fwrite(h,q(i),'uint8'); % Write to hotplate
                pause(.05);
            end
            %Read out hotplate response
            out = fread(h,6); 
            flushoutput(h); % removes data from the output buffer
            flushinput(h); % removes data from the input buffer associated with obj.
            if (isempty(out) || out(3) == 1)  %If no response or error
                fprintf("Temperature set point on hotplate not successful.\n");
                
                failedCalls = failedCalls + 1;
                % Retry (unless maximu number of attemps has been reached)
                if failedCalls <= MAX_FAILED_CALLS
                    pause(0.1);
                    fprintf("Trying again...\n");
                    success = setHotPlateTemperature(h,...
                        temperature,failedCalls);
                else
                    error("Exceeded number of attempts to set temperature on HP");
                end
            else
                success = 1;
                fprintf('HP temperature set: %.1f\n',temperature);
            end % (isempty(out) || out(3) == 1)
        catch
            fprintf('Error communicating with hotplate %d\n',h);
            success = 0;
        end % try catch
%         % If the hotplate is off send the command again
%         if getHotPlateTemperatureStatus(h) == 1
%             fprintf("Hotplate turned off, turining it on...\n");
%             success = setHotPlateTemperature(h,temperature);
%         end
        pause(1); % Let temperature stabilize
    end % if (currentSetPoint ~= temperature || ...
end % function