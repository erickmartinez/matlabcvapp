function [Cpr,Rpr,Vr] = RunProgCV_interface(IMPA,Prog) %Function to Run CV Progam/Measurement
% IMPA is the GPIB handle to the impedance analyzer
% Prog is the CV program

fprintf(IMPA,Prog); %Print/Send program to Impedance Analyzer
out=textscan(query(IMPA, 'RUN'),'%c %s %s %s %s %s %s %s','headerlines', 4); % Run Program and Wait for Data Output
fprintf(IMPA,"FNC2"); %Gain-Phase Function (Switches DC Bias Off, by Going to Different Measurement Mode)

unit = cell2mat(out{1,5}); %Analyzes unit factor from Impedance Anlyzer (IA) output
mult = []; %Set multiplication factor to null

for j=1:length(unit) %Parse through unit factor from output and define multiplacation factor array
    if (unit(j) == "f")
        mult = [mult 1e-15 ];
    elseif (unit(j) == "p")
        mult = [mult 1e-12 ];
    elseif (unit(j) == "n")
        mult = [mult 1e-9 ];
    elseif (unit(j) == "u")
        mult = [mult 1e-6 ];
    elseif (unit(j) == "m")
        mult = [mult 1e-3 ];
    end
end

Cpr =str2double(out{1,4}); %Copy out capacitance (C) double array from (IA) output
Cpr = Cpr(1:end-1).*mult'; %Multiplat C array with corresponding unit multiplication factor

Vr = str2double(out{1,3}); %Copy out voltatge (V) double array from (IA) output
Vr = Vr(1:end-1); %Remove character tail

Rpr =str2double(out{1,6})*1e3; %Copy out resistance (R) double array from (IA) output (mult to get ohms)
Rpr = Rpr(1:end-1); %Remove character tail
end