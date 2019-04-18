function  StartProc_ext(app)
% StartProc_ext
% Parameters
% ----------
% app : obj
%   A handle to the app designer GUI instance

% Starts the measurement
    if app.idleFlag == 1 && app.devicesConnected == 1

        disp('Process started');
        disp(app.P5_2.Value);
        disp(app.P5_3.Value);

        %Turns off holds for/reset all plots in app
        % Unit 1
        hold(app.It_1,'off'); hold(app.VFBtime_1,'off'); hold(app.TempTime_1,'off')
        hold(app.CV1_1,'off'); hold(app.CV2_1,'off'); hold(app.CV3_1,'off'); hold(app.CV4_1,'off');
        hold(app.CV5_1,'off'); hold(app.CV6_1,'off'); hold(app.CV7_1,'off'); hold(app.CV8_1,'off');
        hold(app.byC2_1_1,'off'); hold(app.byC2_2_1,'off'); hold(app.byC2_3_1,'off'); hold(app.byC2_4_1,'off');
        hold(app.byC2_5_1,'off'); hold(app.byC2_6_1,'off'); hold(app.byC2_7_1,'off'); hold(app.byC2_8_1,'off');

        % Unit 2
        hold(app.It_2,'off'); hold(app.VFBtime_2,'off'); hold(app.TempTime_2,'off')
        hold(app.CV1_2,'off'); hold(app.CV2_2,'off'); hold(app.CV3_2,'off'); hold(app.CV4_2,'off');
        hold(app.CV5_2,'off'); hold(app.CV6_2,'off'); hold(app.CV7_2,'off'); hold(app.CV8_2,'off');
        hold(app.byC2_1_2,'off'); hold(app.byC2_2_2,'off'); hold(app.byC2_3_2,'off'); hold(app.byC2_4_2,'off');
        hold(app.byC2_5_2,'off'); hold(app.byC2_6_2,'off'); hold(app.byC2_7_2,'off'); hold(app.byC2_8_2,'off');

        % Unit 3
        hold(app.It_3,'off'); hold(app.VFBtime_3,'off'); hold(app.TempTime_3,'off')
        hold(app.CV1_3,'off'); hold(app.CV2_3,'off'); hold(app.CV3_3,'off'); hold(app.CV4_3,'off');
        hold(app.CV5_3,'off'); hold(app.CV6_3,'off'); hold(app.CV7_3,'off'); hold(app.CV8_3,'off');
        hold(app.byC2_1_3,'off'); hold(app.byC2_2_3,'off'); hold(app.byC2_3_3,'off'); hold(app.byC2_4_3,'off');
        hold(app.byC2_5_3,'off'); hold(app.byC2_6_3,'off'); hold(app.byC2_7_3,'off'); hold(app.byC2_8_3,'off');

        %Disable control of turning on/off pins
        % Unit 1
        app.P1_1.Enable = 'off'; app.P2_1.Enable = 'off'; app.P3_1.Enable = 'off'; app.P4_1.Enable = 'off';
        app.P5_1.Enable = 'off'; app.P6_1.Enable = 'off'; app.P7_1.Enable = 'off'; app.P8_1.Enable = 'off';
        % Unit 2
        app.P1_2.Enable = 'off'; app.P2_2.Enable = 'off'; app.P3_2.Enable = 'off'; app.P4_2.Enable = 'off';
        app.P5_2.Enable = 'off'; app.P6_2.Enable = 'off'; app.P7_2.Enable = 'off'; app.P8_2.Enable = 'off';
        % Unit 3
        app.P1_3.Enable = 'off'; app.P2_3.Enable = 'off'; app.P3_3.Enable = 'off'; app.P4_3.Enable = 'off';
        app.P5_3.Enable = 'off'; app.P6_3.Enable = 'off'; app.P7_3.Enable = 'off'; app.P8_3.Enable = 'off';

        % Disable control of turning on/off all pins
        app.SwitchAll_HP1.Enable = 'off';
        app.SwitchAll_HP2.Enable = 'off';
        app.SwitchAll_HP3.Enable = 'off';

        %Set pin lamps to gray
        % Unit 1
        app.P1Lamp_1.Color = [.9, .9, .9]; app.P2Lamp_1.Color = [.9, .9, .9]; app.P3Lamp_1.Color = [.9, .9, .9]; app.P4Lamp_1.Color = [.9, .9, .9];
        app.P5Lamp_1.Color = [.9, .9, .9]; app.P6Lamp_1.Color = [.9, .9, .9]; app.P7Lamp_1.Color = [.9, .9, .9]; app.P8Lamp_1.Color = [.9, .9, .9];
        % Unit 2
        app.P1Lamp_2.Color = [.9, .9, .9]; app.P2Lamp_2.Color = [.9, .9, .9]; app.P3Lamp_2.Color = [.9, .9, .9]; app.P4Lamp_2.Color = [.9, .9, .9];
        app.P5Lamp_2.Color = [.9, .9, .9]; app.P6Lamp_2.Color = [.9, .9, .9]; app.P7Lamp_2.Color = [.9, .9, .9]; app.P8Lamp_2.Color = [.9, .9, .9];
        % Unit 3
        app.P1Lamp_3.Color = [.9, .9, .9]; app.P2Lamp_3.Color = [.9, .9, .9]; app.P3Lamp_3.Color = [.9, .9, .9]; app.P4Lamp_3.Color = [.9, .9, .9];
        app.P5Lamp_3.Color = [.9, .9, .9]; app.P6Lamp_3.Color = [.9, .9, .9]; app.P7Lamp_3.Color = [.9, .9, .9]; app.P8Lamp_3.Color = [.9, .9, .9];


        %% CV Program Definition for Impedance Anlayzer
        if (app.Sweep_gnl.Value == "Down")
            SWD = "SWD2"; %Set program parameter to sweep down
        else
            SWD = "SWD1"; %Set program parameter to sweep up
        end

        % Depending on integration time specified in app input, set
        % corresponding parameter in the program script
        if (app.ITM_gnl.Value == "500 us")
            ITMgnl = "ITM1";
        elseif (app.ITM_gnl.Value == "5 ms")
            ITMgnl = "ITM2";
        elseif (app.ITM_gnl.Value == "100 ms")
            ITMgnl = "ITM3";
        end

        %Set frequency multiplaction factor based on defined unit in app dropdown
        if (app.Freq_unit_gnl.Value == "KHz")
            FreqU = 1e3;
        elseif (app.Freq_unit_gnl.Value == "MHz")
            FreqU = 1e6;
        end

        %Define CV program to be read in by Impedance Analyzer
        Prog_CV = "PROG"...
            + "'10 FNC1'," ... %Impedance Measurement
            + "'20 SWM2'," ... % Single Mode Sweep
            + "'30 IMP5'," ... % Cs-Rs Circuit
            + "'40 SWP2'," ... % DC Bias Sweep
            + "'50 "+SWD+"'," ... % Sweep Direction
            + "'60 "+ITMgnl+"'," ... % Integration Time
            + "'70 NOA="+app.NOA_gnl.Value+"'," ... % # of Averages
            + "'80 OSC="+app.OSC_gnl.Value*1e-3+";FREQ="+app.Frequency_gnl.Value*FreqU+"'," ... % AC Amplitude (V) & Frequency
            + "'90 START="+app.VNeg_gnl.Value+";STOP="+app.VPos_gnl.Value+"'," ... %Starting Negative & Positive Volgates
            + "'100 STEP="+app.VStep_gnl.Value*1e-3+"'," ... %DC Sweep Step Magnitude (V)
            + "'110 DTIME=0'," ... % Measurement Delay Time Set to 0 (No Delay)
            + "'120 SHT1'," ... % Short Calibration Set to On
            + "'130 OPN1'," ... % Open Calibration Set to On
            + "'140 AUTO'," ... % Auto-Scale A & B
            + "'150 CPYM2'," ... % Copy Data Mode 2
            + "'160 SWTRG'," ... % Single Trigger Run
            + "'170 COPY'," ... % Copy Data to Instrument
            + "'180 DCOFF'," ... % Doesn't work, but attempt to turn off DC bias
            + "'190 END'";

        LampSet = [app.P1Lamp_1.Color, app.P2Lamp_1.Color, app.P3Lamp_1.Color, app.P4Lamp_1.Color]; %Define an array of lamp color objects
        LampColor = ["blue","yellow","green","white"]; %Define an array of lamp colors
        % Hotplate 1
        MD(1).PinState = [app.P1_1.Value, app.P2_1.Value, app.P3_1.Value, app.P4_1.Value, app.P5_1.Value, app.P6_1.Value, app.P7_1.Value, app.P8_1.Value]; %Define array of pin value objects (objects that indicate on or off state)
        MD(1).ArdP = [app.AP1_1.Value, app.AP2_1.Value, app.AP3_1.Value, app.AP4_1.Value, app.AP5_1.Value, app.AP6_1.Value, app.AP7_1.Value, app.AP8_1.Value]; %Define array of arduino pin value objects (objects that indicate arduino pin for pogo-pin)
        % Hotplate 2
        MD(2).PinState = [app.P1_2.Value, app.P2_2.Value, app.P3_2.Value, app.P4_2.Value, app.P5_2.Value, app.P6_2.Value, app.P7_2.Value, app.P8_2.Value]; %Define array of pin value objects (objects that indicate on or off state)
        MD(2).ArdP = [app.AP1_2.Value, app.AP2_2.Value, app.AP3_2.Value, app.AP4_2.Value, app.AP5_2.Value, app.AP6_2.Value, app.AP7_2.Value, app.AP8_2.Value]; %Define array of arduino pin value objects (objects that indicate arduino pin for pogo-pin)
        % Hotplate 3
        MD(3).PinState = [app.P1_3.Value, app.P2_3.Value, app.P3_3.Value, app.P4_3.Value, app.P5_3.Value, app.P6_3.Value, app.P7_3.Value, app.P8_3.Value]; %Define array of pin value objects (objects that indicate on or off state)
        MD(3).ArdP = [app.AP1_3.Value, app.AP2_3.Value, app.AP3_3.Value, app.AP4_3.Value, app.AP5_3.Value, app.AP6_3.Value, app.AP7_3.Value, app.AP8_3.Value]; %Define array of arduino pin value objects (objects that indicate arduino pin for pogo-pin)
        % Save figure handles to CV plots for each hotplate (in a structure array of objects). Access CV plot 3 in MU 1 with: MD(1).Plots.CVhandle(3).
        MD(1).Plots.CV = [app.CV1_1,app.CV2_1,app.CV3_1,app.CV4_1,app.CV5_1,app.CV6_1,app.CV7_1,app.CV8_1];
        MD(2).Plots.CV = [app.CV1_2,app.CV2_2,app.CV3_2,app.CV4_2,app.CV5_2,app.CV6_2,app.CV7_2,app.CV8_2];
        MD(3).Plots.CV = [app.CV1_3,app.CV2_3,app.CV3_3,app.CV4_3,app.CV5_3,app.CV6_3,app.CV7_3,app.CV8_3];
        % Save figure handles to derivative plots for each hotplate
        MD(1).Plots.CVby2=[app.byC2_1_1,app.byC2_2_1,app.byC2_3_1,app.byC2_4_1,app.byC2_5_1,app.byC2_6_1,app.byC2_7_1,app.byC2_8_1]; %Define array of plot objects for CV & 1/C^2 vs. V curves
        MD(2).Plots.CVby2=[app.byC2_1_2,app.byC2_2_2,app.byC2_3_2,app.byC2_4_2,app.byC2_5_2,app.byC2_6_2,app.byC2_7_2,app.byC2_8_2];
        MD(3).Plots.CVby2=[app.byC2_1_3,app.byC2_2_3,app.byC2_3_3,app.byC2_4_3,app.byC2_5_3,app.byC2_6_3,app.byC2_7_3,app.byC2_8_3];
        % Preallocate the data structure arrays based on the max number of iterations maxnbIt and the number of points from the analyzer L (check whether constant)
        %MD(MUnb).ExpData.Pin(p).C = zeros(L,maxnbIt);
        %MD(MUnb).ExpData.Pin(p).R = zeros(L,maxnbIt);
        %MD(MUnb).ExpData.Pin(p).V = zeros(L,maxnbIt);

        % Number of iterations
        MD(1).ExpData.Setup.IterM=app.IterM_1.Value;
        MD(2).ExpData.Setup.IterM=app.IterM_2.Value;
        MD(3).ExpData.Setup.IterM=app.IterM_3.Value;
                

        for mu=1:3
            % Initialize startbias log vector
            MD(mu).ExpData.log.startbiastime = [];
            % Initialize end bias time log vector
            MD(mu).ExpData.log.endBiasTime = [];
            for i=1:length(MD(mu).PinState) %For all pins, set parameters to null
                set(MD(mu).Plots.CV(i), 'ColorOrder', jet((app.Iter_tot_gnl.Value+1)*MD(mu).ExpData.Setup.IterM)); %Define color order for plotting based on % of iterations
                MD(mu).ExpData.Pin(i).C  = []; % Capacitance read from the impedance analyzer
                MD(mu).ExpData.Pin(i).R=[]; % Resistance read from the impedance analyzer
                MD(mu).ExpData.Pin(i).V = []; % Voltage read from the impedance analyzer
                % app.P(i).Vall = []; % Parameter only used with the function VFBfitn, which is not used
                MD(mu).ExpData.Pin(i).Vfit = [];
                MD(mu).ExpData.Pin(i).Cfit = [];
                MD(mu).ExpData.Pin(i).Vfb = [];
                MD(mu).ExpData.Pin(i).tfb = [];%Null V,Vfit,Cfit,Vfb,tfb (flatband voltage/time)
                MD(mu).ExpData.Pin(i).VfbAve = [];
                MD(mu).ExpData.Pin(i).VfbStd = []; %Null average & standard deviation Vfb
                MD(mu).ExpData.log.T = [];
                MD(mu).ExpData.log.Ttime =[];
                MD(mu).ExpData.log.I = [];
                MD(mu).ExpData.log.Itime = [];
                % initialize cv start time log vector
                MD(mu).ExpData.Pin(i).tCV = [];
            end
        end

        %% Connect Keithley and impedance analyzer
        % Currently done manually by the user with the power button in the general panel

        % Graph handles
        drawnow;
        % Temp vs time plot handles
        MD(1).Plots.Temp=app.TempTime_1;
        MD(2).Plots.Temp=app.TempTime_2;
        MD(3).Plots.Temp=app.TempTime_3;
        %% Current vs time plot handles
        MD(1).Plots.Current=app.It_1;
        MD(2).Plots.Current=app.It_2;
        MD(3).Plots.Current=app.It_3;
        %% Vfb vs time plot handles
        MD(1).Plots.VfbTime=app.VFBtime_1;
        MD(2).Plots.VfbTime=app.VFBtime_2;
        MD(3).Plots.VfbTime=app.VFBtime_3;

        %% Unit parameters
        % Prebias time
        MD(1).ExpData.Setup.PreBiasTime=app.PreBiasTime_1.Value;
        MD(2).ExpData.Setup.PreBiasTime=app.PreBiasTime_2.Value;
        MD(3).ExpData.Setup.PreBiasTime=app.PreBiasTime_3.Value;
        % Offset
        MD(1).ExpData.Setup.t_offset_unit =app.t_offset_unit_1.Value;
        MD(2).ExpData.Setup.t_offset_unit =app.t_offset_unit_2.Value;
        MD(3).ExpData.Setup.t_offset_unit =app.t_offset_unit_3.Value;
        MD(1).ExpData.Setup.t_offset_value =app.TimeOffset_1.Value;
        MD(2).ExpData.Setup.t_offset_value =app.TimeOffset_2.Value;
        MD(3).ExpData.Setup.t_offset_value =app.TimeOffset_3.Value;
        % Temperatures
        MD(1).ExpData.Setup.TempC=app.TempC_1.Value;
        MD(2).ExpData.Setup.TempC=app.TempC_2.Value;
        MD(3).ExpData.Setup.TempC=app.TempC_3.Value;
        MD(1).ExpData.Setup.TempH=app.TempH_1.Value;
        MD(2).ExpData.Setup.TempH=app.TempH_2.Value;
        MD(3).ExpData.Setup.TempH=app.TempH_3.Value;
        % Derivative peak method
        MD(1).ExpData.Setup.DerPeaks=app.DerPeaks_1.Value;
        MD(2).ExpData.Setup.DerPeaks=app.DerPeaks_2.Value;
        MD(3).ExpData.Setup.DerPeaks=app.DerPeaks_3.Value;


        %% Save Parameters to Text File:
        fileDest = app.FileLoc.Value;

        fileID = fopen(fileDest+"\ExpParams.txt",'wt');

        % General parameters
        fprintf(fileID,"Parameter File:\n\nCommon Parameters: \n");
        fprintf(fileID,datestr(datetime));

        fprintf(fileID,'\r\n');

        fprintf(fileID,"Sweep Parameters: \n");
        fprintf(fileID,"Frequency: "+app.Frequency_gnl.Value+" "+app.Freq_unit_gnl.Value+"      VAC: "+app.OSC_gnl.Value+" mV"+"\n");
        fprintf(fileID,"Negative Voltage: "+app.VNeg_gnl.Value+" V       Positive Voltage: "+app.VPos_gnl.Value+" V \n");
        fprintf(fileID,"Voltage Step: "+app.VStep_gnl.Value+" mV         Averages per Point: "+app.NOA_gnl.Value+"\n");
        fprintf(fileID,"Integration Time: "+app.ITM_gnl.Value+"         Sweep Direction: "+app.Sweep_gnl.Value+"\n");

        fprintf(fileID,'\r\n');

        fprintf(fileID,"\nExperiment Parameters: \n");
        fprintf(fileID,"Cycle time: "+app.dt_gnl.Value+" "+app.t_inc_unit_gnl.Value);
        fprintf(fileID,"Bias Voltage (both cycle bias and pre-bias): "+app.Bias_gnl.Value+" V \n");
        fprintf(fileID,"Total number of cycles: "+app.Iter_tot_gnl.Value);

        fprintf(fileID,'\r\n');

        % Unit 1
        fprintf(fileID, 'Unit 1');
        fprintf(fileID,"Measurement name: "+app.DataFileName_MU1.Value);
        fprintf(fileID,"Nitride Thickness: "+app.THK_1.Value+" nm\n");
        fprintf(fileID,"Heating temperature: "+app.TempH_1.Value+" °C\n");
        fprintf(fileID,"Cooling temperature: "+app.TempH_1.Value+" °C\n");
        fprintf(fileID,"Time Offset: "+app.TimeOffset_1.Value+" "+app.t_offset_unit_1.Value+"\n");
        fprintf(fileID,"Pre-CV bias Time: "+app.PreBiasTime_1.Value + " min \n");
        fprintf(fileID,"Number of iterations/measurement: "+app.IterM_1.Value+"\n");

        fprintf(fileID,'\r\n');

        % Unit 2
        fprintf(fileID, 'Unit 2');
        fprintf(fileID,"Measurement name: "+app.DataFileName_MU2.Value);
        fprintf(fileID,"Nitride Thickness: "+app.THK_2.Value+" nm\n");
        fprintf(fileID,"Heating temperature: "+app.TempH_2.Value+" °C\n");
        fprintf(fileID,"Cooling temperature: "+app.TempH_2.Value+" °C\n");
        fprintf(fileID,"Time Offset: "+app.TimeOffset_2.Value+" "+app.t_offset_unit_2.Value+"\n");
        fprintf(fileID,"Pre-CV bias Time: "+app.PreBiasTime_2.Value + " min \n");
        fprintf(fileID,"Number of iterations/measurement: "+app.IterM_2.Value+"\n");

        fprintf(fileID,'\r\n');

        % Unit 3
        fprintf(fileID, 'Unit 3');
        fprintf(fileID,"Measurement name: "+app.DataFileName_MU3.Value);
        fprintf(fileID,"Nitride Thickness: "+app.THK_3.Value+" nm\n");
        fprintf(fileID,"Heating temperature: "+app.TempH_3.Value+" °C\n");
        fprintf(fileID,"Cooling temperature: "+app.TempH_3.Value+" °C\n");
        fprintf(fileID,"Time Offset: "+app.TimeOffset_3.Value+" "+app.t_offset_unit_3.Value+"\n");
        fprintf(fileID,"Pre-CV bias Time: "+app.PreBiasTime_3.Value + " min \n");
        fprintf(fileID,"Number of iterations/measurement: "+app.IterM_3.Value+"\n");

        fclose(fileID);

        %% Run & Get Data:

        % Initialize parameters for each unit
        for mu=1:3
            % Allowed error in temperature
            MD(mu).MDdata.Err = 3; %Set Temperature +/- Error in Degree (C) (e.x. app will execute function to within +/- 1 degree of set temp)
            % Apply temperature calibration to find the temperature to set on each hotplate
            MD(mu).ExpData.Setup.CalTempH = CorrectT(app,MD(mu).ExpData.Setup.TempH,mu); %Set Hotplate Set Stress Temp Based on Hotplate Thermocouple Calibration (C). MD(mu).ExpData.Setup.TempH is the user-defined temp
            MD(mu).ExpData.Setup.CalTempC = CorrectT(app,MD(mu).ExpData.Setup.TempC,mu); %Set Hotplate Set Cool Temp Based on Hotplate Thermocouple Calibration (C)

            setHotPlateTemperature(app,MD,mu,MD(mu).ExpData.Setup.CalTempC); % Execute Function to Set Hotplate Temperaure

            if(getTC(app,mu) > MD(mu).ExpData.Setup.TempC) %If Thermocouple temperature is greater than the cool/measurement temperature
                writeDigitalPin(app.HW(mu).Arduino,'A1',1) %Turn on Fan
                MD(mu).MDdata_fanflag=1; % Set fan flag
            else
                writeDigitalPin(app.HW(mu).Arduino,'A1',0) %Turn off Fan
                MD(mu).MDdata_fanflag=0; % Set fan flag
            end

            % General parameters values
            MD(mu).ExpData.Setup.stressBiasValue=app.Bias_gnl.Value; % Bias value
            MD(mu).ExpData.Setup.biastime_sec = tInSec(app, string(app.t_inc_unit_gnl.Value), app.dt_gnl.Value); % Bis time in seconds
            % store voltage in MD structure for each pin p (because this is the way FVBfitNDeriv_ext uses the voltage)
            for p=1:8
                % This is not necessarily needed. Only used in RunIterCV to fill the voltage array in case it is not taken directly as output from the impedance analyzer.
                % See if the impedance analyzer outputs voltage correctly.
                % The voltage input sent to the analyzer is found directly from the values entered in the app panel by the user
                MD(mu).ExpData.Pin(p).Vinput = app.VNeg_gnl.Value:app.VStep_gnl.Value*1e-3:app.VPos_gnl.Value; % voltage sweep array for the CV measurement
            end

            % Initialize unit log parameters
            MD(mu).ExpData.log.Ttime = 0; % set log.Ttime, the log function will log the initialization point as the first value is 0 (needs to be a number as logvalues_ext.m will crash if empty)
            MD(mu).ExpData.log.Itime = 0;
            MD(mu).MDdata.CVStartTime=[];
            % Get initial temperature value
            InitTemp = getTC(app,mu);
            MD(mu).ExpData.log.T = InitTemp;
        end

        % Log current and temperature

        fprintf(app.HW(1).KEITH, ":SOUR:VOLT "+MD(1).ExpData.Setup.stressBiasValue); %Source Bias Voltage
        fprintf(app.HW(1).KEITH, ":OUTP ON"); %Turn On Source Output to allow initial current measurement (should be 0 as all pins are disconnected)

        for mu=1:3
            % Get initial current value
            MD(mu).ExpData.log.I=str2double(strsplit(query(app.HW(1).KEITH, ":READ?"),','))'; % measurement although all pins are disconnected from Keithley becasue an initial value is needed to have the same number of elements as in the time log array

            %% Initialize flags and counters
            MD(mu).MDdata.meas_flag=0; % Set meas_flag to 0 for all units to indicate that a measurement can start
            MD(mu).MDdata.stress_completed_flag=1; % Set stress completed flag to 1 (=true) to allow initial CV measurement
            MD(mu).MDdata.startbiastime=0; % condition to allow the initial meas to occur in fcncallback_ext (since the time will be smaller than the set bias time)
            MD(mu).MDdata.finish_flag=0; % Where is the finish flag updated? Should it be in RunIter CV after each measurement, if equals the max number of measurements then set to 1
            MD(mu).MDdata.cycle_counter=0; % Number of cycles performed (= number of bias iterations)
            MD(mu).MDdata.bias_on_flag=0; % Flag indicating that bias is on (used in stress_completed_ext
            % Hold all graphs
            hold(MD(mu).Plots.Temp,'on')
            hold(MD(mu).Plots.Current,'on')
        end
        app.stopFlag=0; % Flag to stop while loop


        tic; %Start recording time during measurement (logvalues_ext)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RUN PROCESS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        CV_timeLoop(app,MD,Prog_CV);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %                 %After completed meaurement
        %                 save(fileDest+"\"+app.DataFileName.Value+".mat"); %Save all workspace data
    else % else for if app.idleFlag == 1
        warndlg('Another process is currently running','System error');
    end % end for if app.idleFlag == 1
end

