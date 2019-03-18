function FlatbandFitting_ext(app,PinState,PlotCVby2)
VfbTimePlotColors = ["bo-","yo-","go-","mo-"];
IterM_1 = app.IterM_1.Value; %Set # of measurements per interation
for p=1:length(PinState) %For all pins
    if(PinState(p)) %If the pin is available
        if (app.DerPeaks_1.Value) %If fitting type set to derivative peaks
            m = size(app.P(p).C,2)/IterM_1; % Set # of total interations so far
            VFBfitNDeriv(app,p,m,IterM_1,PlotCVby2(p)) %Fit for flatband (data automatically updated within function)
        else %If fitting type is linear 1/C^2
            [Cfit, Vfit,Vfbtemp] = VFBfitN(app, C,Vall,IterM_1,PlotCVby2(p)) %Fit for flatband
            app.P(p).Vfb = mean(Vfbtemp'); %Update flatband data
            app.P(p).VfbStd = std(Vfbtemp');
            
            m = size(app.P(p).C,2)/IterM_1; % Set # of total interations so far
            t_off = tInSec(app, string(app.t_offset_unit_1.Value), app.TimeOffset_1.Value); % Definte time-Offset in seconds
            app.P(p).tfb = 0:app.dtime:((m-1)*app.dtime); % Set flatband time array
            app.P(p).tfb = app.P(p).tfb+t_off; % Add time-offset
        end
        
        
        if (app.dt_1.Value == 0) %If no time increment (repeating CV)
            m = size(app.P(p).C,2)/IterM_1;
            app.P(p).tfb = (0:m); %Set x-axis ("time") increment for # of measurements
            plot(app.VFBtime_1,app.P(p).tfb,app.P(p).VfbAve,VfbTimePlotColors(p),'LineWidth',2)
            app.VFBtime_1.XLabel.String = "# of Sweeps"; %Change flatband voltage x-axis title
            app.VFBtime_1.Title.String = "Flatband Voltage Vs. Number of Sweeps";
        else
            plot(app.VFBtime_1,app.P(p).tfb/3600,app.P(p).VfbAve,char(VfbTimePlotColors(p)),'LineWidth',2,'MarkerFaceColor',[1,1,1]) %Plot Average Vfb vs. time
            app.VFBtime_1.XLabel.String = "Time (hr)";
            app.VFBtime_1.Title.String = "Flatband Voltage Vs. Time";
            hold(app.VFBtime_1,'on')
        end
    end
end
hold(app.VFBtime_1,'off')
% end of function