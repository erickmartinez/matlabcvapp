function MD=PlotCV_ext(app,C,V,Plot,MD,MUnb)
% Function to plot CV curves in the app

% Bias and temperature value to write axis legends
bias_value=MD(MUnb).ExpData.Setup.StressBiasValue;
temp_value=MD(MUnb).ExpData.Setup.TempH;

plot(Plot,V,C.*1e12,'LineWidth',2); %Plots regular C vs. V
Plot.Title.String = "Capacitance Vs. Voltage (Bias = "+bias_value+"V, T = "+temp_value+"C)";
Plot.YLabel.String = 'Capacitance (pF)';

% Log values
MD=logvalues_ext(app, MD);

%% TO DEFINE IN STARTPROC
MD(1).Plots.Temp=app.TempTime_1; 
MD(2).Plots.Temp=app.TempTime_2;
MD(3).Plots.Temp=app.TempTime_3;
%%
hold(MD(MUnb).Plots.Temp,'on') % Handle to the temperature figure of the Measurement Unit number MUnb.
plot(MD(MUnb).Plots.Temp,temp_t/3600,TempTC,'-o','LineWidth',2,'Color',[1,.4,0]);