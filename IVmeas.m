function MD=IVmeas(app,MD)
% Function called to measure an IV curve on each device

for mu=1:3
    for p=1:length(MD(mu).PinState)
        if(MD(mu).PinState(p))
            writeDigitalPin(app.HW(mu).Arduino,char("D"+num2str(MD(mu).ArdP(p))),1); %Turn on desired pogo-pin
            Vmax=MD(1).ExpData.Setup.stressBiasValue;
            V_IV=-Vmax:0.1:Vmax; % Voltage values
            
            IVcurve=zeros(length(V_IV),2); % Voltage in col 1 and current in col 2
            IVcurve(:,1)=V_IV;
            
            fprintf(app.HW(1).KEITH, ":OUTP ON"); %Turn On Source Output to allow initial current measurement (should be 0 as all pins are disconnected)
            
            for i=1:length(V_IV)
                % Get initial current value
                fprintf(app.HW(1).KEITH, ":SOUR:VOLT "+V_IV(i)); %Source Bias Voltage
                Imeas=str2double(strsplit(query(app.HW(1).KEITH, ":READ?"),','))'; % current measurement
                IVcurve(i,2)=Imeas;
            end
            
            MD(mu).ExpData.Pin(p).IV=[MD(mu).ExpData.Pin(p).IV, IVcurve]; % IVmeas return an array containing voltage in col 1 and current in col 2
            writeDigitalPin(app.HW(mu).Arduino,char("D"+num2str(MD(mu).ArdP(p))),0); %Turn off desired pogo-pin
        end
    end
end

figure
plot(MD(1).ExpData.Pin(4).IV(:,1),MD(1).ExpData.Pin(4).IV(:,2));
title('Unit 1, pin 4');
figure
plot(MD(2).ExpData.Pin(4).IV(:,1),MD(2).ExpData.Pin(4).IV(:,2));
title('Unit 2, pin 4');

fprintf(app.HW(1).KEITH, ":SOUR:VOLT "+MD(1).ExpData.Setup.stressBiasValue); %Source Bias Voltage
