% function [I t TempTC temp_t] = RunBias_ext(app, Vstress,tIstress,tstep,th,Ih,PinState,ArdP,LampSet,LampColor,IsPreBias,PreBiasPin)
function MD = RunBias_ext(app, MD, MUnb, IsPreBias, PreBiasPin)
ArdPins=MD(MUnb).ArdP;
PinState=MD(MUnb).PinState;
setStressT=MD(MUnb).ExpData.Setup.TempH;
Err=MD(MUnb).MDdata.Err;
meas_flag=MD(MUnb).MDdata.meas_flag;

if(IsPreBias) % IF PREBIAS STEP
    for p = 1:length(PinState) %Parse through all  pins
        writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdinsP(p))),0); %Set all abailable pins to 0 or off (although should already be)
    end
    writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdPins(PreBiasPin))),1); %Set PreBias pin to 1 or on
    % Bias for the prebias time
    PreBiasTime=MD(MUnb).ExpData.Setup.PreBiasTime;
    writeDigitalPin(app.HW(MUnb).Arduino,'A0',1); % Normally closed position, Keithley connected and biasing the pin which is on
    biasstart=toc;
    while(toc-biasstart<PreBiasTime)
        pause(0.5);        
    end
    writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdPins(PreBiasPin))),0); % turn off prebias pin 
    
else % IF REGULAR STRESS STEP
    Temp=getTC(app,MUnb);
    if(Temp<=setStressT+Err && Temp>=setStressT-Err && meas_flag==1) % If the measurement temperature is reached and the measurement flag is 1 (measurement already performed)
        message_bias=['Starting bias in Runbias_ext on MU ',num2str(MUnb)];
        disp(message_bias);
        
        writeDigitalPin(app.HW(MUnb).Arduino,'A0',1); % Normally closed position, Keithley connected
        % Turn fan off if on
        if(MD(MUnb).MDdata_fanflag==1)
            writeDigitalPin(app.HW(MUnb).Arduino,'A1',0); %Turn off Fan
            message=['Turning off fan in Runbias_ext, MU number ',num2str(MUnb),'. Temperature: ',num2str(Temp)];
            disp(message);
            pause(10); % Pause 10 s to let temperature stabilize after the fan has been turned off
            MD(MUnb).MDdata_fanflag=0; % Set fan flag to 0 after the fan has been turned off
        end
        % Turn on all pins if they have been activated by the user
        for p = 1:length(PinState) % Parse through all  pins
            if(PinState(p)) % If the pin has been activated by the user
                writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdPins(p))),1); % Set the pin to 1
            end
        end
        % Record bias starting time
        BtLength=length(MD(MUnb).MDdata.startbiastime); % Current length of the table containing bias starting time for each cycle
        MD(MUnb).MDdata.startbiastime(BtLength+1)=toc; % Add the bias starting time for the current cycle
        MD(MUnb).MDdata.meas_flag=0; % Set meas flag to 0 after bias has been started
        MD(MUnb).MDdata.cycle_counter=MD(MUnb).MDdata.cycle_counter+1; % Increase the loop counter by one
        MD=logvalues_ext(app, MD, MUnb);% log T and I values
    end
end

% End of RunBias function