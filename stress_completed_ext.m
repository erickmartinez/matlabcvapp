function MD=stress_completed_ext(app, MD, MUnb)
% Function checking whether bias can be stopped, temperature can be
% ramped down, and fan can be turned on

% Parameters
Arduino=app.HW(MUnb).Arduino;
biastime_sec=MD(MUnb).ExpData.Setup.biastime_sec;
StressT=MD(MUnb).ExpData.Setup.TempH;
CoolT=MD(MUnb).ExpData.Setup.TempC;
Err=MD(MUnb).MDdata.Err;
PinState=MD(MUnb).PinState;
ArdPins=MD(MUnb).ArdP;

time_inc=toc-MD(MUnb).MDdata.startbiastime(end); % current time minus last recorded bias starting time for this measurement unit
Temp=getTC(app,MUnb);
if(time_inc>=biastime_sec && Temp<=StressT+Err && Temp>= StressT-Err && MD(MUnb).MDdata.bias_on_flag) % Allow error of +/- 3 °C in temperature. Temperature condition to avoid turning on the fan if ramping has already started or if room T has been reached  NOTE: temperature check here not necessary, might prevent running this code if temperature is out of range for some reason
    if(getTC(app,MUnb)>=CoolT+Err) % if T is larger than cool T, the fan will be turned on
        %writeDigitalPin(Arduino,'A1',1); %Turn on Fan if current T is different from cooling T, ie case where stressing and cooling T identical (verify pin number).
        arduinoTurnFanOn(app,MUnb);
        MD(MUnb).MDdata_fanflag=1; % Set fan flag to 1 after the fan has been turned on
    end
    message_endstress=sprintf('Stopping bias and cooling HP on unit %d', MUnb);
    logMessage(app,message_endstress);
    MD(MUnb).MDdata.stress_completed_flag=1; % Set stress completed flag to 1
    % Stop hotplate
    setHotPlateTemperature(app, MD, MUnb, MD(MUnb).ExpData.Setup.CalTempC); % Set hotplate temperature to the cool temperature, corrected using the calibration curve
%     setHotPlateTemperature(app, MD, MUnb, MD(MUnb).ExpData.Setup.CalTempC); 
    % stop bias (8 POGO pins)
    for p = 1:length(PinState) %Parse through all  pins
        % writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),0); %Set all available pins to 0 or off
        arduinoTurnPinOff(app,MUnb,ArdPins(p));
    end
	% Log the time at which the stress bias was completed
	timeCompleted = toc;
	MD(MUnb).ExpData.log.endBiasTime = [MD(MUnb).ExpData.log.endBiasTime, ...
        timeCompleted];
    MD(MUnb).MDdata.bias_on_flag=0; % Set flag to 0 after bias has been turned off
end

clear Arduino
end