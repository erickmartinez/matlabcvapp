function CV_timeLoop(app,MD,CVProgram)
% CV_timeLoop(app,MD)
% A loop with a time counter to run the code every dt seconds
% 
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI
% MD : struct
%   The data structure with the experimental results. All new measurements
%   will be appended to this data structure
% CVProgram : struct
%   A structure with the commands sent to the impedance analyzer

    % Define the period of evaluation
    dt = app.loopInterval;
    % Start measuring the time
    tic;
    % The index of the measurement units
    measurementUnits = [1,2,3];
    % Set the idle flag to zero, indicating that there's an experiment
    % running
    app.idleFlag = 0;
    % Start an 'infinite' while loop
    while app.stopFlag ~= 1
        if rem(toc,dt) == 0
            for mu=1:length(measurementUnits)
                MD = fcncallback_ext(app,mu,MD,CVProgram);
            end
            % If all the measurements are completed leave the while loop
            if MD(1).MDdata.finish_flag == 1 && MD(2).MDdata.finish_flag == 1 ...
                    && Md(3).MDdata.finish_flag == 1
                app.stopFlag = 1;
                break;
            end
        end
    end
    
    % When finished, disconnect all POGO pins, disconnect Impedance
    % Analyzer, turn off all the hotplates, turn off the fans, and delete
    % visa objects
    CV_RebootSystem(app,MD);
    app.stopFlag = 0;
    app.idleFlag = 1;
end