function MD=stress_completed_ext(app, MD, MUnb)
% Function checking whether bias can be stopped, temperature can be
% ramped down, and fan can be turned on

% Parameters
Arduino=app.HW(MUbn).Arduino;
biastime_sec=MD(mu).ExpData.Setup.biastime_sec;
StressT=MD(HPnb).ExpData.Setup.TempH;
CoolT=MD(HPnb).ExpData.Setup.TempC;
Err=MD(MUnb).MDdata.Err;

time_inc=toc-MD(MUnb).MDdata.startbiastime(end); % current time minus last recorded bias starting time for this measurement unit
if(time_inc>=biastime_sec && getTc(app,MUnb)<=StressT+3 && getTc(app,MUnb)>=setStressT-3) % Allow error of +/- 3 �C in temperature. Temperature condition to avoid turning on the fan if ramping has already started or if room T has been reached
    if(getTc(app,MUnb)>=CoolT+Err) % if T is larger than cool T, the fan will be turned on
        writeDigitalPin(Arduino,'D11',1); %Turn on Fan if current T is different from cooling T, ie case where stressing and cooling T identical (verify pin number).
        MD(MUnb).MDdata_fanflag=1; % Set fan flag to 1 after the fan has been turned on
    end
    MD(MUnb).MDdata.stress_completed_flag=1; % Set stress completed flag to 1
    % Stop hotplate
    setHPTemp(app, app.HW(MUnb).HP, MD(mu).ExpData.Setup.CalTempC); % Set hotplate temperature to the cool temperature, corrected using the calibration curve
    setHPTemp(app, app.HW(MUnb).HP, MD(mu).ExpData.Setup.CalTempC);
    % stop bias (8 POGO pins)
    for p = 1:length(PinState) %Parse through all  pins
        writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),0); %Set all available pins to 0 or off
    end
end