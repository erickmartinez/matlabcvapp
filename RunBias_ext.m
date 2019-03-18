function [I t TempTC temp_t] = RunBias_ext(app, Vstress,tIstress,tstep,th,Ih,PinState,ArdP,LampSet,LampColor,IsPreBias,PreBiasPin)

writeDigitalPin(app.Arduino,'D2',0) %Turn off relay switches to Impedance Analyzer (IA)
for p = 1:length(PinState) %Parse through all  pins
    writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),0); %Set all abailable pins to 0 or off
end
if(IsPreBias) %If prebias step
    writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(PreBiasPin))),1); %Set PreBias pin to 1 or on
else %If regular stress step
    for p = 1:length(PinState) %Parse through all available pins
        if(PinState(p)) %if pin is available
            writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),1); %Set all preselected experimental pins to 1
        end
    end
end
delete(instrfind('Name','VISA-GPIB0-25')) %Delete visa object to Keithley 2401 (K2401) if found
k=visa('agilent', 'GPIB0::25::INSTR'); %Define visa connection to K2401
set(k, 'InputBufferSize', 64*1024); %Set data buffer size (important to read out all current data)
fopen(k) %Open visa object
set(k,'Timeout',10); %Set timeout

fprintf(k, '*RST') %Reset K2401
fprintf(k, ":OUTP:SMOD HIMP") %%Sets High Impedance Mode

fprintf(k, ':ROUT:TERM REAR') %Set I/O to Rear Connectors
fprintf(k, ':SENS:FUNC:CONC OFF') %Turn Off Concurrent Functions
fprintf(k, ':SOUR:FUNC VOLT') %Voltage Source Function

fprintf(k, ":SENSE:FUNC 'CURR:DC'") %DC Current Sense Function
fprintf(k, ":SENSE:CURR:PROT .105") %Set Compliance Current to 105 mA

fprintf(k, ":SOUR:VOLT "+Vstress) %Source Bias Voltage
fprintf(k, ':SOUR:VOLT:MODE FIX') %Set Voltage Source Sweep Mode
fprintf(k, ":SOUR:DEL .1") %100ms Source Delay

fprintf(k, ":FORM:ELEM CURR") %Select Data Collecting Item Current
fprintf(k, ":OUTP ON") %Turn On Source Output

t=[];
tcurr = [];
I = [];

for j = 1:tstep:tIstress %For every timestep until maximum stress time
    pause(tstep-0.327592); %Pause for timestep duration during high bias
    I = [I str2double(strsplit(query(k, ":READ?"),','))']; %Trigger Measurement, Request Data After Timestep Wait
    tcurr = [tcurr toc]; %Increment time for current array
    temp_t = toc;
    TempTC = getTC(app); %Get thrmocouple temperature
    
    plot(app.It_1,tcurr/3600,I,'ko-','LineWidth',2) %Add History of Time & Plot Current Vs. Time
    plot(app.TempTime_1,temp_t/3600,TempTC,'-o','LineWidth',2,'Color',[1,.4,0]) %Plot/Update thermocouple temperature vs time
end
t = tcurr;
fprintf(k, ":OUTP OFF") %Turn Off Source Output
delete(k) %Delete K2401 Object
clear k %Cleare K2401 Object from Workspace

for p = 1:length(PinState) %Turn off all available pins
    writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),0); %Set all pins to 0 or off
end
% End of RunBias function