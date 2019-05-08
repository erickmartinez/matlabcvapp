% Function to extract capture-time-constant from literature data

function [coeffs,tauC,tauC_err]=extract_trap_literature(filename,figpath)

% for all pins

coeffs=zeros(2,1);
Data=importdata(filename);

xdata=Data(:,1);
ydata=Data(:,2)*1e12; %cm-3 %charge values



% Interpolate data for more accuracy in fitting, especially at the
% beginning of the curve
xint=xdata(1):10:xdata(end);
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

coeffs(:)=xfinal'; % Save the fit coefficients

% display(xfinal(1)); display(xfinal(2));

fig=figure(2);
plot(xint/3600,exp_f(xfinal,xint),'-r','LineWidth',3);
hold on
plot(xdata/3600,ydata,'k-','LineWidth',2);
hold on
ylabel('Flatband voltage due to traps (V)');
xlabel('Time (h)');
xlim([0 60]);
ylim([0 3]);

saveas(fig,figpath);

alpha_av=mean(coeffs(2,:));
alpha_std=std(coeffs(2,:));

tauC=1/alpha_av;
tauC_err=alpha_std/alpha_av^2;

