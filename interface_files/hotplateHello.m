function [status] = hotplateHello(h,failedCalls)
% getHotPlateTemperatureStatus
% Performs a handshake with the hotplate

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
%   The status of the temperature (0: OK, 1:Fault) 


    % From SCILOGEX
    % Section 3.1 Get information
    %
    % Command:
    % -------------------------------------------------------
    %  1   | 2    | 3    | 4    | 5    | 6
    % -------------------------------------------------------
    % 0xfe | 0xA0 | NULL | NULL | NULL | Check sum
    % -------------------------------------------------------
    % Response:
    % -------------------------------------------------------
    %  1   | 2    | 3          | 4    | 5     | 6  
    % -------------------------------------------------------
    % 0xfd | 0xA0 | Parameter1 | NULL | NULL  | Check sum
    % -------------------------------------------------------
    % Parameter3: (0: OK, 1: Fault)
    
    MAX_FAILED_CALLS = 20;
    % If failedCalls not int the arguments failedCalls = 0
    if ~exist('failedCalls','var')
        failedCalls = 0;
    end
    
    q           = [254,160,0,0,0];
    checksum    = mod(sum(q(2:end)),256);
    q           = [q, checksum];
    try 
        for i=1:length(q)
            fwrite(h,q(i),'uint8'); %Write to hotplate
            pause(.05);
        end
        out = fread(h,6); %Read out hotplate response
        flushoutput(h); % removes data from the output buffer
        flushinput(h); % removes data from the input buffer associated with obj.
        if ~isempty(out)
            % Get the value of the set temp HT and LT from the hotplate
            status = out(3);
        else
            % Retry (unless maximu number of attemps has been reached)
            if failedCalls <= MAX_FAILED_CALLS
                fprintf("Trying again...\n");
                pause(0.1);
                status = hotplateHello(h,failedCalls);
            else
                error("Exceeded number of attempts to perform handshake.");
            end
        end
    catch e
        fprintf("Error performing the handshake with the hotplate.\n");
        display(e.message);
        failedCalls = failedCalls + 1;
        % Retry (unless maximu number of attemps has been reached)
        if failedCalls <= MAX_FAILED_CALLS
            fprintf("Trying again...\n");
            pause(0.1);
            status = hotplateHello(h,failedCalls);
        else
            error("Exceeded number of attempts to perform a handshake with the hotplate.");
        end
    end
    
end