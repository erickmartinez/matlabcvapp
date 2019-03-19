function CV_timeLoop(app)
    % A loop with a time counter to run the code as a function of time
    % Check if the time interval exists, else define it locally
    if exist app.timeInterval
        dt = app.timeInterval;
    else
        dt = 60; % seconds
    tic;
    measurementUnits = [1,2,3];
    while app.stopFlag ~= 1
        if rem(toc,dt) == 0
            for mu=1:length(measurementUnits)
                MD = fcncallback_ext(app,mu,MD);
            end
        end
    end
    CV_stopProcedure(app);
end