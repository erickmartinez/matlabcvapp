% Function to extract capture-time-constants from Ren et al IEEE 2011 paper

function [coeffs,tauC,tauC_err]=extract_detrapping_literature(filename,figpath,color)

% for all pins

coeffs=zeros(2,1);
Data=importdata(filename);

% figure
% plot(Data(:,1)/3600,Data(:,2),'k+');

% p=1;
% while(Data(p+1,2)<Data(p,2)&& p<size(Data,1)) % Select only the exponential decay part of the curve
% 
% % ydata=(Data(:,2)-Data(1,2))*1e12; %cm-2 %charge values
% ydata=(Data(p,2))*1e12; %cm-2 %charge values
% p=p+1;
% end

xdata=Data(:,1);
ydata=Data(:,2)-Data(end,2); % Consider only the relative decay for fitting of time-constant

drawnow


% Interpolate data for more accuracy in fitting, especially at the
% beginning of the curve
xint=xdata(1):10:xdata(end);
% yint=spline(xdata,ydata,xint);

figure
plot(xdata/3600,ydata);
xlabel('Time (h)');
ylabel('Charge (cm-2)');
% disp(xint(1));

% xlim([0 10]);

% figure(1)
% hold on
% plot(xint/3600,yint);
% ylabel('Interpolated trap Vfb data');
% xlabel('Time (h)');
% hold on
% leg=[];
% leg={leg,char("pin "+num2str(i))};
% legend(leg);

% Detrapping model
% exp_f = @(x,xdata) x(1)*(1-exp(-x(2)*xdata));

% Trapping model
exp_f = @(x,xdata) x(1)*exp(-x(2)*xdata);

x0 = [2,0.1];

options = struct('MaxFunEvals', 2000); % increase number of iterations to 2000
xfinal = lsqcurvefit(exp_f,x0,xdata,ydata,[],[],options); % fit the curve

coeffs(:)=xfinal'; % Save the fit coefficients

% display(xfinal(1)); display(xfinal(2));

figure(2)
semilogx(xint/3600,exp_f(xfinal,xint),'Color',color,'LineWidth',3);
hold on
semilogx(xdata/3600,ydata,'+','Color',color,'LineWidth',2);
hold on
ylabel('Charge (cm-2)');
xlabel('Time (h)');
legend('Fit','data');
xlim([-1 80]);
ylim([-0.2 3]);
hold on

% saveas(fig,figpath);

alpha_av=mean(coeffs(2,:));
alpha_std=std(coeffs(2,:));

tauC=1/alpha_av;
tauC_err=alpha_std/alpha_av^2;

