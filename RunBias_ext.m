% function [I t TempTC temp_t] = RunBias_ext(app, Vstress,tIstress,tstep,th,Ih,PinState,ArdP,LampSet,LampColor,IsPreBias,PreBiasPin)
function MD = RunBias_ext(app, MD, MUnb, IsPreBias, PreBiasPin)
ArdPins=MD(MUbn).ArdP;
PinState=MD(HPnb).PinState;
setStressT=MD(HPnb).ExpData.Setup.TempH;

if(IsPreBias) % IF PREBIAS STEP
    for p = 1:length(PinState) %Parse through all  pins
        writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdinsP(p))),0); %Set all abailable pins to 0 or off (although should already be)
    end
    writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdPins(PreBiasPin))),1); %Set PreBias pin to 1 or on
    % Bias for the prebias time
    PreBiasTime=MD(MUnb).ExpData.Setup.PreBiasTime;
    writeDigitalPin(app.HW(MUnb).Arduino,'A0',0); % Normally closed position, Keithley connected and biasing the pin which is on
    biasstart=toc;
    while(toc-biasstart<PreBiasTime)
        pause(0.5);        
    end
    writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdPins(PreBiasPin))),0); % turn off prebias pin 
    
else % IF REGULAR STRESS STEP
    if(getTC(app,MUnb)<=setStressT+Err && getTc(app,MUnb)>=setStressT-Err && meas_flag==1) % If the measurement temperature is reached and the measurement flag is 1 (measurement already performed)
        writeDigitalPin(app.HW(MUnb).Arduino,'A0',0); % Normally closed position, Keithley connected
        % Turn on all pins if they have been activated by the user
        for p = 1:length(PinState) % Parse through all  pins
            if(PinState(p)) % If the pin has been activated by the user
                writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdPins(p))),1); % Set the pin to 1
            end
        end
        % Record bias starting time
        BtLength=length(MD(MUnb).MDdata.startbiastime); % Current length of the table containing bias starting time for each cycle
        MD(MUnb).MDdata.startbiastime(BtLength+1)=toc; % Add the bias starting time for the current cycle
        %  Record log values (CREATE A FUNCTION TO RECORD THE LOGGED VALUES,
        %  BASED ON PLOTCV_EXT)
        MD(MUnb).ExpData.log.T = [MD(MUnb).ExpData.log.T, TempTC]; %Record temperature values for each MU
        MD(MUnb).ExpData.log.Ttime = [MD(MUnb).ExpData.log.t, temp_t]; %Record temperature time values for each MU
        BvalLength=length(MD(MUnb).ExpData.log.Vbias); % Length of the table containing the log bias values
        % Add Keithley voltage MD(MUnb).ExpData.log.V(BvalLength+1) = % Add
        % user input value here
        I_time=toc; % Record time corresponding to the current value
        MD(1).ExpData.log.I = [MD(1).ExpData.log.I str2double(strsplit(query(HW(1).KEITH, ":READ?"),','))']; % Record current value from Keithley (always in MU 1 for all MUs, because same value for all MUs). HW(1).KEITH is the visa object.
        MD(1).ExpData.log.Itime = [MD(1).ExpData.log.Itime I_time]; % Record time (always in MU 1 for all MUs, because current is measured for all MUs)
        % Turn meas flag to 0 after the bias was started
        MD(MUnb).MDdata.meas_flag=0;
        % Record temperature and time?
    end
end

%% MOVE THIS PART TO THE INSTRUMENT INITIALIZATION FUNCTION
delete(instrfind('Name','VISA-GPIB0-25')) %Delete visa object to Keithley 2401 (K2401) if found
k=visa('agilent', 'GPIB0::25::INSTR'); %Define visa connection to K2401
set(k, 'InputBufferSize', 64*1024); %Set data buffer size (important to read out all current data)
fopen(k) %Open visa object
set(k,'Timeout',10); %Set timeout

%% MOVE THIS PART TO STARTPROC
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

fprintf(k, ":FORM:ELEM CURR") %Select Data Collecting Item Current (FORMAT CURRENT, see short-form rule p.338 Keithley 2400.). Remove to also read voltage?
fprintf(k, ":OUTP ON") %Turn On Source Output % In startproc, make sure all pins are off by default to avoid biasing device when startproc is pushed

t=[];
tcurr = [];
I = [];

%% MOVE THIS PART TO FCNCALLBACK
for j = 1:tstep:tIstress %For every timestep until maximum stress time
    pause(tstep-0.327592); %Pause for timestep duration during high bias
    I = [I str2double(strsplit(query(k, ":READ?"),','))']; %Trigger Measurement, Request Data After Timestep Wait
    tcurr = [tcurr toc]; %Increment time for current array
    temp_t = toc;
    TempTC = getTC(app); %Get thermocouple temperature
    
    plot(app.It_1,tcurr/3600,I,'ko-','LineWidth',2) %Add History of Time & Plot Current Vs. Time
    plot(app.TempTime_1,temp_t/3600,TempTC,'-o','LineWidth',2,'Color',[1,.4,0]) %Plot/Update thermocouple temperature vs time
end
t = tcurr;

%% MOVE THIS PART TO THE FUNCTION CLOSING ALL INSTRUMENTS
fprintf(k, ":OUTP OFF") %Turn Off Source Output
delete(k) %Delete K2401 Object
clear k %Cleare K2401 Object from Workspace

%% MOVE THIS PART TO THE INFINITE LOOP, WHEN THE PROGRAM ENDS
for p = 1:length(PinState) %Turn off all available pins
    writeDigitalPin(app.Arduino,char("D"+num2str(ArdPins(p))),0); %Set all pins to 0 or off
end
% End of RunBias function