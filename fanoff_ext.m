function MD=fanoff_ext(app, MD, MUnb)
% Function checking if fan is ready to be turned off

if(getTc(app,MUnb)<=SetCoolT+Err && MD(MUnb).MDdata_fanflag==1)
    writeDigitalPin(Arduino,'A1',0); %Turn off Fan (verify pin number)
    pause(10); % Pause 10 s to let temperature stabilize after the fan has been turned off
    MD(MUnb).MDdata_fanflag=0; % Set fan flag to 0 after the fan has been turned off
end