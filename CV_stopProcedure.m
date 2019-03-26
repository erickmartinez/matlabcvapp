function CV_stopProcedure(app)
% Stops all processes in the setup and disconnects devices
    % Set the stopFlag to 1 to avoid taking more measurements
    app.stopFlag = 1;  
end
        