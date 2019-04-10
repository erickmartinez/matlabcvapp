function [I t TempTC temp_t] = RunBias(app, Vstress,tIstress,tstep,th,Ih,PinState,ArdP,LampSet,LampColor,IsPreBias,PreBiasPin)
            writeDigitalPin(app.Arduino,'D2',0)
            for p = 1:length(PinState)
                writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),0); %Set all pins to 0 or off
            end
            if(IsPreBias)
                writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(PreBiasPin))),1); %Set PreBias pin to 1 or on
            else
                for p = 1:length(PinState)
                    if(PinState)
                        writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),1); %Set all preselected experimental pins to 1
                    end
                end
            end
                counts = abs((tIstress)/tstep);
                %t = (1:tstep:tIstress)';
                delete(instrfind('Name','VISA-GPIB0-25'))
                k=visa('agilent', 'GPIB0::25::INSTR');
                set(k, 'InputBufferSize', 64*1024);
                fopen(k)
                set(k,'Timeout',10);
                
                fprintf(k, '*RST')
                fprintf(k, ":OUTP:SMOD HIMP") %%Sets High Impedance Mode
                
                fprintf(k, ':ROUT:TERM REAR') %Set I/O to Rear Connectors
                fprintf(k, ':SENS:FUNC:CONC OFF') %Turn Off Concurrent Functions
                fprintf(k, ':SOUR:FUNC VOLT') %Voltage Source Function
                
                fprintf(k, ":SENSE:FUNC 'CURR:DC'") %DC Current Sense Function
                fprintf(k, ":SENSE:CURR:PROT .105") %Set Compliance Current to 105 mA
                
                fprintf(k, ":SOUR:VOLT "+Vstress) %Source Bias Voltage
                fprintf(k, ':SOUR:VOLT:MODE FIX') %Set Voltage Source Sweep Mode
                fprintf(k, ":SOUR:DEL .1") %100ms Source Delay
                
                fprintf(k, ":FORM:ELEM CURR") %Select Data Collecting Item Current
                fprintf(k, ":OUTP ON") %Turn On Source Output
                
                t=[];
                tcurr = [];
                I = [];
                
                for j = 1:tstep:tIstress
                    pause(tstep-0.327592);
                    I = [I str2double(strsplit(query(k, ":READ?"),','))']; %Trigger Measurement, Request Data
                    %tcurr = tstep:tstep:j;
                    tcurr = [tcurr toc];
                    temp_t = toc;
                    TempTC = getTC(app);
                    
                    plot(app.It,tcurr/3600,I,'ko-','LineWidth',2) %Add History of Time & Plot Current Vs. Time
                    plot(app.TempTime,temp_t/3600,TempTC,'-o','LineWidth',2,'Color',[1,.4,0])
                end
                t = tcurr;
                fprintf(k, ":OUTP OFF") %Turn Off Source Output
                delete(k)
                clear k
            for p = 1:length(PinState)
                writeDigitalPin(app.Arduino,char("D"+num2str(ArdP(p))),0); %Set all pins to 0 or off
            end
            %writeDigitalPin(app.Arduino,'D2',1)
        end