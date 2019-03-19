function MD=fcncallback_ext(app,MUnb,MD)
% Callback function to be executed every x seconds
% Arguments:
% app: The app designer 
% MUnb: The measurement unit (1,2,3)
% MD: A structure containing all the data
% Find parameters
% Need to store a variable that will indicate that all the measurements
% are completed, so that we can break the endless time loop
Arduino=app.HW(MUbn).Arduino;
stressBiasTime=MD(MUnb).MDdata.stressBiasTime;
ArdPins=MD(MUbn).ArdP; % Arduino pin numbers corresponding to the POGO pins
setCoolT=MD(HPnb).ExpData.Setup.TempC;
setStressT=MD(HPnb).ExpData.Setup.TempH;
PinState=MD(HPnb).PinState;
Err=MD(MUnb).MDdata.Err;
meas_flag=MD(MUnb).MDdata.meas_flag;
PreBias=MD(MUnb).ExpData.Setup.PreBias;
PreBiasTime=MD(MUnb).ExpData.Setup.PreBiasTime;
% etc
%% BIAS START? %% Check if biasing needs to be started %% This will become a function because needs to be called in RunIterCV
if(getTC(app,MUnb)<=setStressT+Err && getTc(app,nHP)>=setStressT-Err && meas_flag==1) % If the measurement temperature is reached and the measurement flag is 1 (measurement already performed)
    WriteDigitalPin(app.HW(MUnb).Arduino,'A0',0); % Normally closed position, Keithley connected
    % Turn on all pins if they have been activated by the user
    for p = 1:length(PinState) % Parse through all  pins
        if(PinState(p)) % If the pin has been activated by the user
            writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),1); % Set the pin to 1 , i.e. on
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
    % Add reading of the Keithley voltage MD(MUnb).ExpData.log.V(BvalLength+1) = % Read Keithley voltage
    I_time=toc; % Record time corresponding to the current value
    MD(1).ExpData.log.I = [MD(1).ExpData.log.I str2double(strsplit(query(HW(1).KEITH, ":READ?"),','))']; % Record current value from Keithley (always in MU 1 for all MUs, because same value for all MUs). HW(1).KEITH is the visa object.
    MD(1).ExpData.log.Itime = [MD(1).ExpData.log.Itime I_time]; % Record time (always in MU 1 for all MUs, because current is measured for all MUs)
    % Turn meas flag to 0 after the bias was started
    MD(MUnb).MDdata.meas_flag=0;
    % Record temperature and time?
end

%% STRESS COMPLETED? %% Check if stress has been completed to stop bias and start ramping down temperature
MD=stress_completed_ext(app, MD, MUnb);

%% TURN FAN OFF? %% Check if the fan can be turned off. Conditions: fan flag is on (=1) and cooling temperature has been reached. This will become a function because needs to be called in RunIterCV
if(getTc(app,MUnb)<=SetCoolT+Err && MD(MUnb).MDdata_fanflag==1)
    writeDigitalPin(Arduino,'D11',0); %Turn off Fan (verify pin number)
    pause(10); % Pause 10 s to let temperature stabilize after the fan has been turned off
    MD(MUnb).MDdata_fanflag=0; % Set fan flag to 0 after the fan has been turned off
end
%% START MEASUREMENT? %% Check if a measurement can be started
if(stress_status && getTC(app,MUnb)<=SetCoolT+Err && getTc(app,MUnb)>=SetCoolT-Err && meas_flag==0)
    % In case the fan is still on, turn it off
    if(MD(MUnb).MDdata_fanflag==1)
        writeDigitalPin(Arduino,'D11',0); %Turn off Fan (verify pin number)
        pause(10); % Pause 10 s to let temperature stabilize after the fan has been turned off
        MD(MUnb).MDdata_fanflag=0; % Set fan flag to 0 after the fan has been turned off
    end
    writeDigitalPin(Arduino,'A0',1) % Turn on the toggle switch board, ie connect to the impedance analyzer
    % Run the CV measurement (will measure all pins that were selected by the user)
    [th Ih] = RunIterCV(app,V,Prog_CV,PreBias,PreBiasTime,th,Ih,PinState,ArdP,LampSet,LampColor,CVPlots,PlotCVby2, MUnb) %Take iterative CV measurement
    % Start ramping up HP temperature after measurement and set meas_flag to 1 (cut and copy code from RunIterCV here)
    % After the measurement, all pins of the hotplate should be off. Then toggle relay to Keithley (to allow LCR measurements of another hotplate)
    writeDigitalPin(Arduino,'A0',0) % Turn off the toggle switch board, ie connect to the Keithley
    % Start ramping temperature of the hotplate to the stress temperature
    setHPTemp(app,app_HP,setStressT) %Turn off desired hotplate
    setHPTemp(app,app_HP,setStressT) %Turn on heating & set to stress temperature of desired hotplate
    MD(MUnb).MDdata.meas_flag=1; % Set flag to 1 after measurement completed
end
% End function