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
stressbiasTime=MD(MUnb).MDdata.stressbiasTime;
ArdPins=MD(MUbn).ArdP; % Arduino pin numbers corresponding to the POGO pins
setCoolT=MD(HPnb).ExpData.Setup.TempC;
setStressT=MD(HPnb).ExpData.Setup.TempH;
PinState=MD(HPnb).PinState;
Err=MD(MUnb).MDdata.Err;
meas_flag=MD(MUnb).MDdata.meas_flag;
PreBias=MD(MUnb).ExpData.Setup.PreBias;
PreBiasTime=MD(MUnb).ExpData.Setup.PreBiasTime;
% etc
%% BIAS START? %% Check if biasing needs to be started
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
    %  Record log values
    MD(MUnb).ExpData.log.t = MD(MUnb).MDdata.startbiastime(BtLength+1); % The time is the bias starting time
    MD(MUnb).ExpData.log.T = getTC(app,MUnb);
    BvalLength=length(MD(MUnb).ExpData.log.Vbias); % Length of the table containing the log bias values
    % Add reading of the Keithley voltage MD(MUnb).ExpData.log.V(BvalLength+1) = % Read Keithley voltage
    
    % Turn meas flag to 0 after the bias was started
    MD(MUnb).MDdata.meas_flag=0;
    % Record temperature and time?
end
%% STRESS COMPLETED? %% Check if stress has been completed to stop bias and start ramping down temperature
time_inc=toc-MD(MUnb).MDdata.startbiastime(end); % current time minus last recorded bias starting time for this measurement unit
if(time_inc>=stressbiasTime && getTc(app,MUnb)<=setStressT+3 && getTc(app,MUnb)>=setStressT-3) % Allow error of +/- 3 °C in temperature. Temperature condition to avoid turning on the fan if ramping has already started or if room T has been reached
    if(getTC(app,MUnb)<=SetCoolT+Err && getTc(app,MUnb)>=SetCoolT-Err)
        writeDigitalPin(Arduino,'D11',1); %Turn on Fan if current T is different from cooling T, ie case where stressing and cooling T identical (verify pin number).
    end
    MD(MUnb).MDdata_fanflag=1; % Set fan flag to 1 after the fan has been turned on
    % Stop hotplate
    setHPTemp(app, app.HP,setCoolT); % verify the name of HP1 cooling temperature. Need to define setCoolT_HP1 in the main.
    setHPTemp(app, app.HP,setCoolT);
    % stop bias (8 POGO pins)
    for p = 1:length(PinState) %Parse through all  pins
        writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),0); %Set all available pins to 0 or off
    end
end
%% TURN FAN OFF? %% Check if the fan can be turned off. Conditions: fan flag is on (=1) and cooling temperature has been reached
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