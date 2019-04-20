function logMessage(filename,msg)
% logMessage 
% Prints a message to Matlab's command window and, if specified, saves it
% in to the file f
%
% Parameters
% ----------
% filename : str
%   The path to the file to print the log to
% msg : str
%   The message to be printed

    
    % Create a time stamp and add it to the message
    dt = datestr(now,"yyyy/mm/dd hh:MM:ss");
    logMsg = sprintf('%s, %s\n', dt, msg);
    % Display the message in screen
    fprintf(logMsg);
    
    try
        % open the log file in append mode
        f = fopen(filename, 'a');
        % append line to the file
        fprintf(f,logMsg);
        % close the file
        fclose(f);
    catch e
        display(e.message);
    end
end
    
    