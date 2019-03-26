function MD = RunIterCV_ext(app,CVprogram,LampSet,LampColor,MUnb,MD) % Run Iterative CV Measurement
% Find parameters
Arduino=app.HW(MUbn).Arduino;
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
    if(app.stopFlag == 0) % If app not required to stop
        for j = 1:IterM %For each repeated measure
            if(PinState(p)) %If pin is available
                writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),0) %Turn off desired pogo-pin
                if(PreBiasTime ~= 0) %If there is a prebias
                    % TO DO: Modify RunBias function
                    MD = RunBias_ext(app, MD, MUnb, 1, p); %Run prebias on pin
                end
                WriteDigitalPin(app.HW(MUnb).Arduino,'A0',1); % Connect impedance analyzer and disconnect Keithley
                writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),1); %Turn on desired pogo-pin
                % LampSet(p) = LampColor(p); %Turn on pin lamp
                [Cmeas, Rmeas, Vmeas] = RunProgCV(app, CVprogram); %Run CV measurement
                % Preallocate the structures at the beginning based on the max number of iterations
                MD(MUnb).ExpData.Pin(p).C = [MD(MUnb).ExpData.Pin(p).C Cmeas]; %Save capacitance data in pin struct
                MD(MUnb).ExpData.Pin(p).R = [MD(MUnb).ExpData.Pin(p).R Rmeas]; %Save resistance data in pin struct
                MD(MUnb).ExpData.Pin(p).V = [MD(MUnb).ExpData.Pin(p).V Vmeas]; %Save voltage data in pin struct (% Check in this line that Vmeas format is right)
                % TO DO: make sure the curves are plotted in the correct CV window. CVPlots are defined at the beginning of StartProc. app.CV1_3, app.CV2_3, app.CV3_3, app.CV4_3, app.CV5_3 for MU3.
                MD=PlotCV(app,MD(MUnb).ExpData.Pin(p).C,MD(MUnb).ExpData.Pin(p).V,MD(MUnb).Plots.CV(p),MUnb); %Plot CV curve and temperature
            end
            
            % After each pin has been measured, check:
            % 1) Whether all hotplates have been held at the target temperature
            % and bias has been applied for the set step duration. If one of
            % them has, turn them off and let them wait (stress_completed_ext
            % function
            % 2) Whether a hotplate is ready to stop temperature rampup
            % 3) Whether room temperature has been reached on a hotplate
            for MUnb=1:3
                % STRESS COMPLETED? Check if bias is ready to be stopped on each measurement unit
                MD=stress_completed_ext(app, MD, MUnb);
                % BIAS START? Check if any hotplate is ready to stop temperature rampup (is bias ready to be started)?
                % Note that bias won't be started on the current hotplate
                % because the measurement flag is still 0, as the CV
                % measurement hasn't been completed on all pins
                MD=RunBias_ext(app, MD, MUnb, 0, 9); % 0 because no prebias, pin number set to any number (not used if no prebias)
                % TURN FAN OFF? Check any hotplate is ready to stop temperature cool down (ie turn off the fan)?
                MD=fanoff_ext(app, MD, MUnb);
                % LOG VALUES
                MD=logvalues_ext(app, MD, MUnb);
            end
        end
        writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),0) %Turn off desired pogo-pin after it has been measured
    else 
        % If stopFlag is set to 1, disconnect all POGO pins, disconnect Impedance
        % Analyzer, turn off all the hotplates, turn off the fans, and delete
        % visa objects
        CV_RebootSystem(app);
    end
end
%%% Is the following line ever executed?
MD=FlatbandFitting(app, MD, MUnb); %Fit flatband for pin
% End of function