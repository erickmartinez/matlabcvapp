function MD=fanoff_ext(app, MD, MUnb)
% Function checking if fan is ready to be turned off

CoolT=MD(MUnb).ExpData.Setup.TempC;
% Err=MD(MUnb).MDdata.Err;
% Arduino=app.HW(MUnb).Arduino;
temp=getTC(app,MUnb);
if(temp<=CoolT && MD(MUnb).MDdata_fanflag==1)
    % writeDigitalPin(Arduino,'A1',0); %Turn off Fan
    arduinoTurnFanOff(app,MUnb);
    message=['Turning off fan in fanoff_ext, MU number ',num2str(MUnb),'. Temperature: ',num2str(temp)];
    logMessage(app,message);
    pause(10); % Pause 10 s to let temperature stabilize after the fan has been turned off
    MD(MUnb).MDdata_fanflag=0; % Set fan flag to 0 after the fan has been turned off
end

% clear Arduino