function [status] = getHotPlateTemperatureStatus_interface(h,failedCalls)
% getHotPlateTemperatureStatus
% Gives the set temperature status of the hotplate
% Parameters
% ----------
% h: obj 
%   The serial connection to the hotplate
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
    
    q           = [254,161,0,0,0];
    checksum    = mod(sum(q(2:end)),256);
    q           = [q, checksum];
    try 
        for i=1:length(q)
            fwrite(h,q(i),'uint8'); %Write to hotplate
            pause(.05);
        end
        out = fread(h,11); %Read out hotplate response
        flushoutput(h); % removes data from the output buffer
        flushinput(h); % removes data from the input buffer associated with obj.
        if ~isempty(out)
            % Get the value of the set temp HT and LT from the hotplate
            status = out(5);
        else
            fprintf("Error reading temperature status of hotplate\n");
            % Retry (unless maximu number of attemps has been reached)
            if failedCalls <= MAX_FAILED_CALLS
                fprintf("Trying again...\n");
                pause(0.1);
                status = getHotPlateTemperatureStatus(h,failedCalls);
            else
                error("Exceeded number of attempts to get temperature status.");
            end
        end
    catch e
        fprintf("Error retriving the temperature status on hotplate.\n");
        display(e.message);
        failedCalls = failedCalls + 1;
        % Retry (unless maximu number of attemps has been reached)
        if failedCalls <= MAX_FAILED_CALLS
            fprintf("Trying again...\n");
            pause(0.1);
            status = getHotPlateSetTemperature(h,failedCalls);
        else
            error("Exceeded number of attempts to get temperature status.");
        end
    end
    
end