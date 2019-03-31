function MD=fcncallback_ext(app,MUnb,MD,CVProgram)
% Callback function to be executed every x seconds and run each sequence of
% the measurement on all hotplates
% Arguments:
% app: The app designer 
% MUnb: The measurement unit (1,2,3)
% MD: A structure containing all the data
% Find parameters
% Need to store a variable that will indicate that all the measurements
% are completed, so that we can break the endless time loop
Arduino=app.HW(MUbn).Arduino;
stressBiasTime_sec=MD(MUnb).MDdata.dtime; % dtime is the stress bias time converted in seconds (in startproc)
ArdPins=MD(MUbn).ArdP; % Arduino pin numbers corresponding to the POGO pins
setCoolT=MD(HPnb).ExpData.Setup.TempC;
setStressT=MD(HPnb).ExpData.Setup.TempH;
PinState=MD(HPnb).PinState;
Err=MD(MUnb).MDdata.Err;
meas_flag=MD(MUnb).MDdata.meas_flag;
PreBias=MD(MUnb).ExpData.Setup.PreBias;
PreBiasTime=MD(MUnb).ExpData.Setup.PreBiasTime;
% etc
%% BIAS START? %% Check if biasing needs to be started. Bias starts if meas_flag=1 and stress temp has been reached
MD=RunBias_ext(app, MD, MUnb, 0, 9); % 0 because no prebias, pin number set to any number, here 9, as not used

%% STRESS COMPLETED? %% Check if stress has been completed to stop bias and start ramping down temperature. Conditions: time elapsed since last log is larger than the step and T is still at stressing temperature
MD=stress_completed_ext(app, MD, MUnb);

%% TURN FAN OFF? %% Check if the fan can be turned off. Conditions: fan flag is on (=1) and cooling temperature has been reached.
MD=fanoff_ext(app, MD, MUnb);

% Should we add a function to turn fan on in case the temperature
% overshoots?

%% START MEASUREMENT? %% Check if a measurement can be started.
% If both bias and measurement are performed at room temperature, a
% measurement would start before the end of the bias step unless a
% condition is set on the time elapsed since biasstarttime.
time_inc=toc-MD(MUnb).MDdata.startbiastime(end); % current time minus last recorded bias starting time for this measurement unit
if(getTC(app,MUnb)<=SetCoolT+Err && getTc(app,MUnb)>=SetCoolT-Err && meas_flag==0) % What if both bias and measurement are performed at room temperature? add a stress completed flag
    if(time_inc>=stressBiasTime_sec || MD(MUnb).MDdata.startbiastime(end)==0) % For the first measurement, startbiastime is set to 0 for initialization
        % In case the fan is still on, turn it off
        if(MD(MUnb).MDdata_fanflag==1)
            writeDigitalPin(Arduino,'D11',0); %Turn off Fan (verify pin number)
            pause(10); % Pause 10 s to let temperature stabilize after the fan has been turned off
            MD(MUnb).MDdata_fanflag=0; % Set fan flag to 0 after the fan has been turned off
        end
        writeDigitalPin(Arduino,'A0',1) % Turn on the toggle switch board, ie connect to the impedance analyzer
        % Run the CV measurement (will measure all pins that were selected by the user)
        MD = RunIterCV(app,CVprogram,LampSet,LampColor,MUnb,MD); %Take iterative CV measurement
        % Start ramping up HP temperature after measurement and set meas_flag to 1 (cut and copy code from RunIterCV here)
        % After the measurement, all pins of the hotplate should be off. Then toggle relay to Keithley (to allow LCR measurements of another hotplate)
        
        writeDigitalPin(Arduino,'A0',0) % Turn off the toggle switch board, ie connect to the Keithley
        % Start ramping temperature of the hotplate to the stress temperature
        setHPTemp(app,app_HP,setStressT) %Turn off desired hotplate
        setHPTemp(app,app_HP,setStressT) %Turn on heating & set to stress temperature of desired hotplate
        MD(MUnb).MDdata.meas_flag=1; % Set flag to 1 after measurement completed
    end
end

%% Log values
MD=logvalues_ext(app, MD, MUnb);

%% Save data
saveMDdata(app, MD, MUnb);

% End function