% testCV_HP3
% Script used to take CV measurement on hotplate 3 to test the capacitors

instrreset
com='COM6'; % Arduino 3
% com='COM7'; % Arduino 2
% com='COM8'; % Arduino 1
% ArdP=linspace(2,9,8); % Contains the Arduino pin numbers corresponding to each POGO pin
ArdP=[2,3,4,5,6,7,8,9];
% ArdP=7;
delete(instrfind({'Port'},{com}))
Arduino = arduino(char(com),'Uno','Libraries','SPI'); % Initialize Arduino

% Open GPIB connection to impedance analyzer
IMPA = gpib('KEYSIGHT',7,17); %Define visa object to Impedance Analyzer
set(IMPA, 'InputBufferSize', 64*1024); %Set data buffer size (important to read out all CV data)
set(IMPA,'Timeout',120); %Set timeout
fopen(IMPA); %Open visa

%Define CV program to be read in by Impedance Analyzer
Prog_CV = "PROG"...
    + "'10 FNC1'," ... %Impedance Measurement
    + "'20 SWM2'," ... % Single Mode Sweep
    + "'30 IMP5'," ... % Cs-Rs Circuit
    + "'40 SWP2'," ... % DC Bias Sweep
    + "'50 SWD2'," ... % Sweep Direction
    + "'60 ITM2'," ... % Integration Time
    + "'70 NOA=1'," ... % # of Averages
    + "'80 OSC=0.1;FREQ=1000000'," ... % AC Amplitude (V) & Frequency
    + "'90 START=-12;STOP=4'," ... %Starting Negative & Positive Volgates
    + "'100 STEP=0.05'," ... %DC Sweep Step Magnitude (V)
    + "'110 DTIME=0'," ... % Measurement Delay Time Set to 0 (No Delay)
    + "'120 SHT1'," ... % Short Calibration Set to On
    + "'130 OPN1'," ... % Open Calibration Set to On
    + "'140 AUTO'," ... % Auto-Scale A & B
    + "'150 CPYM2'," ... % Copy Data Mode 2
    + "'160 SWTRG'," ... % Single Trigger Run
    + "'170 COPY'," ... % Copy Data to Instrument
    + "'180 DCOFF'," ... % Doesn't work, but attempt to turn off DC bias
    + "'190 END'";

% Correct CV program:
% Prog_CV = "PROG'10 FNC1','20 SWM2','30 IMP5','40 SWP2','50 SWD2','60 ITM2','70 NOA=2','80 OSC=0.1;FREQ=1000000','90 START=-7;STOP=7','100 STEP=0.1','110 DTIME=0','120 SHT1','130 OPN1','140 AUTO','150 CPYM2','160 SWTRG','170 COPY','180 DCOFF','190 END'"


% Close switch to impedance analyzer connection (the analyzer is in
% normally open position, which becomes closed when setting the Arduino pin
% to low voltage)
writeDigitalPin(Arduino,'A0',0);

% Measure CV for each pin
% figure
figure
for p=1:length(ArdP)
    writeDigitalPin(Arduino,char("D"+num2str(ArdP(p))),1); %Turn on desired pogo-pin
    [Cmeas, Rmeas, Vmeas] = RunProgCV_interface(IMPA, Prog_CV); %Run CV measurement
    %     subplot(1,size(Ardp),p)
    subplot(2,4,p)
    plot(Vmeas,Cmeas*1e12)
    ylabel('Capacitance (pF)');
    xlabel('Voltage (V)');
    legend_txt="Pin"+num2str(p);
    legend(legend_txt);
end

fclose(IMPA);
clear all
instrreset