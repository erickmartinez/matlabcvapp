% Function to extract capture-time-constant in clean SiNx Vfb=f(t) curves
function [coeffs,tauC,tauC_err]=extract_trap(Data,pinarray,pinarrcolor,figpath,save)

% Save figures if save=1, do not save if 0

% for all pins

coeffs=zeros(2,length(pinarray));

for i=1:length(pinarray)
    xdata=Data(pinarray(i)).tfb;
    
    VfbAve=Data(pinarray(i)).VfbAve; % Vfb values
    ydata=VfbAve-VfbAve(1); % Subtract the initial Vfb in order to only consider the change of Vfb caused by traps (the initial Vfb is due to the positive charge of SiNx and workfunction difference)
    % Actually need to correct that by the workfunction difference!
    
    % plot(xdata/3600,ydata);
    
    
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
    
    coeffs(:,i)=xfinal'; % Save the fit coefficients, column i corresponds to pin i.
    
    % display(xfinal(1)); display(xfinal(2));
    
    fig=figure(2);
    plot(xint/3600,exp_f(xfinal,xint),'-r','LineWidth',3);
    hold on
    plot(xdata/3600,ydata,char(pinarrcolor(i)+"o"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
    hold on
    ylabel('Flatband voltage due to traps (V)');
    xlabel('Time (h)');
    xlim([0 60]);
    ylim([0 3]);
    
    set(gca,'FontSize',18);
    set(gca,'XMinorTick','on');
    set(gca,'YMinorTick','on');
    
    if(save==1)
        figpath_fig=[figpath,'.fig'];
        saveas(fig,figpath_fig);
        figpath_emf=[figpath,'.emf'];
        saveas(fig,figpath_emf);
    end
    
end

hold off

alpha_av=mean(coeffs(2,:));
alpha_std=std(coeffs(2,:));

tauC=1/alpha_av;
tauC_err=alpha_std/alpha_av^2;

