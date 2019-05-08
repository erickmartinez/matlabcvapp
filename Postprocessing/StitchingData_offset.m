% Stitches datafiles when a measurement had to be interrupted

S2 = load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181104\HR3_Na_3_D13D14D15D16.mat','Data');
S3 = load('G:\My Drive\#Shared_Jonathan\Experimental Data\20181105\HR3_Na_3_D13D14D15D16_continued_5h.mat','Data');
pinArry = [1,2,3,4];
pinArryColor = ["b","y","g","m"];
IterM = 1;

for i=1:length(pinArry)
    
    S2_tfb = S2.Data(pinArry(i)).tfb;
    S2_Vfb = S2.Data(pinArry(i)).Vfb;
    S2_VfbAve = S2.Data(pinArry(i)).VfbAve;
    S2_VfbStd = S2.Data(pinArry(i)).VfbStd;
    S2_C = S2.Data(pinArry(i)).C;
    S2_V = S2.Data(pinArry(i)).V;

    S3_tfb = S3.Data(pinArry(i)).tfb;
    S3_Vfb = S3.Data(pinArry(i)).Vfb;
    S3_VfbAve = S3.Data(pinArry(i)).VfbAve;
    S3_VfbStd = S3.Data(pinArry(i)).VfbStd;
    S3_C = S3.Data(pinArry(i)).C;
    S3_V = S3.Data(pinArry(i)).V;
    
    tfb = [S2_tfb(1:end-1),S3_tfb];
%     VfbAve = [S2_VfbAve(1:end-1), S3_VfbAve];
    VfbAve = [S2_VfbAve(1:end-1)+S3_VfbAve(1)-S2_VfbAve(end), S3_VfbAve]; % Offset the initial data S2 to the leval of the continued data S3
    VfbStd = [S2_VfbStd(1:end-1), S3_VfbStd]; % No change in standard deviation, just stitch the two
    Vfb = [S2_Vfb(1:end-IterM)+S3_Vfb(1)-S2_Vfb(end), S3_Vfb];
    
    C = [S2_C(:,1:end-IterM),S3_C];
    
    offsetV=ones(size(S2_V,1),1)*(S3_VfbAve(1)-S2_VfbAve(end));
    V = [S2_V(:,1:end-IterM)+offsetV,S3_V]; % Offset the voltage of the initial data to match the continued data. Use the difference in flatband voltage

    
    Data(pinArry(i)).tfb =  tfb;    
    Data(pinArry(i)).Vfb =  Vfb;
    Data(pinArry(i)).VfbAve = VfbAve;
    Data(pinArry(i)).VfbStd = VfbStd;
    Data(pinArry(i)).V =  V;    
    Data(pinArry(i)).C =  C;    


    figure(1)
    hold on
    set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)))
    errorbar(tfb/(3600),VfbAve-VfbAve(1),VfbStd,char(pinArryColor(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1])
    hold off
end
ylabel("Stitched Flatband Voltage (V)")
xlabel("Time (hrs)")
legend("Pin "+pinArry)

% %{

figure(3)
hold on
set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)));
errorbar(S2_tfb/(3600),S2_VfbAve,S2_VfbStd,char(pinArryColor(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
hold off
ylabel("first Flatband Voltage (V)");
xlabel("Time (hrs)");
legend("Pin "+pinArry);

% %}

% %{
figure(4)
hold on
set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)));
errorbar(S3_tfb/(3600),S3_VfbAve,S3_VfbStd,char(pinArryColor(i)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
hold off
ylabel("second Flatband Voltage (V)");
xlabel("Time (hrs)");
legend("Pin "+pinArry);

% %}

%{
figure(3)
figure(4)
for i=1:size(S2_V,2)
    figure(3)
    hold on
    set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)));
    plot(V(:,i),S2_C(:,i),char(pinArryColor(1)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
    hold off
    ylabel("Capacitance, initial (F)");
    xlabel("Voltage (V)");
%     legend("Pin "+pinArry);
end
    
for i=1:size(S3_V,2)
    figure(4)
    hold on
    set(gca,'FontSize',14,'ColorOrder',fliplr(hot(length(pinArry)+2)));
    plot(V(:,i),S3_C(:,i),char(pinArryColor(1)+"s-"),'LineWidth',2,'MarkerFaceColor',[1 1 1]);
    hold off
    ylabel("Capacitance, continued (F)");
    xlabel("Voltage (V)");
%     legend("Pin "+pinArry);
end
%}

save('G:\My Drive\#Shared_Jonathan\Experimental Data\20181105\HR3_Na_3_D13D14D15D16_11-12-2018_stitched_11-12_usethis');