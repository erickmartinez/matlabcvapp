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