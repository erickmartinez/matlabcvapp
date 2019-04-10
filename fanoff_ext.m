function MD=fanoff_ext(app, MD, MUnb)
% Function checking if fan is ready to be turned off

CoolT=MD(MUnb).ExpData.Setup.TempC;
Err=MD(MUnb).MDdata.Err;
Arduino=app.HW(MUnb).Arduino;

if(getTC(app,MUnb)<=CoolT+Err && MD(MUnb).MDdata_fanflag==1)
    writeDigitalPin(Arduino,'A1',0); %Turn off Fan
    pause(10); % Pause 10 s to let temperature stabilize after the fan has been turned off
    MD(MUnb).MDdata_fanflag=0; % Set fan flag to 0 after the fan has been turned off
end

clear Arduino