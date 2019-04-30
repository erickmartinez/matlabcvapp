function saveMDdata(app,MD)
    % Save all data
    % Contains everything except the hardware handles.
    % FileLoc is the folder chosen in the app, DataFileName is the name given
    % by the user to the measurement.
    MD_1=MD(1); % Save only the Measurement Data of unit 1
%     disp(app.DataFileName_MU1.Value);
    try
        save(app.FileLoc.Value+"\"+app.DataFileName_MU1.Value+".mat",'MD_1'); % Save MD data
    catch e
        logMessage(app,sprintf('Error saving data for unit 1:\n%s',getReport(e)));
    end
    
    MD_2=MD(2); % Save only the Measurement Data of unit 2
    try
        save(app.FileLoc.Value+"\"+app.DataFileName_MU2.Value+".mat",'MD_2');
    catch e
        logMessage(app,sprintf('Error saving data for unit 2:\n%s',getReport(e)));
    end
    
    MD_3=MD(3); % Save only the Measurement Data of unit 3
    try
        save(app.FileLoc.Value+"\"+app.DataFileName_MU3.Value+".mat",'MD_3');
    catch e
        logMessage(app,sprintf('Error saving data for unit 3:\n%s',getReport(e)));
    end
