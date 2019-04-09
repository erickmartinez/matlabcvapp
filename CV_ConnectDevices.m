function HW = CV_ConnectDevices(app)
% CV_ConnectDevices(app)
%   A function to open the connection to all the instruments
%   and set initial configurations if required
%   
%   Parameters
%   ----------
%   app : Obj
%       The handle to the app designer GUI object
%   Returns
%   -------
%   HW : struct
%       A data structure with all the devices

% Tables containing COM port numbers for each hotplate
HP_COM_table=[9,5,10];
% Tables containing COM port numbers for each Arduino
Ard_COM_table=[8,7,6];


    % First make sure all devices are disconnected
    CV_DisconnectDevices(app);
    message0='Initializing Instruments... Please Wait';
    success = 1;
    wb = waitbar(0,message0);
    pause(0.5);
    for i=1:3
        % Print waitbar
        message1=['Initializing Instruments:Hotplate ',num2str(i),'... Please Wait'];
        waitbar((2*i-1)/8,wb,message1);

        % Connect the hot plates
        COM_HP = ['COM',num2str(HP_COM_table(i))]; 
        try
            % Define serial connection to hotplate
            HW(i).HP = serial(COM_HP, 'BaudRate', 9600, 'DataBits',8,'StopBits',1); 
            % Open Connection
            fopen(HW(i).HP); 
            %Set timeout to 3 second
            set(HW(i).HP, 'timeout',3); 
            turnHPLampOnOff(app,i,1);
            pause(0.5);
        catch e
            display(e.message);
            success = 0;
        end

        % Print waitbar
        message2=['Initializing Instruments:Arduino ',num2str(i),'... Please Wait'];
        waitbar((2*i)/8,wb,message2);

        % Disconnect the arduinos
        COM_Ard = ['COM',num2str(Ard_COM_table(i))]; % CHECK THE PORT NUMBERS FOR EACH ARDUINO
        try 
            %Define arduino connection
            HW(i).Arduino = arduino(COM_Ard,'Uno','Libraries','SPI');
            %Define connection through arduino to thermocouple
            HW(i).Therm = spidev(HW(i).Arduino,'D10','Bitrate',5e6); 
            turnArduinoLampOnOff(app,i,1);
            pause(0.5);
        catch e
            success = 0;
            display(e.message);
        end
    end
    % Print waitbar
    message3='Initializing Instruments:Keithley ... Please Wait';
    waitbar(7/8,wb,message3);
    % Define visa connection to K2401
%     k = 0;
    try 
        k = visa('agilent', 'GPIB0::25::INSTR'); 
        %Set data buffer size (important to read out all current data)
        set(k, 'InputBufferSize', 64*1024); 
        %Open visa object
        fopen(k);
        set(k,'Timeout',10); %Set timeout

        fprintf(k, '*RST') %Reset K2401
        fprintf(k, ":OUTP:SMOD HIMP") % Sets High Impedance Mode
        fprintf(k, ':ROUT:TERM REAR') %Set I/O to Rear Connectors
        fprintf(k, ':SENS:FUNC:CONC OFF') %Turn Off Concurrent Functions
        fprintf(k, ':SOUR:FUNC VOLT') %Voltage Source Function
        fprintf(k, ":SENSE:FUNC 'CURR:DC'") %DC Current Sense Function
        fprintf(k, ":SENSE:CURR:PROT .105") %Set Compliance Current to 105 mA
        fprintf(k, ':SOUR:VOLT:MODE FIX') %Set Voltage Source Sweep Mode
        fprintf(k, ":SOUR:DEL .1") %100ms Source Delay
        fprintf(k, ":FORM:ELEM CURR") %Select Data Collecting Item Current (FORMAT CURRENT, see short-form rule p.338 Keithley 2400.). Remove to also read voltage?
        app.StatusLampKeithley.Color = [0 1 0];
    catch e
        success = 0;
        display(e.message);
    end
    pause(0.5);
    % Print waitbar
    message4=['Initializing Instruments:Impedance Analyzer ... Please Wait'];
    waitbar(1,wb,message4);
%     v = 0;
    try
        %Define visa object to Impedance Analyzer
        v = visa('agilent', 'GPIB0::17::INSTR');
        %Set data buffer size (important to read out all CV data)
        set(v, 'InputBufferSize', 64*1024); 
        set(v,'Timeout',120); %Set visa timeout
        fopen(v); %Open visa
        app.StatusLampImpedance.Color = [0 1 0];
    catch e
        success = 0;
        display(e.message);
    end
    
    pause(0.5);
    close(wb)
    
    % If no errors proceed
    if success == 1
        % Save the keihtley and impedance analyzer objects in the HW
        % structure
        for i=1:3
            HW(i).KEITH = k;
            HW(i).IMPA  = v;
        end
        % Turn the connected flag on
        app.devicesConnected = 1;
    else
        HW = 0;
        CV_DisconnectDevices(app);
        app.PowerSwitch.Value = 'Off';
    end
end

