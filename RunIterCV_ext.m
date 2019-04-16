function MD = RunIterCV_ext(app,CVprogram,LampSet,LampColor,MUnb,MD)
% RunIterCV_ext
% Run Iterative CV Measurement
% Parameters
% ----------
% app : obj
%   A handle to the app designer studio GUI object
% CVProgram : str
%   A string of characters with the commands to be sent to the impedance
%   analyzer. This code will execute the CV program in the impedance
%   analyzer according to the values set in the GUI
% LampSet: int ?
%   The number of the lamp to change the color from ????
% LampColor : float[3]
%   The new color of the lamp???
% MUnb : int
%   The number of the selected measurement unit 1, 2 or 3
% MD : struct
%   A data structure that contains the experimental data results. Results
%   from the measurements will be appended to this structure.
%
% Returns
% -------
% MD : struct
%   A data structure that contains the experimental data results

% Find parameters
Arduino=app.HW(MUnb).Arduino;
ArdPins=MD(MUnb).ArdP; % Arduino pin numbers corresponding to the POGO pins
setCoolT=MD(MUnb).ExpData.Setup.TempC;
setStressT=MD(MUnb).ExpData.Setup.TempH;
PinState=MD(MUnb).PinState;
Err=MD(MUnb).MDdata.Err;
meas_flag=MD(MUnb).MDdata.meas_flag;
PreBiasTime=MD(MUnb).ExpData.Setup.PreBiasTime;
IterM = MD(MUnb).ExpData.Setup.IterM ; %Amount of repeated measurements per stress iteration

disp_info_mes=['Starting execution of RunIterCV on hotplate number ',num2str(MUnb),'.'];
disp(disp_info_mes);
disp_cycles=['Current cycle count number: ',num2str(MD(MUnb).MDdata.cycle_counter),'. Total number: ',num2str(app.Iter_tot_gnl.Value)];
disp(disp_cycles);
% if(Pinstate) % Add condition if Pinstate is not all 0, as not needed to
% go over all pin if they should not be measured
for p = 1:length(PinState) %For each pin
    if(app.stopFlag == 0) % If app not required to stop
        for j = 1:IterM %For each repeated measurement
            if(PinState(p)) %If pin is available
                writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),0) %Turn off desired pogo-pin
                if(PreBiasTime ~= 0) %If there is a prebias
                    % TO DO: Modify RunBias function
                    MD = RunBias_ext(app, MD, MUnb, 1, p); %Run prebias on pin
                end
                %                     writeDigitalPin(app.HW(MUnb).Arduino,'A0',1); % Connect impedance analyzer and disconnect Keithley
                writeDigitalPin(app.HW(MUnb).Arduino,char("D"+num2str(ArdPins(p))),1); %Turn on desired pogo-pin
                % LampSet(p) = LampColor(p); %Turn on pin lamp
				% Log the elapsed time (since the begining of the experiment) when the
				% CV starts being collected in the pin p.
				CVStartTime = toc;
				MD(MUnb).ExpData.Pin(p).tCV = ...
                    [MD(MUnb).ExpData.Pin(p).tCV CVStartTime];
                % Log this event in the temperature plot
				eventsOnTempPlot(app,MUnb,timeCompleted,...
                    strcat("CV starts pin",p),p);
                [Cmeas, Rmeas, Vmeas] = RunProgCV(app, CVprogram); %Run CV measurement
                MD(MUnb).MDdata.CVStartTime=[MD(MUnb).MDdata.CVStartTime, CVStartTime];
                % Preallocate the structures at the beginning based on the max number of iterations
                MD(MUnb).ExpData.Pin(p).C = [MD(MUnb).ExpData.Pin(p).C Cmeas]; %Save capacitance data in pin struct
                MD(MUnb).ExpData.Pin(p).R = [MD(MUnb).ExpData.Pin(p).R Rmeas]; %Save resistance data in pin struct
                MD(MUnb).ExpData.Pin(p).V = [MD(MUnb).ExpData.Pin(p).V Vmeas]; %Save voltage data in pin struct (% Check in this line that Vmeas format is right)
                % TO DO: make sure the curves are plotted in the correct CV window. CVPlots are defined at the beginning of StartProc. app.CV1_3, app.CV2_3, app.CV3_3, app.CV4_3, app.CV5_3 for MU3.
                MD=PlotCV_ext(app,MD(MUnb).ExpData.Pin(p).C, MD(MUnb).ExpData.Pin(p).V, MD(MUnb).Plots.CV(p), MD, MUnb); %Plot CV curve and temperature
            end
            
            % After each pin has been measured, check:
            % 1) Whether all hotplates have been held at the target temperature
            % and bias has been applied for the set step duration. If one of
            % them has, turn them off and let them wait (stress_completed_ext
            % function
            % 2) Whether a hotplate is ready to stop temperature rampup
            % 3) Whether room temperature has been reached on a hotplate
            for k=1:3 % Parse over the 3 measurement units
                % STRESS COMPLETED? Check if bias is ready to be stopped on each measurement unit
                MD=stress_completed_ext(app, MD, k);
                % BIAS START? Check if any hotplate is ready to stop temperature rampup (is bias ready to be started)?
                % Note that bias won't be started on the current hotplate
                % because the measurement flag is still 0, as the CV
                % measurement hasn't been completed on all pins
                MD=RunBias_ext(app, MD, k, 0, 9); % 0 because no prebias, pin number set to any number (not used if no prebias)
                % TURN FAN OFF? Check any hotplate is ready to stop temperature cool down (ie turn off the fan)?
                MD=fanoff_ext(app, MD, k);
                % LOG VALUES
                MD=logvalues_ext(app, MD, k);
            end
        end
        writeDigitalPin(Arduino,char("D"+num2str(ArdPins(p))),0) %Turn off desired pogo-pin after it has been measured
    else
        % If stopFlag is set to 1, disconnect all POGO pins, disconnect Impedance
        % Analyzer, turn off all the hotplates, turn off the fans, and delete
        % visa objects
        CV_RebootSystem(app);
    end
end

% After the last CV measurement on this hotplate, set the finish flag
% to 1 if all cycles have been executed. The user-defined number of
% cycles is app.Iter_tot_gnl.
if(MD(MUnb).MDdata.cycle_counter==app.Iter_tot_gnl.Value)
    MD(MUnb).MDdata.finish_flag=1;
end
message_finishflag=['Status of finish flag in RunIterCV: ',num2str(MD(MUnb).MDdata.finish_flag),' in unit',num2str(MUnb)];
disp(message_finishflag);
% end
MD=FlatbandFitting_ext(app, MD, MUnb); %Fit flatband for pin
% End of function

clear Arduino