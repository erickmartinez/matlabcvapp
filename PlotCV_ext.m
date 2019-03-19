function MD=PlotCV_ext(app,C,V,Plot,MD,MUnb)
% Function to plot CV curves in the app

% Bias and temperature value to write axis legends
bias_value=MD(MUnb).ExpData.Setup.StressBiasValue;
temp_value=MD(MUnb).ExpData.Setup.TempH;

plot(Plot,V,C.*1e12,'LineWidth',2); %Plots regular C vs. V
Plot.Title.String = "Capacitance Vs. Voltage (Bias = "+bias_value+"V, T = "+temp_value+"C)";
Plot.YLabel.String = 'Capacitance (pF)';

TempTC = getTC(app,MUnb); % Record Temperature (C) on Measurement Unit MUnb
temp_t = toc; % Record time (s)

%% TO DEFINE IN STARTPROC
MD(1).Plots.Temp=app.TempTime_1; 
MD(2).Plots.Temp=app.TempTime_2;
MD(3).Plots.Temp=app.TempTime_3;
%%
hold(MD(MUnb).Plots.Temp,'on') % Handle to the temperature figure of the Measurement Unit number MUnb.
plot(MD(MUnb).Plots.Temp,temp_t/3600,TempTC,'-o','LineWidth',2,'Color',[1,.4,0]);

% Log values (CREATE A FUNCTION TO LOG VALUES)
MD(MUnb).ExpData.log.T = [MD(MUnb).ExpData.log.T, TempTC]; %Record temperature values for each MU
MD(MUnb).ExpData.log.Ttime = [MD(MUnb).ExpData.log.t, temp_t]; %Record temperature time values for each MU
% Log Keithley bias based on the state of the relays?
I_time=toc; % Record time corresponding to the current value
MD(1).ExpData.log.I = [MD(1).ExpData.log.I str2double(strsplit(query(HW(1).KEITH, ":READ?"),','))']; % Record current value from Keithley (always in MU 1 for all MUs, because same value for all MUs). HW(1).KEITH is the visa object.
MD(1).ExpData.log.Itime = [MD(1).ExpData.log.Itime I_time]; % Record time (always in MU 1 for all MUs, because current is measured for all MUs)