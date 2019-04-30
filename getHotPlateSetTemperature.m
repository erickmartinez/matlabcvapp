function [setTemperature] = getHotPlateSetTemperature(app,hotplateNumber,...
    failedCalls)
% getHotPlateSetTemp
% Gives the set temperature on the hotplate
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI instance
% hotplateNumber : int
%   The number of the hotplate to read the temperature on
% failedCalls : int
%   The number of times the function has been called and produced an error
% 
% Returns
% -------
% setTemperature : float
%   The set temperature of the hotplate in �C

    % From SCILOGEX
    % Section 3.3 Get status
    %
    % Command:
    % -------------------------------------------------------
    %  1   | 2    | 3    | 4    | 5    | 6
    % -------------------------------------------------------
    % 0xfe | 0xA2 | NULL | NULL | NULL | Check sum
    % -------------------------------------------------------
    % Response:
    % -------------------------------------------------------
    %  1   | 2    | 3,4,5,6,7,8,9,10 | 11  
    % -------------------------------------------------------
    % 0xfd | 0xA2 | Parameter1... 8  | Check sum
    % -------------------------------------------------------
    % Parameter5: temp set (high)
    % Parameter6: temp set (low)
    
    MAX_FAILED_CALLS = 20;
    % If failedCalls not int the arguments failedCalls = 0
    if ~exist('failedCalls','var')
        failedCalls = 0;
    end
    
    % Get the handle to the hotplate
    h = app.HW(hotplateNumber).HP;
    q           = [254,162,0,0,0];
    checksum    = mod(sum(q(2:end)),256);
    q           = [q, checksum];
    try 
        for i=1:length(q)
            fwrite(h,q(i),'uint8'); %Write to hotplate
            pause(.05);
        end
        pause(0.1);
        out = fread(h,11); %Read out hotplate response
        flushoutput(h); % removes data from the output buffer
        flushinput(h); % removes data from the input buffer associated with obj.
        if ~isempty(out)
            % Get the value of the set temp HT and LT from the hotplate
            tHL = out(7:8);
            % Transform the value into decimal
            val = 0;
            N = length(tHL);
            for i=1:N
                val = val + 256^(N-i)*tHL(i);
            end
            setTemperature = val/10;  
            clear h;
        else
            logMessage(app,sprintf("Error reading set temperature of HP%d",...
                hotplateNumber));
            failedCalls = failedCalls + 1;
            % Retry (unless maximu number of attemps has been reached)
            if failedCalls <= MAX_FAILED_CALLS
                logMessage(app,sprintf("Trying again..."));
                pause(0.1);
                setTemperature = getHotPlateSetTemperature(h,failedCalls);
            else
                error("Exceeded number of attempts to get set temperature on HP%d.",...
                    hotplateNumber);
            end
        end
    catch e
        logMessage(app,sprintf("Error retriving the set temperature on hotplate %d:",...
            hotplateNumber));
        display(e.message);
        
        failedCalls = failedCalls + 1;
        clear h;
        % Retry (unless maximu number of attemps has been reached)
        if failedCalls <= MAX_FAILED_CALLS
            logMessage(app,sprintf("Trying again..."));
            pause(0.1);
            setTemperature = getHotPlateSetTemperature(app,hotplateNumber,...
                failedCalls);
        else
            error("Exceeded number of attempts to get set temperature on HP%d",...
                        hotplateNumber);
        end
    end
end