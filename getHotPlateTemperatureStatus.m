function [status] = getHotPlateTemperatureStatus(app,hotplateNumber,...
    failedCalls)
% getHotPlateTemperatureStatus
% Gives the set temperature status of the hotplate
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
% status : bool
%   The status of the temperature (0: open, 1:close) 
%   open:heating, close:off


    % From SCILOGEX
    % Section 3.2 Get information
    %
    % Command:
    % -------------------------------------------------------
    %  1   | 2    | 3    | 4    | 5    | 6
    % -------------------------------------------------------
    % 0xfe | 0xA1 | NULL | NULL | NULL | Check sum
    % -------------------------------------------------------
    % Response:
    % -------------------------------------------------------
    %  1   | 2    | 3,4,5,6,7,8,9,10 | 11  
    % -------------------------------------------------------
    % 0xfd | 0xA1 | Parameter1... 8  | Check sum
    % -------------------------------------------------------
    % Parameter3: temperature status (0: closed, 1: open)
    
    MAX_FAILED_CALLS = 20;
    % If failedCalls not int the arguments failedCalls = 0
    if ~exist('failedCalls','var')
        failedCalls = 0;
    end
    
    % Get the handle to the hotplate
    h = app.HW(hotplateNumber).HP;
    q           = [254,161,0,0,0];
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
            status = out(5);
            clear h;
        else
            logMessage(app,sprintf("Error reading temperature status of HP%d.",...
                hotplateNumber));
            % Retry (unless maximu number of attemps has been reached)
            if failedCalls <= MAX_FAILED_CALLS
                logMessage(app,fprintf("Trying again..."));
                pause(0.1);
                status = getHotPlateTemperatureStatus(h,failedCalls);
            else
                error("Exceeded number of attempts to get temperature status of HP%d.",...
                    hotplateNumber);
            end
        end
    catch e
        logMessage(app,sprintf("Error retriving the temperature status on hotplate %d.",...
            hotplateNumber));
        display(e.message);
        failedCalls = failedCalls + 1;
        clear h;
        % Retry (unless maximu number of attemps has been reached)
        if failedCalls <= MAX_FAILED_CALLS
            logMessage(app,sprintf("Trying again..."));
            pause(0.1);
            status = getHotPlateSetTemperature(app,hotplateNumber,...
                failedCalls);
        else
            error("Exceeded number of attempts to get temperature status on HP%d",...
                        hotplateNumber);
        end
    end
    
end