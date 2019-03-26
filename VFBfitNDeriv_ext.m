% function VFBfitNDeriv(app,p,m,IterM,PlotCVby2_p)
function MD=VFBfitNDeriv_ext(app, p, m, MD, MUnb)
% The function calculates Vfb based on the CV measurement data
% (recalculates all previous values too)

PlotCVby2_p = MD(MUnb).Plots.CVby2(p); % PlotCVby2_p is the handle to the derivative plot corresponding to pin p
IterM = MD(MUnb).ExpData.Setup.IterM; % Number of repeats for each measurement

Cs = MD(MUnb).ExpData.Pin(p).C; % C in struct for pin p
Vs = MD(MUnb).ExpData.Pin(p).V; % V in struct for pin p
Vi=Vs(1):0.001:Vs(end); %Interpolated Voltage Bias Range

t_off = tInSec(app, string(MD(n).ExpData.Setup.t_offset_unit), MD(n).ExpData.Setup.t_offset_value); % Define time-Offset in seconds
MD(MUnb).ExpData.Pinp(p).tfb = 0:MD(MUnb).ExpData.Setup.dtime:((m-1)*MD(Munb).ExpData.Setup.dtime ); % Set flatband time array (dtime is the stressbiastime in second, to define in startproc
MD(MUnb).ExpData.Pinp(p).tfb = MD(MUnb).ExpData.Pinp(p).tfb + t_off; % Add time-offset

set(PlotCVby2_p, 'ColorOrder', jet((app.Iter_tot_gnl.Value+1)))

%%%% Define this in startproc if do not want to recalculate derivatives
%%%% every time
MD(MUnb).ExpData.Pin(p).Vfb  = [];
MD(MUnb).ExpData.Pin(p).Vfit = [];
MD(MUnb).ExpData.Pin(p).Cfit = [];
MD(MUnb).ExpData.Pin(p).VfbAve = [];
MD(MUnb).ExpData.Pin(p).VfbStd = [];
%%%%

hold(PlotCVby2_p, 'off')
plot(PlotCVby2_p,[],[],'LineWidth',2)
hold(PlotCVby2_p, 'on')
for j = 1:m*IterM % Parse through all CV data for pin
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
    
    MD(MUnb).ExpData.Pin(p).Vfit = [MD(MUnb).ExpData.Pin(p).Vfit VExtract]; %Save non-noisy 2nd derivative voltage array
    MD(MUnb).ExpData.Pin(p).Cfit = [MD(MUnb).ExpData.Pin(p).Cfit Cby2Extract]; %Save non-noisy 2nd capacitance voltage array
    
    [maxd2Cby2 maxInd2] = max(Cby2Extract); %Find max peak position or index
    MD(MUnb).ExpData.Pin(p).Vfb = [MD(MUnb).ExpData.Pin(p).Vfb VExtract(maxInd2)]; %Define flatband as voltage as that peak
    Vfb = MD(MUnb).ExpData.Pin(p).Vfb; %Save Vfb variable
    
    plot(PlotCVby2_p,Vicut(minInd1:end-2),d2Cby2(minInd1:end),'LineWidth',2); %Plot non-noisy 2nd derivative 1/C^2 data
    plot(PlotCVby2_p,Vfb(end),maxd2Cby2,'k*','LineWidth',1); %Show fitted flatband peak in plot
    ylim([-inf,0]) %Assuming Vfb is below zero, limit yscale for plot from -infinity to 0
end
hold(PlotCVby2_p, 'off')

%Since many CV measurements may be taken for time point,
%the next lines average Vfb for the multiple measurements at each time point
for j=1:m %For all measurements
    ind = j*IterM; %For every set of repeated measurements
    MD(MUnb).ExpData.Pin(p).VfbAve = [MD(MUnb).ExpData.Pin(p).VfbAve mean(Vfb(ind:-1:ind-IterM+1)')]; %Average and add average to defined average flatband array
    MD(MUnb).ExpData.Pin(p).VfbStd = [MD(MUnb).ExpData.Pin(p).VfbStd std(Vfb(ind:-1:ind-IterM+1)')]; %Calculate standard deviation (STD) and add values to defined flatband STD array
end