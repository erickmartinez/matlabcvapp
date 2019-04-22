function logMessage(app,msg)
% logMessage 
% Prints a message to Matlab's command window and, if specified, saves it
% in to the file f
%
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI instance
% msg : str
%   The message to be printed

    % Get the path from the GUI
    filename = fullfile(string(app.FileLoc.Value),'output.log');
    % Create a time stamp and add it to the message
    dt = datestr(now,"yyyy/mm/dd hh:MM:ss");
    logMsg = sprintf('%s, %s\n', dt, msg);
    % Display the message in screen
    fprintf(logMsg);
    
    try
        if isfile(filename)
            % open the log file in append mode
            f = fopen(filename, 'a');
        else
            f = fopen(filename, 'wt' );
        end
        % append line to the file
        fprintf(f,logMsg);
        % close the file
        fclose(f);
    catch e
        display(e.message);
    end
end
    
    