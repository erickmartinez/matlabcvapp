function MD=logvalues_ext(app, MD, MUnb)
% Function to log temperature, time and current
stressBiasTime=MD(MUnb).ExpData.Setup.biastime_sec; % app.biastime is the bias time in seconds calculated in the beginning of startproc from app.dt_gnl, the
% user-defined time step, and from app.t_inc_unit_gnl, the time unit.
stressbiasstep=ceil(stressBiasTime/app.Itpoints.Value); % Length of time step between points for logging during stress
% app.Itpoints is the number of points T and I point to be taken during stress, defined by the user
% disp('stressbiasstep');disp(stressbiasstep);
Tstress=MD(MUnb).ExpData.Setup.TempH;
meas_flag=MD(MUnb).MDdata.meas_flag;

% Find parameters
Ttimestep=app.T_log_ramp_step.Value; % Timestep for temperature logging during ramping
% Find handles to temperature and current figures
switch MUnb
    case 1
        Itpanel=app.It_1;
        Tpanel=app.TempTime_1;
    case 2
        Itpanel=app.It_2;
        Tpanel=app.TempTime_2;
    case 3
        Itpanel=app.It_3;
        Tpanel=app.TempTime_3;
end

% Log temperature if temperature currently ramping up/down or equal to the
% cooling temperature (= lower  than the steady-state bias temperature)
TempTC = getTC(app,MUnb); % Get Temperature (C) on Measurement Unit MUnb
if(TempTC<Tstress) % If temperature is ramping up/down or equal to the cooling temperature
    if(toc-MD(MUnb).ExpData.log.Ttime(end)>=Ttimestep || MD(MUnb).ExpData.log.Ttime(end)==0) % if the time elapsed since last log is larger or equal to the user-defined timestep for temperature log, or if the first value is 0.
        TempTC = getTC(app,MUnb); % Record Temperature (C) on Measurement Unit MUnb
        Temp_t = toc; % Record time (s)
        MD(MUnb).ExpData.log.T = [MD(MUnb).ExpData.log.T, TempTC]; %Record temperature values for each MU
        MD(MUnb).ExpData.log.Ttime = [MD(MUnb).ExpData.log.Ttime, Temp_t]; %Record temperature time values for each MU
        % Plot
        plot(Tpanel,Temp_t/3600,TempTC,'-o','LineWidth',2,'Color',[1,.4,0]);
    end
end

clear TempTC
if(meas_flag==0 && toc-MD(MUnb).ExpData.log.Itime(end) < stressBiasTime) % If stressing is ongoing
    if(toc-MD(MUnb).ExpData.log.Itime(end)>=stressbiasstep) % If the time elapsed since the last log is larger than the log time interval
        % Log temperature
        TempTC = getTC(app,MUnb); % Get Temperature (C) on Measurement Unit MUnb
        Temp_t = toc; % Record time (s)
        MD(MUnb).ExpData.log.T = [MD(MUnb).ExpData.log.T, TempTC]; %Record temperature values for each MU
        MD(MUnb).ExpData.log.Ttime = [MD(MUnb).ExpData.log.Ttime, Temp_t]; %Record temperature time values for each MU
        % Log current
        I_time=toc; % Record time corresponding to the current value
        MD(MUnb).ExpData.log.I = [MD(1).ExpData.log.I, str2double(strsplit(query(app.HW(1).KEITH, ":READ?"),','))']; % Record current value from Keithley (always in MU 1 for all MUs, because same value for all MUs). HW(1).KEITH is the visa object.
        MD(MUnb).ExpData.log.Itime = [MD(1).ExpData.log.Itime, I_time]; % Record time (current is measured for all MUs and thus identical for each of them, but still record in each MU structure array)
        % Plot
        plot(Itpanel,ExpData.log.Itime/3600,MD(MUnb).ExpData.log.I,'ko-','LineWidth',2);
        
        % Log Keithley bias based on the state of the relays? (At the same time as
        % the current)
    end
end

