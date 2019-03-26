function saveMDdata(app, MD)
    % Save data
    % Contains everything except the hardware handles.
    % FileLoc is the folder chosen in the app, DataFileName is the name given
    % by the user to the measurement.
    MD_1=MD(1); % Save only the Measurement Data of unit 1
    save(app.FileLoc+"\"+app.DataFileName_MU1.Value+".mat","MD_1"); % Save MD data
    
    MD_2=MD(2); % Save only the Measurement Data of unit 2
    save(app.FileLoc+"\"+app.DataFileName_MU2.Value+".mat","MD_2");
    
    MD_3=MD(3); % Save only the Measurement Data of unit 3
    save(app.FileLoc+"\"+app.DataFileName_MU3.Value+".mat","MD_3");
