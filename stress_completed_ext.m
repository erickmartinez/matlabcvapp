function MD=stress_completed_ext(app, MD, MUnb)
% Function checking whether bias can be stopped, temperature can be
% ramped down, and fan can be turned on

% Parameters
Arduino=app.HW(MUbn).Arduino;
stressBiasTime=MD(MUnb).MDdata.stressBiasTime;
setStressT=MD(HPnb).ExpData.Setup.TempH;
setCoolT=MD(HPnb).ExpData.Setup.TempC;
Err=MD(MUnb).MDdata.Err;

time_inc=toc-MD(MUnb).MDdata.startbiastime(end); % current time minus last recorded bias starting time for this measurement unit
if(time_inc>=stressBiasTime && getTc(app,MUnb)<=setStressT+3 && getTc(app,MUnb)>=setStressT-3) % Allow error of +/- 3 °C in temperature. Temperature condition to avoid turning on the fan if ramping has already started or if room T has been reached
    if(getTC(app,MUnb)<=SetCoolT+Err && getTc(app,MUnb)>=SetCoolT-Err)
        writeDigitalPin(Arduino,'D11',1); %Turn on Fan if current T is different from cooling T, ie case where stressing and cooling T identical (verify pin number).
    end
    MD(MUnb).MDdata_fanflag=1; % Set fan flag to 1 after the fan has been turned on
    % Stop hotplate
    setHPTemp(app, app.HW(MUnb).HP, setCoolT); % verify the name of HP1 cooling temperature. Need to define setCoolT in the main.
    setHPTemp(app, app.HW(MUnb).HP, setCoolT);
    % stop bias (8 POGO pins)
    for p = 1:length(PinState) %Parse through all  pins
        writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),0); %Set all available pins to 0 or off
    end
end