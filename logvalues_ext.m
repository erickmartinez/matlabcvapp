function MD=logvalues_ext(app, MD, MUnb)
% Function to log temperature, time and current
stressBiasTime=app.biastime;
% app.biastime is the bias time in seconds calculated in the beginning of startproc from app.dt_gnl, the
% user-defined time step, and from app.t_inc_unit_gnl, the time unit.
stressbiasstep=ceil(stressBiasTime/app.Itpoints); % Number of steps for logging during stress
% app.Itpoints is the number of points T and I point to be taken during stress, defined by the user

% Find parameters
Ttimestep=app.T_log_ramp_step; % Timestep for temperature logging during ramping


% Log temperature if temperature currently ramping up or equal to the cooling temperature?
if(t<Tstress) % If temperature is ramping up/down or equal to the cooling temperature
    if(toc-MD(MUnb).ExpData.log.Ttime(end)>=Ttimestep) % if the time elapsed since last log is larger or equal to the user-defined timestep for temperature logj
        TempTC = getTC(app,MUnb); % Record Temperature (C) on Measurement Unit MUnb
        Temp_t = toc; % Record time (s)
        MD(MUnb).ExpData.log.T = [MD(MUnb).ExpData.log.T, TempTC]; %Record temperature values for each MU
        MD(MUnb).ExpData.log.Ttime = [MD(MUnb).ExpData.log.t, Temp_t]; %Record temperature time values for each MU
    end
end

if(meas_flag==0 && toc-MD(MUnb).ExpData.log.Itime(end) < stressBiasTime) % If stressing is ongoing
    if(toc-MD(MUnb).ExpData.log.Itime(end)>=stressbiasstep) % If the time elapsed since the last log is larger than the log time interval
        % Log temperature
        TempTC = getTC(app,MUnb); % Record Temperature (C) on Measurement Unit MUnb
        Temp_t = toc; % Record time (s)
        MD(MUnb).ExpData.log.T = [MD(MUnb).ExpData.log.T, TempTC]; %Record temperature values for each MU
        MD(MUnb).ExpData.log.Ttime = [MD(MUnb).ExpData.log.t, Temp_t]; %Record temperature time values for each MU
        % Log current
        I_time=toc; % Record time corresponding to the current value
        MD(1).ExpData.log.I = [MD(1).ExpData.log.I str2double(strsplit(query(HW(1).KEITH, ":READ?"),','))']; % Record current value from Keithley (always in MU 1 for all MUs, because same value for all MUs). HW(1).KEITH is the visa object.
        MD(1).ExpData.log.Itime = [MD(1).ExpData.log.Itime I_time]; % Record time (always in MU 1 for all MUs, because current is measured for all MUs)
        % Log Keithley bias based on the state of the relays? (At the same time as
        % the current)
    end
end

