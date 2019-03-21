function MD=logvalues_ext(app, MD)
% Function to log temperature, time and current
% CHECK IF THAT MAKES SENSE AND IF TEMPERATURE AND CURRENT WILL ALWAYS BE
% LOGGED AT THE SAME TIME

TempTC = getTC(app,MUnb); % Record Temperature (C) on Measurement Unit MUnb
temp_t = toc; % Record time (s)
MD(MUnb).ExpData.log.T = [MD(MUnb).ExpData.log.T, TempTC]; %Record temperature values for each MU
MD(MUnb).ExpData.log.Ttime = [MD(MUnb).ExpData.log.t, temp_t]; %Record temperature time values for each MU
% Log Keithley bias based on the state of the relays?
I_time=toc; % Record time corresponding to the current value
MD(1).ExpData.log.I = [MD(1).ExpData.log.I str2double(strsplit(query(HW(1).KEITH, ":READ?"),','))']; % Record current value from Keithley (always in MU 1 for all MUs, because same value for all MUs). HW(1).KEITH is the visa object.
MD(1).ExpData.log.Itime = [MD(1).ExpData.log.Itime I_time]; % Record time (always in MU 1 for all MUs, because current is measured for all MUs)