% Function to calibrate the set temperature of the hotplate
% (as the set temperature on a hotplate is different from the temperature
% measured on its surface with a thermocouple)

% clear all
% 
% HP = InitHP()
% [Ard Therm] = InitArd()
HP=HP3;
Therm=Therm3;

figure(2)

THP=[];
TC=[];
Tset = [];
t = [];
tic;
%{
ax1 = gca; % current axes
ax1_pos = ax1.Position; % position of first axes
ax2 = axes('Position',ax1_pos,...
    'XAxisLocation','top',...
    'Color','none');
%}
% for T=30:3:120
for T=30:3:120
    setHPTemp(HP,T) %Turns HP on & sets it to Tset
%     pause(10*60-2.7637)
pause(6*60-2.7637)
    
    THP = [getHPParam(HP) THP];
    TC = [getTC(Therm) TC];
    Tset = [T Tset];
    
    subplot(1,2,1)
    plot(THP,TC,'bo-','LineWidth',2)
    hold on
    plot(Tset,TC,'r*-','LineWidth',2)

    xlabel("Hotplate Temperature (C)")
    ylabel("Arduino Thermocouple Temperature (C)")
    title("Calibration Curve") 
    legend("Hotplate Read Temperature","Hotplate Set Temperature")
    t = [toc t];
    
    subplot(1,2,2)    
    plot(t/60,TC,'r*-','LineWidth',2)
    xlabel("Time (s)")
    ylabel("Arduino Thermocouple Temperature (C)")
    title("Calibration Curve") 
    
    setHPTemp(HP,T) %Turns HP off
end
% writeDigitalPin(Ard,'D3',1) %Turn on Fan

%% Fitting
figure(6)
Tfit = 25:.1:100;
SetFit = polyfit(TC,Tset,2);
SetFitEval = polyval(SetFit,Tfit);

plot(TC,THP,'bo-','LineWidth',2)
hold on
plot(TC,Tset,'r*-','LineWidth',2)
plot(Tfit,SetFitEval,'k--','LineWidth',2)
hold off
ylabel("Hotplate Temperature (C)")
xlabel("Arduino Thermocouple Temperature (C)")
title("Calibration") 
legend("Hotplate Read Temperature","Hotplate Set Temperature","Fit")

a1_HP3 = SetFit(1);
a2_HP3 = SetFit(2);
b_HP3 = SetFit(3);
Tnew_HP3 = a1_HP3*(25)^2+a2_HP3*(25)+b_HP3;


