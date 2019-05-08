function MD=FlatbandFitting_ext(app, MD, MD_plot, MUnb)
VfbTimePlotColors = ["bo-","yo-","go-","mo-","b+-","y+-","g+-","m+-"]; % To change
IterM = MD(MUnb).ExpData.Setup.IterM; %Set # of measurements per interation
PinState=MD(MUnb).PinState;
DerPeaks=MD(MUnb).ExpData.Setup.DerPeaks;
stressbiastime=MD(MUnb).ExpData.Setup.biastime_sec;

for p=1:length(PinState) %For all pins
    if(PinState(p)) %If the pin is available
        if (DerPeaks) %If fitting type set to derivative peaks (which is the default)
            m = size(MD(MUnb).ExpData.Pin(p).C,2)/IterM; % Set # of total iterations so far (Flatbandfitting is called once all the iterations of a given cycle have been performed)
            MD = VFBfitNDeriv_ext(app, p, m, MD, MD_plot, MUnb); % Fit for flatband (data automatically updated within function)
        else %If fitting type is linear 1/C^2 (NOT USED)    
            errormessage=[newline 'NOTICE: Capacitance fitting method for flatband extraction not implemented. '...
                'Make sure the "Derivative Peaks" button is pressed on each hotplate input panel.'];
            error(errormessage);
            
            %%%%% This part not valid (should only use the derivative
            %%%%% method)
%             [Cfit, Vfit,Vfbtemp] = VFBfitN(app, C,Vall,IterM,PlotCVby2(p)); %Fit for flatband
%             app.P(p).Vfb = mean(Vfbtemp'); %Update flatband data
%             app.P(p).VfbStd = std(Vfbtemp');
%             
%             m = size(app.P(p).C,2)/IterM; % Set # of total interations so far
%             t_off = tInSec(app, string(app.t_offset_unit_1.Value), app.TimeOffset_1.Value); % Define time-Offset in seconds
%             app.P(p).tfb = 0:app.dtime:((m-1)*app.dtime); % Set flatband time array
%             app.P(p).tfb = app.P(p).tfb+t_off; % Add time-offset
            %%%%%
        end
        
        if (stressbiastime == 0) %If no time increment (repeating CV). Will plot simply as a function of the number of cycles
            m = size(MD(MUnb).ExpData.Pin(p).C,2)/IterM; % Number of cycles so far
            MD(MUnb).ExpData.Pin(p).tfb  = (0:m); %Set x-axis ("time") increment for # of measurements
            plot(MD_plot(MUnb).Plots.VfbTime, MD(MUnb).ExpData.Pin(p).tfb, MD(MUnb).ExpData.Pin(p).VfbAve, VfbTimePlotColors(p),'LineWidth',2)
            app.VFBtime_1.XLabel.String = "# of Sweeps"; %Change flatband voltage x-axis title
            app.VFBtime_1.Title.String = "Flatband Voltage Vs. Number of Sweeps";
        else
            plot(MD_plot(MUnb).Plots.VfbTime, MD(MUnb).ExpData.Pin(p).tfb/3600, MD(MUnb).ExpData.Pin(p).VfbAve, char(VfbTimePlotColors(p)),'LineWidth',2,'MarkerFaceColor',[1,1,1]) %Plot Average Vfb vs. time % tfb defined in VFBfitNDeriv_ext. Note that tfb is not defined for the case of linear fitting
            app.VFBtime_1.XLabel.String = "Time (hr)";
            app.VFBtime_1.Title.String = "Flatband Voltage Vs. Time";
            hold(MD_plot(MUnb).Plots.VfbTime,'on')
        end
    end
end
hold(MD_plot(MUnb).Plots.VfbTime, 'off')
% end of function