% Function to extract capture-time-constants for both trapping and
% detrapping in clean SiNx Vfb=f(t) curves having both trapping and
% detrapping in the same dataset;
% The fitting is done in the range specified by rstart, rend.

function [coeffs,tauC,tauC_err]=extract_trap_range(Data,pinarray,pinarrcolor,figpath,rstart,rend1,rend2)

% for all pins

coeffs=zeros(2,length(pinarray));

%% Trapping part
for i=1:length(pinarray)
xdata=Data(pinarray(i)).tfb;

VfbAve=Data(pinarray(i)).VfbAve; % Vfb values
ydata=VfbAve-VfbAve(1); % Subtract the initial Vfb in order to only consider the change of Vfb caused by traps (the initial Vfb is due to the positive charge of SiNx and workfunction difference)
% Actually need to correct that by the workfunction difference!

% plot(xdata/3600,ydata);


% Interpolate data for more accuracy in fitting, especially at the
% beginning of the curve
xint=xdata(rstart):10:xdata(rend1);
yint=spline(xdata,ydata,xint);

% figure(1)
% hold on
% plot(xint/3600,yint);
% ylabel('Interpolated trap Vfb data');
% xlabel('Time (h)');
% hold on
% leg=[];
% leg={leg,char("pin "+num2str(i))};
% legend(leg);

exp_f = @(x,xdata) x(1)*(1-exp(-x(2)*xdata));

x0 = [2,1e-6];

options = struct('MaxFunEvals', 2000); % increase number of iterations to 2000
xfinal = lsqcurvefit(exp_f,x0,xint,yint,[],[],options); % fit the curve

coeffs(:,i)=xfinal'; % Save the fit coefficients, column i corresponds to pin i.

% display(xfinal(1)); display(xfinal(2));

% figpath_fig=[figpath,'.fig'];
% saveas(fig,figpath_fig);
% figpath_emf=[figpath,'.emf'];
% saveas(fig,figpath_emf);

end

alpha_av=mean(coeffs(2,:));
alpha_std=std(coeffs(2,:));

tauC=1/alpha_av;
tauC_err=alpha_std/alpha_av^2;

%% Detrapping part
xdata_detrap=xdata(rend1:rend2);
ydata_detrap=VfbAve(rend1:rend2)-VfbAve(end); % Subtract the initial Vfb in order to only consider the change of Vfb caused by traps (the initial Vfb is due to the positive charge of SiNx and workfunction difference)
coeffs_detrap=zeros(2,length(pinarray));

for i=1:length(pinarray)

% Interpolate data for more accuracy in fitting, especially at the
% beginning of the curve
xint_detrap=xdata_detrap(1):10:xdata_detrap(end);
yint_detrap=spline(xdata_detrap,ydata_detrap,xint_detrap);

% figure(1)
% hold on
% plot(xint/3600,yint);
% ylabel('Interpolated trap Vfb data');
% xlabel('Time (h)');
% hold on
% leg=[];
% leg={leg,char("pin "+num2str(i))};
% legend(leg);

% deTrapping model
exp_f_detrap = @(x,xdata) x(1)*exp(-x(2)*xdata_detrap);

x0 = [2,0.1e-5];

options = struct('MaxFunEvals', 2000); % increase number of iterations to 2000
xfinal_detrap = lsqcurvefit(exp_f_detrap,x0,xint_detrap,yint_detrap,[],[],options); % fit the curve

coeffs_detrap(:,i)=xfinal_detrap'; % Save the fit coefficients, column i corresponds to pin i.
end

%% Plots
% Trapping
fig=figure(2)
plot(xint/3600,exp_f(xfinal,xint),'-r','LineWidth',3);
hold on
plot(xdata/3600,ydata,char(pinarrcolor(i)+"o"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
hold on
ylabel('Flatband voltage due to traps (V)');
xlabel('Time (h)');
xlim([0 60]);
ylim([0 3]);
%detrapping
plot(xint_detrap/3600,exp_f_detrap(xfinal_detrap,xint_detrap),'-r','LineWidth',3);
hold on
plot(xdata/3600,ydata,char(pinarrcolor(i)+"+"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
hold on
set(gca,'FontSize',18);
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');