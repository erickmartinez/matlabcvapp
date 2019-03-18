function [th Ih] = RunIterCV_ext(app,V,CVprogram,PreBias_1,PreBiasTime_1,th,Ih,PinState,ArdP,LampSet,LampColor,CVPlots,PlotCVby2,MUnb) % Run Iterative CV Measurement
% Find parameters
Arduino=app.HW(MUbn).Arduino;
setbiastime=MD(MUnb).MDdata.setbiastime;
ArdPins=MD(MUbn).ArdP; % Arduino pin numbers corresponding to the POGO pins
setCoolT=MD(HPnb).ExpData.Setup.TempC;
setStressT=MD(HPnb).ExpData.Setup.TempH;
PinState=MD(HPnb).PinState;
Err=MD(MUnb).MDdata.Err;
meas_flag=MD(MUnb).MDdata.meas_flag;
PreBias=MD(MUnb).ExpData.Setup.PreBias;
PreBiasTime=MD(MUnb).ExpData.Setup.PreBiasTime;
IterM = MD(MUnb).ExpData.Setup.IterM ; %Amount of repeated measurements per stress iteration
for p = 1:length(PinState) %For each pin
    for j = 1:IterM %For each repeated measure
        if(PinState(p)) %If pin is available
            writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),0) %Turn off desired pogo-pin
            if(app.PreBiasTime_1.Value ~= 0) %If there is a prebias
                % TO DO: Modify RunBias function
                [I_temp t_temp TC_temp TC_time_temp] = RunBias(app, PreBias_1,PreBiasTime_1*60,(PreBiasTime*60)/2,th,Ih,PinState,ArdP,LampSet,LampColor,1,p) %Run prebias on pin % To change because rusBias will be modified. Only toggle the switch for a given amount of time .
                % TO DO: find when to log data
                app.TC = [TC_temp app.TC]; %Record temperature values
                app.TC_time = [TC_time_temp app.TC_time]; %Record temperature time values
                Ih = [Ih I_temp]; %Record current values
                th = [th t_temp]; %Record current time values
                hold(app.It_1,'on')
            end
            WriteDigitalPin(app.HW(MUnb).Arduino,'A0',1); % Connect impedance analyzer and disconnect Keithley
            writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),1); %Turn on desired pogo-pin
            % LampSet(p) = LampColor(p); %Turn on pin lamp
            [Cmeas, Rmeas, ~] = RunProgCV(app, CVprogram); %Run CV measurement
            % Preallocate the structures at the beginning based on the max number of iterations
            MD(MUnb).ExpData.Pin(p).C = [MD(MUnb).ExpData.Pin(p).C Cmeas]; %Save capacitance data in pin struct
            MD(MUnb).ExpData.Pin(p).R = [MD(MUnb).ExpData.Pin(p).R Rmeas]; %Save resistance data in pin struct
            MD(MUnb).ExpData.Pin(p).V = [MD(MUnb).ExpData.Pin(p).V  V']; %Save voltage data in pin struct
            % TO DO: make sure the curves are plotted in the correct CV window. CVPlots are defined at the beginning of StartProc. app.CV1_3, app.CV2_3, app.CV3_3, app.CV4_3, app.CV5_3 for MU3.
            PlotCV(app,app.P(p).C,app.P(p).V,CVPlots(p)); %Plot CV curve
        end
        
        % here add the isstresscompleted function to turn off (or on?) the other hotplates if needed.
        % After each pin has been measured, check if all hotplates have been held at the target temperature for the set step duration. If one of them has, turn them off and let them wait.
        % Also check if the temperature has reached room temperature
        for MUnb=1:3
            [stress_status]=isstresscompleted(app,iHP,HPdata); % is any hotplate ready to stop stressing?
            % Is any hotplate ready to stop temperature rampup?
            %%% code here
            % Is any hotplate ready to stop temperature cool down (ie turn off the fan)?
        end
    end
    writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),0) %Turn off desired pogo-pin after it has been measured
end
FlatbandFitting(app,PinState,PlotCVby2); %Fit flatband for pin
% End of function