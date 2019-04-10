% function [I t TempTC temp_t] = RunBias_ext(app, Vstress,tIstress,tstep,th,Ih,PinState,ArdP,LampSet,LampColor,IsPreBias,PreBiasPin)
function MD = RunBias_ext(app, MD, MUnb, IsPreBias, PreBiasPin)
ArdPins=MD(MUnb).ArdP;
PinState=MD(MUnb).PinState;
setStressT=MD(MUnb).ExpData.Setup.TempH;
Err=MD(MUnb).MDdata.Err;

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
    if(getTC(app,MUnb)<=setStressT+Err && getTC(app,MUnb)>=setStressT-Err && meas_flag==1) % If the measurement temperature is reached and the measurement flag is 1 (measurement already performed)
        writeDigitalPin(app.HW(MUnb).Arduino,'A0',1); % Normally closed position, Keithley connected
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
        
        MD=logvalues_ext(app, MD, MUnb);% log T and I values
    end
end

% End of RunBias function