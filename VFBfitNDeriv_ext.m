function VFBfitNDeriv_ext(app,p,m,IterM_1,PlotCVby2_p)
Cs = app.P(p).C; % C in struct for pin p
Vs = app.P(p).V; % V in struct for pin p
Vi=Vs(1):0.001:Vs(end); %Interpolated Voltage Bias Range
t_off = tInSec(app, string(app.t_offset_unit_1.Value), app.TimeOffset_1.Value); % Definte time-Offset in seconds
app.P(p).tfb = 0:app.dtime:((m-1)*app.dtimema); % Set flatband time array
app.P(p).tfb = app.P(p).tfb+t_off; % Add time-offset
set(PlotCVby2_p, 'ColorOrder', jet((app.Iter_tot_1.Value+1)))
app.P(p).Vfb = []; app.P(p).Vfit = []; app.P(p).Cfit = [];
app.P(p).VfbAve = []; app.P(p).VfbStd = [];
hold(PlotCVby2_p, 'off')
plot(PlotCVby2_p,[],[],'LineWidth',2)
hold(PlotCVby2_p, 'on')
for j = 1:m*IterM_1 % Parse through all CV data for pin
    Ci=interp1(Vs(:,j),Cs(:,j),Vi,'spline'); % Interpolate CV data
    Cby2 = 1./(Ci./max(Ci)).^2; %Define normalized 1/C^2
    %d1Cby1 = (diff(Cby2,1)./diff(Vi,1));
    Vicut = Vi(Cby2<10); %Concatenate 1/C^2 to remove noisy data (Voltage)
    Cby2cut = Cby2(Cby2<10); %Concatenate 1/C^2 to remove noisy data (Capacitance)
    d1Cby1 = ((diff(Cby2cut,1))./diff(Vicut,1)); %Take derivative of non-noisy interpolated CV data
    
    [mind1Cby1 minInd1] = min(d1Cby1); %Find minumum point of 1/C^2 derivative
    d2Cby2 = (diff(d1Cby1)./diff(Vicut(1:end-1))); %Take second derivative of 1/C^2
    
    VExtract = Vicut(minInd1+2:end); %Concatenate voltage to data above 1st derivative minimum (removes noise data further 2nd derivative data)
    Cby2Extract = d2Cby2(minInd1:end); %Concatenate capacitance to data above 1st derivative minimum (removes noise data further 2nd derivative data)
    
    app.P(p).Vfit = [app.P(p).Vfit VExtract]; %Save non-noisy 2nd derivative voltage array
    app.P(p).Cfit = [app.P(p).Cfit Cby2Extract]; %Save non-noisy 2nd capacitance voltage array
    
    [maxd2Cby2 maxInd2] = max(Cby2Extract); %Find max peak position or index
    app.P(p).Vfb = [app.P(p).Vfb VExtract(maxInd2)]; %Define flatband as voltage as that peak
    Vfb = app.P(p).Vfb; %Save Vfb variable
    
    plot(PlotCVby2_p,Vicut(minInd1:end-2),d2Cby2(minInd1:end),'LineWidth',2); %Plot non-noisy 2nd derivative 1/C^2 data
    plot(PlotCVby2_p,Vfb(end),maxd2Cby2,'k*','LineWidth',1); %Show fitted flatband peak in plot
    ylim([-inf,0]) %Assuming Vfb is below zero, limit yscale for plot from -infinity to 0
end
hold(PlotCVby2_p, 'off')

%Since many CV measurements may be taken for time point,
%the next lines average Vfb for the multiple measurements at each time point
for j=1:m %For all measurements
    ind = j*IterM_1; %For every set of repeated measurements
    app.P(p).VfbAve = [app.P(p).VfbAve mean(Vfb(ind:-1:ind-IterM_1+1)')]; %Average and add average to defined average flatband array
    app.P(p).VfbStd = [app.P(p).VfbStd std(Vfb(ind:-1:ind-IterM_1+1)')]; %Calculate standard deviation (STD) and add values to defined flatband STD array
end