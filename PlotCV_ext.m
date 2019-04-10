function MD=PlotCV_ext(app,C,V,plotAxis,MD,MUnb)
% PlotCV_ext
% Plots CV curves in the app
%
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI object
% C : float[n]
%   An array with the measured capacitance in F (as a function of the bias)
% V : float[n]
%   An array with the applied bias in V
% plotAxis : obj
%   A handle to the axis in the app designer where the data should be
%   plotted.
% MD : struct
%   A data structure that contains the experimental data results. Results
%   from the measurements will be appended to this structure.
% MUnb : int
%   The number of the selected measurement unit 1, 2 or 3
%
% Returns
% -------
% MD : struct
%   A data structure with the 

% Bias and temperature value to write axis legends
bias_value=MD(MUnb).ExpData.Setup.StressBiasValue;
temp_value=MD(MUnb).ExpData.Setup.TempH;

plot(plotAxis,V,C.*1e12,'LineWidth',2); %Plots regular C vs. V
plotAxis.Title.String = "Capacitance Vs. Voltage (Bias = "+bias_value+"V, T = "+temp_value+"C)";
plotAxis.YLabel.String = 'Capacitance (pF)';

% Log values
MD=logvalues_ext(app, MD);
end